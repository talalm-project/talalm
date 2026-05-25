# Notebook

A notebook is a record that allows the user to utilize AI to ask about files uploaded specific to the notebook. To do this, it will utilize a large language model and and an embedding model. A notebook will be associated to a connector to know which LLM and embedding model to user.

## High Level Overview

A user creates a notebook by giving it a `title` and the associated `connector` ( `connector_id` ). The notebook will then have a `data` attribute that will copy the details of the `data` of the connector to it. Once a notebook is created, a user can upload documents related to that notebook. The system should then turn it into embeddings and store it in its own exclusive table.

## Role of the Large Language Model

The LLM is in charge of inferencing. When a user asks something it will need to associate the prompt with the necessary records as with a RAG system (Retrieval Augmented Generation). The system prommpt should look something like:

```
You are a helpful assistant. Only answer within the context it is provided.
```

## Role of the Embedding Model

The Embedding Model is in charge of converting tokens into embeddings. The prompt of the user will be converted into embeddings. The documents uploaded relative to a notebook will be converted to embeddings.

## File Uploads

A file is uploaded in relation to a notebook. The system will create a custom key (uuid) that represents the file. It will store the `file_type` and `file_size` of the file. The user can create their own `name` for the file but by default, it will use the uploaded file's name. Files are stored as objects via the `rustfs` service.

## Models

All models should have `created_at` and `updated_at` fields.

### Notebook

**Attributes**

* `title`: A `string` value representing the title of the notebook
* `data`: A `jsonb` representation of notebook metadata
* `connector_id`: A `uuid` foreign key that belongs to a connector
* `status`: string representing the status of the notebook. Possible values are `pending` or `active` where the default is `pending`.
* `user_id`: Foreign key representing the user who owns this notebook

### NotebookFile

* `name`: The name of the file
* `file_type`: String representing the file type
* `file_size`: Float representing the size of the file (in bytes)
* `object_key`: Key of the uploaded file in the object storage
* `notebook_id`: `uuid` foreign key that belongs to a notebook
* `status`: String represnting the status of a file where the default is `pending`. Other possible status would be `processing` or `active`.

### ChatSession

* `name`: A name associated with this session
* `data`: A `jsonb` attribute for session-level metadata. This should store data that applies to the whole chat session, such as the system prompt, connector snapshot, LLM settings, and embedding model settings used for the session.
* `notebook_id`: Foreign key relating this session to a notebook

### ChatMessage

A chat message represents one ordered message within a chat session. The conversation should be stored as `ChatMessage` records instead of being stored directly inside `ChatSession.data`.

* `chat_session_id`: `uuid` foreign key that belongs to a chat session
* `role`: String representing who created the message. Possible values are `user`, `assistant`, or `system`.
* `content`: Text content of the message
* `data`: A `jsonb` attribute for message-specific metadata. For assistant messages, this can include retrieved RAG context, model details, token usage, finish reason, or error details. For user messages, this can include prompt-related metadata such as attachments or embedding query references.
* `status`: String representing the status of the message. Possible values are `pending`, `processing`, `completed`, or `failed`.
* `parent_message_id`: Optional `uuid` foreign key to another chat message. This is useful for retries, regenerated answers, or conversation branching.
