# Computer Use, Files, and Artifacts

This reference document outlines the rules for file creation, directory locations, and React/HTML artifact development adapted for the **Antigravity** agent environment.

---

## 1. File Creation and Formatting Rules

### When to Create a File vs. Respond Inline
* **Create a File (Standalone Artifact)**:
  * Any blog post, article, creative writing, story, essay, or social post (regardless of length).
  * Any code block or script containing more than 20 lines of code.
  * Deliverables that are explicitly requested to be saved, downloaded, or shared.
* **Respond Inline (Conversational)**:
  * Any strategy, summary, outline, brainstorm, or explanation.
  * Short code snippets (<= 20 lines).
  * Conversational answers should follow a natural prose structure with minimal styling and headings.

### File Extensions
* **Reports and Documents**: Prefer `.md` or `.html`. Use `.docx` only if the user explicitly requests a Word document or signals a client-facing formal deliverable.
* **Presentations**: Use `.pptx`.
* **Spreadsheets**: Use `.xlsx` or `.csv`.

---

## 2. Directory Structure and Workspace in Antigravity

* **Active Workspace Root**: Antigravity runs locally. The active workspace root is the local directory of the user's project (e.g. `/home/kwbyun/workspace/harness_antigravity`). You may read and write files directly in this workspace.
* **Artifact Directory**: When creating user-facing reports, tables, diagrams, or UI mockups, save them in markdown format in the conversation-specific artifact directory: `<appDataDir>/brain/<conversation-id>/` (e.g., `/home/kwbyun/.gemini/antigravity-cli/brain/5e49373a-afdd-4737-81ef-23741d6f97ee/`).
* **Scratch Directory**: Store temporary test scripts or scratch code in `<appDataDir>/brain/<conversation-id>/scratch/` directory.
* **Showing Files**: Antigravity does **not** have a `present_files` tool. To share or present files to the user, write them to the workspace or the artifact folder and provide clickable markdown links with the `file://` scheme (e.g. `[filename](file:///absolute/path/to/file)`).

---

## 3. Artifact Development Constraints (React & HTML)

### Storage & State Rules
* **Browser Storage Supported**: Unlike Claude's sandbox, standard browser-native storage APIs (`localStorage`, `sessionStorage`, `IndexedDB`) work perfectly in local browser environments and previews under Antigravity. Use them for client-side state persistence.
* **In-Memory & State**: Keep UI state in React state (`useState`, `useReducer`) or standard JavaScript variables during the session.
* **Cross-Session Storage**: For Claude compatibility, use `window.storage` API only when explicitly preparing code to run inside the Claude.ai platform.

### UI Guidelines
* **No Form Tags**: **NEVER** use HTML `<form>` tags in React Artifacts. Use standard button event handlers (e.g., `<button onClick={handleSubmit}>`) for submissions.
* **Single-File Preference**: Bundle HTML, CSS, and JS into a single file unless explicitly requested otherwise.

### Approved React Libraries
You can import the following libraries in React (`.jsx`) artifacts:
* **UI & Icons**: `lucide-react@0.383.0`, `shadcn/ui` (imported from `@/components/ui/...`)
* **Data Visualization**: `recharts` (e.g., `import { LineChart } from 'recharts'`), `plotly`, `chart.js`, `d3`
* **Math & Utilities**: `lodash` (e.g., `import _ from 'lodash'`), `mathjs`, `papaparse` (CSV), `xlsx` (SheetJS)
* **Audio & ML**: `tone` (Tone.js), `tensorflow`
* **3D Rendering**: `three` (version r128 - note: `THREE.OrbitControls` is unavailable, and `THREE.CapsuleGeometry` requires r142+, so use custom shapes).
