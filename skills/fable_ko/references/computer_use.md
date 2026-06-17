# 컴퓨터 사용, 파일 및 아티팩트 개발 지침 (Antigravity 최적화)

이 참조 문서는 **Antigravity** 에이전트 환경에 맞게 조정된 파일 생성 기준, 작업 디렉토리 위치, 그리고 React 및 HTML 아티팩트(Artifact) 개발 제약 조건을 정의합니다.

---

## 1. 파일 생성 및 출력 형식 규칙

### 파일을 생성할 때 vs. 대화창에 직접 응답할 때
* **파일로 생성하는 경우 (독립된 아티팩트)**:
  * 분량에 관계없이 블로그 포스트, 기사, 창작 글짓기, 에세이, 소셜 미디어 게시물 등을 작성할 때.
  * 작성하려는 코드 블록 또는 스크립트가 **20라인을 초과**할 때.
  * 사용자가 파일 다운로드, 저장, 공유 등의 동작을 명시적으로 요구할 때.
* **대화창 내 줄글로 답변하는 경우 (Inline)**:
  * 전략 보고서, 요약본, 개요, 브레인스토밍, 단순 기술적 설명 등.
  * 20라인 이하의 짧은 코드 스니펫.
  * 줄글 형태의 일반 답변은 불필요한 목록이나 불릿 기호 사용을 배제하고 간결한 prose 형식으로 응답합니다.

### 권장 파일 확장자
* **일반 문서**: 주로 `.md` 또는 `.html`을 사용합니다. 사용자가 공식적인 납품물 성격(예: "클라이언트 송부용")을 띄거나 워드 파일 포맷을 명시적으로 요구할 때만 `.docx`를 생성하십시오.
* **프레젠테이션**: `.pptx`를 생성합니다.
* **스프레드시트**: `.xlsx` 또는 `.csv`를 사용합니다.

---

## 2. Antigravity 작업 공간 및 디렉토리 규칙

* **활성 작업 공간 루트 (Workspace Root)**: Antigravity는 로컬 시스템에서 동작합니다. 활성 작업 공간은 사용자의 프로젝트 디렉토리(예: `/home/kwbyun/workspace/harness_antigravity`)입니다. 이 폴더 내부의 파일을 직접 읽고 쓸 수 있습니다.
* **아티팩트 저장소 (Artifact Directory)**: 사용자 대상 보고서, 표, 다이어그램, UI 디자인 시안을 담은 마크다운 아티팩트를 작성할 때는 개별 대화 아티팩트 폴더인 `<appDataDir>/brain/<conversation-id>/` (예: `/home/kwbyun/.gemini/antigravity-cli/brain/5e49373a-afdd-4737-81ef-23741d6f97ee/`)에 작성해야 합니다.
* **스크래치 디렉토리 (Scratch)**: 임시 테스트용 스크립트나 디버깅 코드는 스크래치 폴더인 `<appDataDir>/brain/<conversation-id>/scratch/` 내에 작성하여 활용하십시오.
* **파일 공유 방식**: Antigravity에는 `present_files` 도구가 **존재하지 않습니다**. 사용자에게 최종 파일을 전달하거나 노출하려면, 작업 공간이나 아티팩트 폴더에 파일을 작성한 다음 대화 창에 `file://` 스키마를 사용하는 클릭 가능한 마크다운 링크 형식(예: `[파일명](file:///absolute/path/to/file)`)으로 명시하십시오.

---

## 3. React 및 HTML 아티팩트 개발 제약 조건

### 저장소 및 세션 상태 제약
* **브라우저 스토리지 사용 가능**: Claude의 제한된 샌드박스와 달리, Antigravity 환경의 로컬 브라우저 및 프리뷰 화면에서는 네이티브 브라우저 저장소 API(`localStorage`, `sessionStorage`, `IndexedDB`)가 정상 작동합니다. 클라이언트 측 상태 보존이 필요할 경우 이를 적극적으로 사용할 수 있습니다.
* **인메모리 상태 활용**: 세션 내 일시적인 UI 상태 관리는 React 상태(`useState`, `useReducer`) 또는 일반 변수를 우선적으로 사용하십시오.
* **Claude 플랫폼 호환성**: 작성한 코드를 향후 Claude.ai 플랫폼 내에서 가동할 목적이 있을 때만 제한적으로 `window.storage` API를 구현하십시오.

### UI 디자인 가이드라인
* **Form 태그 금지**: **절대로** React 아티팩트 내에서 HTML `<form>` 태그를 사용하지 마십시오. 양식 제출은 일반 버튼의 이벤트 핸들러(예: `<button onClick={handleSubmit}>`)를 통해 제어해야 합니다.
* **단일 파일 번들링**: 특별한 지시가 없다면 HTML, CSS, JavaScript를 하나의 단일 아티팩트 파일로 통합하여 작성하십시오.

### 사용 가능한 React 외부 라이브러리 목록
React(`.jsx`) 아티팩트 개발 시 아래 라이브러리만 임포트하여 사용할 수 있습니다:
* **UI 및 아이콘**: `lucide-react@0.383.0`, `shadcn/ui` (`@/components/ui/...` 경로에서 임포트)
* **차트/시각화**: `recharts` (예: `import { LineChart } from 'recharts'`), `plotly`, `chart.js`, `d3`
* **유틸리티**: `lodash` (예: `import _ from 'lodash'`), `mathjs`, `papaparse` (CSV 파서), `xlsx` (SheetJS)
* **음향 및 머신러닝**: `tone` (Tone.js), `tensorflow`
* **3D 렌더링**: `three` (r128 버전 제공 - 주의: `THREE.OrbitControls`는 사용할 수 없으며, `CapsuleGeometry`는 r142 이상 스펙이므로 CylinderGeometry 등으로 우회해야 합니다.)
