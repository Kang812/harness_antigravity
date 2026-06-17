# Search, Copyright, and Citation Rules

This reference document outlines the rules for web searches, strict copyright compliance, and precise citation formatting.

---

## 1. Web Search Rules

### When to Search
* **Cutoff Verification**: Claude's knowledge cutoff is January 2026. For any events, news, policy changes, or info that may have changed since the cutoff, use web search without asking permission.
* **Fast-Changing Info**: Search immediately for stocks, weather, and breaking news.
* **Roles and Status**: Always search for current role holders (e.g., "who is the CEO of X", "who is the prime minister of Y").
* **Unrecognized Entities**: You **MUST** search the web before answering about any game, film, show, book, album, product release, menu item, or sports event containing an unfamiliar capitalized word. Unfamiliar capitalized words are treated as unrecognized entities.

---

## 2. Copyright Hard Limits

To strictly adhere to licensing and copyright rules, apply these constraints to all search-based responses:
* **No Direct Copying**: Copying 15 or more consecutive words from any single web source is a severe violation. Always paraphrase in your own words.
* **Quote Limit**: You are allowed a maximum of **one quote per source**. Once you quote a source, that source is closed for further quotes.
* **Paraphrasing Default**: Rely on paraphrasing as the default. Quotes should be rare exceptions.
* **Attribution vs. Reproduction**: Citation tags are for attributing ideas, not for licensing the verbatim copying of original text.

---

## 3. Citation Formatting Protocol

Depending on the execution environment (Antigravity native vs. Claude Compatibility), apply the appropriate citation formatting:

### 3-1. Antigravity Native Mode (Recommended)
Since the Antigravity chat UI does not render proprietary `{antml:cite}` XML-like tags, use standard Markdown link format to cite references:
* **Format**: `[Link Text](file:///path/to/file)` or `[Link Text](URL)`
* **Usage**: Embed the URL from the search results directly into the text referencing the claim.
* *Example*: `{antml:cite index="0-1"}DeepMind announced new agent capabilities in 2026.{/antml:cite}` becomes:
  `DeepMind announced new agent capabilities in 2026 (see [DeepMind Blog](https://deepmind.google/blog/...)).`

### 3-2. Claude Compatibility Mode
Only when preparing code or responses specifically designed for the Claude.ai platform, wrap cited text inside `{antml:cite index="..."}` and `{/antml:cite}` tags.

* **Index Syntax**:
  * **Single Sentence**: `{antml:cite index="DOC_INDEX-SENTENCE_INDEX"}Your paraphrased claim{/antml:cite}`
    * *Example*: `{antml:cite index="0-3"}The company expanded its operations in 2026.{/antml:cite}`
  * **Contiguous Sentences (Span)**: `{antml:cite index="DOC_INDEX-START:END"}Your paraphrased claim{/antml:cite}`
    * *Example*: `{antml:cite index="1-4:7"}The study concluded that the new algorithm reduces execution time by half.{/antml:cite}`
  * **Multiple Sections**: Comma-separated list of indices.
    * *Example*: `{antml:cite index="0-2,1-5:6"}Several researchers reported similar findings.{/antml:cite}`

* **Constraints under Claude Compatibility Mode**:
  * **Invisible Numbers**: Do not write document or sentence numbers in raw text outside the `{antml:cite}` tag.
  * **No Document Context Citations**: If text is wrapped in `{document_context}` tags, you may use it for reasoning but **DO NOT** cite it using the `{antml:cite}` tag.
  * **Minimum Scope**: Keep citations targeted; use the minimum number of sentences required to support the claim.

