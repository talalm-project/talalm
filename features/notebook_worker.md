# Notebook Worker

The notebook worker is a long-running process that embeds uploaded notebook
files into the shared `notebook_vectors` table.

## Command

Start the worker from the backend project:

```bash
python -m app.cli system:start_notebook_worker
```

The CLI loads the active environment, configures the database, creates a
`NotebookWorker`, and starts it.

## Loop Behavior

`NotebookWorker` runs indefinitely until interrupted.

Every loop:

1. Log that the worker is polling for pending notebook files.
2. Query `notebook_files` for one row with `status = 'pending'`, ordered by
   `created_at ASC`.
3. On PostgreSQL, use `FOR UPDATE SKIP LOCKED` so multiple workers can avoid
   processing the same file at the same time.
4. If no pending file exists, log that nothing was found.
5. If a pending file exists, instantiate `EmbedNotebookFile`.
6. Run the embedding command.
7. Log success or failure.
8. Close the database session.
9. Sleep for 5 seconds before the next loop.

Each loop opens a fresh database session. This keeps transactions short and
prevents a long-running worker from holding stale ORM state.

## Embedding Flow

`EmbedNotebookFile` owns the file-level embedding workflow:

1. Set the `NotebookFile` status to `processing`.
2. Download the file from RustFS using `notebook_files.object_key`.
3. Generate embeddings using the notebook connector's embedding settings.
4. Delete any existing vectors for that notebook file.
5. Insert new `notebook_vectors` rows tied to:
   * `notebook_id`
   * `notebook_file_id`
   * `embedding_config_id`
6. Set the file status to `active` on success.
7. Set the file status to `failed` when embedding generation fails.

## Logging

The worker logs:

* worker startup
* each polling attempt
* no-work cycles
* the file selected for processing
* successful embedding completion
* embedding failures
* unexpected loop exceptions
* shutdown/interruption

The CLI configures standard Python logging with timestamps and logger names.

## Operational Notes

Only one pending file is processed per loop. This keeps each worker simple and
makes the 5-second polling interval predictable.

Multiple worker processes can be run later if throughput becomes a concern.
The `FOR UPDATE SKIP LOCKED` claim query is intended to support that future
mode on PostgreSQL.
