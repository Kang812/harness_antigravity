# 아티팩트 내 LLM API 연동 (클로드셉션 및 Gemini 통합 지침)

이 참조 문서는 React/HTML 아티팩트 내부에서 LLM API를 호출하는 기법을 정의합니다. 본 스킬은 **Antigravity** 에이전트 환경에서 가동되므로, 플랫폼 독립적인 **Antigravity / Gemini 네이티브 모드**와 Claude 플랫폼 배포를 위한 **Claude 호환 모드**를 나누어 설명합니다.

---

## 1. Antigravity / Gemini 네이티브 모드 (권장)

Antigravity 샌드박스 또는 일반적인 웹 브라우저 환경에서 작동하는 아티팩트를 개발할 때는 키가 없는 프록시 서버를 이용할 수 없습니다. 대신, 아티팩트 UI 상에서 사용자로부터 직접 Gemini API Key를 입력받아 Google의 Gemini Developer API를 호출하는 패턴이 표준입니다.

### API 호출 스펙
* **호출 주소 (Endpoint)**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=${API_KEY}`
* **요청 메서드**: `POST`
* **요청 헤더**:
  ```json
  {
    "Content-Type": "application/json"
  }
  ```

### Gemini API 호출 구현 예시 코드
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
    throw new Error(`Gemini API 호출 에러: ${response.status}`);
  }
  const data = await response.json();
  return data.candidates[0].content.parts[0].text;
};
```

---

## 2. Claude 호환 모드 (Claude Compatibility Mode)

작성한 아티팩트를 최종적으로 Claude.ai 플랫폼 내에서 무키(keyless) 프록시를 통해 연동하여 가동시키는 것이 목적일 때만 Anthropic Messages API 형식을 사용합니다.

* **호출 주소 (Endpoint)**: `https://api.anthropic.com/v1/messages` (Claude.ai 플랫폼이 자동으로 인증키를 관리)
* **요청 메서드**: `POST`
* **대상 모델 (Model)**: 반드시 **`"claude-sonnet-4-20250514"`** 모델 고정
* **최대 토큰수 (Max Tokens)**: `1000`

### Anthropic API 호출 구현 예시 코드
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
    throw new Error(`Anthropic API 호출 에러: ${response.status}`);
  }
  const data = await response.json();
  return data.content
    .map(item => (item.type === "text" ? item.text : ""))
    .filter(Boolean)
    .join("\n");
};
```

---

## 3. 구조화된 JSON 응답 파싱

API로부터 게임 상태나 표 등 정형 데이터를 돌려받으려면, 시스템 프롬프트에 마크다운 백틱 없이 순수 JSON으로만 출력하도록 요청하십시오. 클라이언트에서는 다음과 같이 백틱 지시어를 지운 후 안전하게 파싱합니다:

```javascript
const parseStructuredResponse = (rawText) => {
  try {
    const cleanedText = rawText.replace(/```json|```/g, "").trim();
    return JSON.parse(cleanedText);
  } catch (error) {
    console.error("JSON 파싱 에러:", error);
    return null;
  }
};
```

---

## 4. 멀티턴 및 대화 상태 관리

클라이언트 측에서 호출하는 API는 대화 상태를 스스로 유지하지 못하므로, 전체 대화 내역이나 상태 상태를 `contents` 또는 `messages` 배열에 지속적으로 누적하여 전달해야 합니다:
* **Gemini (멀티턴)**: `user` 및 `model` 역할의 `parts`를 지닌 `contents` 리스트를 구성하여 전달합니다.
* **Anthropic (멀티턴)**: `user` 및 `assistant` 역할을 지닌 `messages` 리스트를 누적하여 전달합니다.
