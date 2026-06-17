# LLM API inside Artifacts (Claudeception & Gemini Integration)

This reference document explains how to call LLM APIs inside React/HTML Artifacts. Since this skill is running in the **Antigravity** environment, we distinguish between **Claude Compatibility Mode** and **Antigravity / Gemini Native Mode**.

---

## 1. Antigravity / Gemini Native Mode (Recommended)

When developing artifacts to run within the Antigravity sandbox or generic browser environments, there is no keyless proxy. The standard pattern is to request a Gemini API key from the user via a settings UI input and call the Google Gemini Developer API directly.

### API Specification
* **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=${API_KEY}`
* **Method**: `POST`
* **Headers**:
  ```json
  {
    "Content-Type": "application/json"
  }
  ```

### Example Gemini Fetch Call
```javascript
const makeGeminiCall = async (apiKey, userPrompt) => {
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=${apiKey}`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        contents: [
          {
            parts: [{ text: userPrompt }]
          }
        ],
        generationConfig: {
          maxOutputTokens: 1000
        }
      })
    }
  );

  if (!response.ok) {
    throw new Error(`Gemini API Error: ${response.status}`);
  }
  const data = await response.json();
  return data.candidates[0].content.parts[0].text;
};
```

---

## 2. Claude Compatibility Mode

If you are developing artifacts specifically to be deployed or run within the Claude.ai platform (using their keyless proxy), use the Anthropic Messages API.

* **Endpoint**: `https://api.anthropic.com/v1/messages` (Keyless, handled by Claude.ai platform)
* **Method**: `POST`
* **Model**: **MUST** be `"claude-sonnet-4-20250514"`
* **Max Tokens**: `1000`

### Example Anthropic Fetch Call
```javascript
const makeAnthropicCall = async (userPrompt) => {
  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-20250514",
      max_tokens: 1000,
      messages: [
        { role: "user", content: userPrompt }
      ]
    })
  });
  
  if (!response.ok) {
    throw new Error(`Anthropic API Error: ${response.status}`);
  }
  const data = await response.json();
  return data.content
    .map(item => (item.type === "text" ? item.text : ""))
    .filter(Boolean)
    .join("\n");
};
```

---

## 3. Parsing Structured JSON Responses

To get structured data (e.g., game state, tables), instruct the model in its system prompt to return ONLY JSON without markdown backticks. Clean and parse the response:

```javascript
const parseStructuredResponse = (rawText) => {
  try {
    const cleanedText = rawText.replace(/```json|```/g, "").trim();
    return JSON.parse(cleanedText);
  } catch (error) {
    console.error("JSON parsing error:", error);
    return null;
  }
};
```

---

## 4. Multi-turn State Management

Since client-side API calls are stateless, you must maintain and pass the state in the messages/contents array:
* **Gemini (Multi-turn)**: Pass a list of `contents` with `user` and `model` roles.
* **Anthropic (Multi-turn)**: Pass a list of `messages` with `user` and `assistant` roles.
