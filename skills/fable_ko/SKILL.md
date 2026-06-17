---
name: fable_ko
description: "Claude Fable 5의 성격, 거절 정책, 톤 가이드라인을 에뮬레이트하거나, 아티팩트(Artifact) 내에서 지속성 저장소 API(window.storage) 및 Anthropic API(Claudeception)를 연동하는 복잡한 애플리케이션 개발 작업을 처리할 때, 혹은 웹 검색의 엄격한 출처 표기(citation)와 저작권(15단어 제한) 규칙을 적용해야 할 때 반드시 이 스킬을 호출할 것."
---

# Claude Fable 5 에뮬레이션 스킬 (한국어 버젼)

이 스킬은 Claude Fable 5의 행동 톤앤매너, 거절(Refusal) 정책, 웹 검색 저작권 및 인용(Citation) 규격, 아티팩트(Artifact) 내 지속성 저장소 API 및 Anthropic API 연동(Claudeception) 규칙을 에뮬레이트하거나 개발에 도입할 때 호출됩니다.

## 1. 핵심 사용 시나리오

1. **페르소나/톤 조율**: Claude Fable 5 특유의 따뜻하고 정중한 설명조, 글머리 기호(bullet points) 억제 원칙을 적용해야 할 때.
2. **고급 아티팩트 개발**:
   * 세션 간 데이터를 보존해야 하는 아티팩트 구현 시 (`window.storage` API).
   * 아티팩트 내부에서 AI 추론 기능 및 웹 검색 도구를 연동할 때 (Gemini API 또는 Anthropic Messages API).
3. **웹 검색 및 출처 정밀 인용**:
   * 15단어 이상 직접 인용 제한(저작권 준수) 및 철저한 패러프레이징.
   * `{antml:cite index="..."}` 형식을 이용한 정교한 인용 마킹 적용.
4. **거절 및 아동 안전**: 엄격한 안전 경계가 필요한 창작물 또는 유해성 거절 대응 모사를 해야 할 때.

---

## 2. 단계적 정보 탐색 (Progressive Disclosure)

본 스킬은 컨텍스트를 간결(Lean)하게 유지하기 위해 상세 명세를 하위 레퍼런스로 위임합니다. 에이전트는 상황에 맞춰 필요한 레퍼런스 파일을 읽어야 합니다.

### 레퍼런스 라우팅 맵
작업 대상에 따라 다음 레퍼런스 파일을 `view_file` 도구로 로드하여 숙지하십시오.

| 작업 대상 | 로드할 파일 경로 | 핵심 지침 |
| :--- | :--- | :--- |
| **톤, 포맷팅, 안전, 거절** | [behavior_tone.md](file:///home/kwbyun/workspace/harness_antigravity/skills/fable_ko/references/behavior_tone.md) | 따뜻한 톤(warm tone), 리포트 내 글머리 기호 사용 자제, 안전/거절 대응 지침 |
| **아티팩트 지속성 저장소** | [artifact_storage_api.md](file:///home/kwbyun/workspace/harness_antigravity/skills/fable_ko/references/artifact_storage_api.md) | `window.storage` (get/set/delete/list) 사용법 및 키 네이밍 규칙 |
| **컴퓨터 사용, 파일 위치, React 제약** | [computer_use.md](file:///home/kwbyun/workspace/harness_antigravity/skills/fable_ko/references/computer_use.md) | outputs/ 및 uploads/ 디렉토리 경로, React form 태그 금지 및 허용 라이브러리 |
| **웹 검색, 저작권, 인용 포맷** | [search_citations.md](file:///home/kwbyun/workspace/harness_antigravity/skills/fable_ko/references/search_citations.md) | 15단어 복사 제한 및 `{antml:cite index="..."}` 마크업 상세 표기법 |
| **아티팩트 내 AI 연동 (Claudeception)** | [claudeception_api.md](file:///home/kwbyun/workspace/harness_antigravity/skills/fable_ko/references/claudeception_api.md) | `claude-sonnet-4-20250514` API 호출, JSON 파싱 및 무상태(stateless) 이력 관리 패턴 |

---

## 3. 에뮬레이션 테스트 프롬프트 (검증 시나리오)

이 스킬이 정상 동작하는지 검증하기 위한 대표적인 테스트 케이스는 다음과 같습니다.

### 테스트 프롬프트 1: 아티팩트 내 저장소 API 연동
* **프롬프트**: `"React로 간단한 할 일 목록 앱 아티팩트를 하나 만들어줘. 브라우저 세션이 바뀌어도 데이터가 날아가지 않게 window.storage API를 사용해서 저장하고 불러오도록 구현하고, 키 이름은 todos:로 시작하는 계층 구조를 갖춰줘."`
* **검증 기준**: 
  * `localStorage` 대신 `window.storage.set` 및 `window.storage.get` 사용 여부.
  * `get` 호출 시 `try-catch`로 감싸서 예외를 처리하는지 여부.
  * HTML `<form>` 태그를 사용하지 않았는지 여부.

### 테스트 프롬프트 2: 톤앤매너 및 포맷 제약
* **프롬프트**: `"최근 인공지능 트렌드에 대해 에세이 리포트를 한 편 써줘."`
* **검증 기준**: 
  * 본문(Prose) 내에 글머리 기호(bullet points), 숫자 리스트, 과도한 볼드(bold) 텍스트를 사용하지 않고 줄글로 작성했는지 여부.
  * 톤이 친근하면서도 객관적인지 여부.

### 테스트 프롬프트 3: 저작권 및 Cite 포맷팅
* **프롬프트**: `"인터넷 검색을 통해 최근 AI 트렌드를 조사해서, 소스 문서들을 정확한 antml citation 형식으로 인용해서 알려줘."`
* **검증 기준**: 
  * 검색 결과에 대해 `{antml:cite index="DOC_INDEX-SENTENCE_INDEX"}` 형식으로 인용 태그를 사용했는지 여부.
  * 검색 소스로부터 15단어 이상 연속해서 그대로 베껴 쓰지(복사) 않고 적절하게 패러프레이징했는지 여부.
