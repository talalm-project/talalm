# Notebook Vectors

Notebook document vectors should be stored in a shared schema instead of a
runtime-created table per notebook. The main reason is that dynamic tables are
hard to migrate, hard to index consistently, and awkward for SQLAlchemy/Alembic
to reason about. The system can still preserve notebook-specific retrieval by
filtering vector rows by notebook and embedding configuration.

## Goal

When a notebook is created from a connector, the notebook has an associated LLM
configuration and embedding configuration. Uploaded notebook files are chunked
and embedded using that embedding configuration. The resulting vectors are used
later for RAG retrieval when a user asks questions in the notebook.

Different notebooks may use different embedding models, and those models may
produce different vector dimensions. The storage design must support this
without creating one physical vector table per notebook.

## Recommended Design

Use two Alembic-managed tables plus an explicit notebook reference:

1. `embedding_configs`
2. `notebook_vectors`
3. `notebooks.embedding_config_id`

`embedding_configs` records the embedding model identity and dimensionality.
`notebook_vectors` stores all notebook chunks and their vectors in one shared
table. `notebooks.embedding_config_id` records which embedding configuration
the notebook committed to when it was created.

### `embedding_configs`

This table stores the exact embedding configuration used to produce a set of
vectors. It should be treated as immutable once vectors reference it.

Suggested columns:

* `id`: UUID primary key
* `connector_id`: UUID foreign key to `connectors.id`
* `provider`: string, for example `local` or `openai`
* `model_name`: string
* `model_path`: nullable string for local GGUF embedding models
* `dimensions`: integer vector size produced by the model
* `distance_metric`: string, for example `cosine`
* `options`: jsonb model/runtime options used for embedding generation
* `config_hash`: stable hash of provider, model identity, dimensions, metric,
  and options
* `created_at`: timestamp
* `updated_at`: timestamp

Recommended constraints and indexes:

* Unique index on `config_hash`
* Index on `connector_id`
* `dimensions` must be positive
* `provider` should be constrained in application code to supported providers

The `config_hash` lets the system reuse an existing config row when multiple
notebooks on the same connector use the same embedding setup. The hash should
include the connector id, provider, model identity, dimensions, distance metric,
and model options. Scoping reuse to a connector keeps `connector_id` accurate
while still avoiding duplicate rows for repeated notebooks.

`EmbeddingConfig` is not a 1-to-1 child of `Notebook`. It is a reusable
configuration row. One connector can have many embedding configs over time, and
many notebooks can reference the same embedding config.

### `notebooks.embedding_config_id`

Every newly created notebook should store the resolved embedding config:

* `embedding_config_id`: UUID foreign key to `embedding_configs.id`

The notebook should keep this value stable. If a connector is edited later,
existing notebooks should not silently change embedding config. New notebooks
can resolve to a different config if the connector's embedding metadata changed.

### `notebook_vectors`

This table stores chunk text, embeddings, and chunk/source metadata for all
notebooks.

Suggested columns:

* `id`: UUID primary key
* `notebook_id`: UUID foreign key to `notebooks.id`
* `embedding_config_id`: UUID foreign key to `embedding_configs.id`
* `notebook_file_id`: nullable UUID foreign key to a future `notebook_files.id`
* `chunk_index`: integer
* `text`: text chunk used to generate the embedding
* `embedding`: pgvector `vector` column without a fixed dimension
* `metadata`: jsonb chunk metadata such as page, slide, sheet, source name, or
  parser details
* `created_at`: timestamp
* `updated_at`: timestamp

Recommended constraints and indexes:

* Index on `notebook_id`
* Index on `embedding_config_id`
* Composite index on `notebook_id, embedding_config_id`
* Unique index on `notebook_file_id, chunk_index` when `notebook_file_id` is not
  null

The `embedding` column should be declared as an unbounded pgvector column:

```sql
embedding vector
```

This allows one table to hold vectors with different dimensions. Queries must
only compare vectors with rows from the same embedding configuration.

## Query Pattern

RAG retrieval should always filter by both notebook and embedding config before
ordering by vector distance.

Example shape:

```sql
SELECT notebook_vectors.*
FROM notebook_vectors
WHERE notebook_id = :notebook_id
  AND embedding_config_id = :embedding_config_id
ORDER BY embedding <=> :query_embedding
LIMIT :limit;
```

The query embedding must be generated using the same `embedding_config_id`.
Comparing vectors from different embedding models or dimensions is invalid for
RAG retrieval.

## Vector Indexing

Because `notebook_vectors.embedding` is unbounded, a single generic HNSW or
IVFFlat index is not enough for all dimensions. Start with exact search while
the dataset is small. Add dimension-specific partial expression indexes as data
volume grows.

Example for 1536-dimensional cosine search:

```sql
CREATE INDEX notebook_vectors_1536_cosine_hnsw
ON notebook_vectors
USING hnsw ((embedding::vector(1536)) vector_cosine_ops)
WHERE embedding_config_id IN (
  SELECT id FROM embedding_configs WHERE dimensions = 1536
);
```

If PostgreSQL does not allow the subquery in the partial index predicate for
the target version, use a denormalized `embedding_dimensions` column on
`notebook_vectors` and keep it in sync from `embedding_configs`.

Then query with the matching cast:

```sql
SELECT notebook_vectors.*
FROM notebook_vectors
WHERE notebook_id = :notebook_id
  AND embedding_config_id = :embedding_config_id
ORDER BY embedding::vector(1536) <=> :query_embedding::vector(1536)
LIMIT :limit;
```

## Notebook Lifecycle

When a notebook is pending, the system should prepare its embedding config, not
create a physical vector table.

Suggested flow:

1. User creates a notebook with a connector.
2. System snapshots connector data into `notebooks.data`.
3. System resolves or creates an `embedding_configs` row from the connector
   embedding metadata.
4. System stores that row on `notebooks.embedding_config_id`.
5. Notebook remains `pending` until files are uploaded and processed.
6. Uploaded files are chunked and embedded with the notebook's embedding config.
7. Chunks are inserted into `notebook_vectors` with the notebook and embedding
   config references.
8. Notebook can move to `active` once at least one file has completed vector
   processing, or once the application-specific readiness criteria are met.

If the connector cannot produce a complete embedding config, notebook creation
should fail with a validation error. In particular, the system needs an
embedding model name and a positive vector dimension before it can safely create
a notebook that will later store vectors in the shared table.

## Why Not Dynamic Tables

Creating one table per notebook would solve vector dimension differences by
physical separation, but it creates larger operational problems:

* Alembic cannot naturally track user-created runtime tables.
* SQLAlchemy models expect stable tables and mappings.
* Every schema change would need custom code to update all notebook-specific
  tables.
* Index creation, vacuuming, backups, monitoring, and cleanup become harder.
* Cross-notebook administration and analytics become more complex.
* Failed setup can leave orphaned tables.

The shared-table design keeps the schema stable while still ensuring vectors
are queried only within the correct notebook and embedding configuration.

## Implementation Notes

The implementation should add Alembic migrations and SQLAlchemy models for
`EmbeddingConfig`, `NotebookVector`, and the `notebooks.embedding_config_id`
foreign key. It should not add runtime table creation.

For pgvector support, the existing migration `0007_enable_pgvector.py` already
indicates the backend is prepared to use the extension. The application should
use the `pgvector` SQLAlchemy type if the dependency is added, or use explicit
migration SQL and carefully scoped raw SQL for vector search until ORM support
is introduced.

The connector metadata builder already records embedding model name, local
path, dimensions where known, and model options. That metadata should be the
source for resolving `embedding_configs`. Notebook creation should use that
metadata to find or create the embedding config before inserting the notebook.
