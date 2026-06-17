# Persistent Storage API for Artifacts

> [!IMPORTANT]
> **Antigravity Environment Note**: Antigravity runs locally and does not provide a native key-value proxy for `window.storage`. For native Antigravity artifacts, standard browser storage APIs (`localStorage`, `sessionStorage`, `IndexedDB`) work perfectly and should be used for client-side state retention. Use `window.storage` only when developing specifically for Claude Compatibility Mode.

This reference document defines the persistent storage API available to Claude Fable 5 Artifacts, enabling state retention across sessions.

---

## 1. Storage API Specification

Artifacts can read and write data via the global `window.storage` object. All operations are asynchronous.

### Methods

#### 1. Retrieve Value
* **Signature**: `await window.storage.get(key, shared?)`
* **Returns**: `{key: string, value: string, shared: boolean} | null`
* **Behavior**: Retrieves the record for the given key. Throws an error if the key does not exist.

#### 2. Store Value
* **Signature**: `await window.storage.set(key, value, shared?)`
* **Returns**: `{key: string, value: string, shared: boolean} | null`
* **Behavior**: Saves or updates the string value under the given key.

#### 3. Delete Value
* **Signature**: `await window.storage.delete(key, shared?)`
* **Returns**: `{key: string, deleted: boolean, shared: boolean} | null`
* **Behavior**: Deletes the specified key from storage.

#### 4. List Keys
* **Signature**: `await window.storage.list(prefix?, shared?)`
* **Returns**: `{keys: string[], prefix?: string, shared: boolean} | null`
* **Behavior**: Lists all keys matching the optional prefix.

---

## 2. Usage Examples

```javascript
// 1. Store personal data (default: shared = false)
const entry = { date: '2026-06-17', note: 'Learned Antigravity' };
await window.storage.set('entries:123', JSON.stringify(entry));

// 2. Store shared data (shared = true)
const score = { username: 'Alice', score: 950 };
await window.storage.set('leaderboard:alice', JSON.stringify(score), true);

// 3. Retrieve data (handling non-existence via try-catch)
let myEntry = null;
try {
  const result = await window.storage.get('entries:123');
  if (result) {
    myEntry = JSON.parse(result.value);
  }
} catch (error) {
  console.log('Key not found or retrieval failed:', error);
}

// 4. List keys with prefix
const listResult = await window.storage.list('entries:');
const keys = listResult ? listResult.keys : [];
```

---

## 3. Design Guidelines and Constraints

### Key Conventions
* **Hierarchical Structure**: Use colon-separated namespace patterns under 200 characters: `table_name:record_id` (e.g., `todos:todo_1`, `users:user_abc`).
* **Forbidden Characters**: Keys must not contain whitespace, path separators (`/`, `\`), or quotes (`'`, `"`).

### Data Scope
* **Personal Data** (`shared: false`, default): Accessible only by the user who wrote it.
* **Shared Data** (`shared: true`): Shared among all users viewing/running the artifact. Always notify users that their data will be visible to others when writing shared data.

### Limits and Error Handling
* **Mandatory Error Handling**: Accessing a non-existent key throws an error instead of returning `null`. Wrap all read operations in `try-catch`.
* **Batching**: Network operations are rate-limited. Batch related data together into a single key instead of updating individual fields separately (e.g., save the entire board configuration under `board:pixels` rather than a separate key for each pixel).
* **Data Limits**: Only text or JSON strings are supported (no binary/file uploads). Individual values must not exceed 5MB.
* **Concurrency**: Conflict resolution is resolved on a "Last-write-wins" basis.
