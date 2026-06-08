# 오케스트레이터 스킬 템플릿 (Antigravity 버전)

오케스트레이터는 팀 전체를 조율하는 상위 스킬이다. 실행 모드별로 3가지 템플릿을 제공한다:

- **템플릿 A: 에이전트 팀 모드 (기본)** — 2명 이상 협업 시 최우선 선택
- **템플릿 B: 서브 에이전트 모드 (대안)** — 팀 통신이 불필요한 경우
- **템플릿 C: 하이브리드 모드** — Phase마다 모드를 섞어 구성

---

## 템플릿 A: 에이전트 팀 모드 (기본 · 최우선 선택)

2명 이상의 에이전트가 협업할 때 **가장 먼저 검토하는 기본 모드**. `define_subagent`로 에이전트들을 정의하고, `invoke_subagent`에 `Workspace: "share"` 옵션으로 다중 소환하여, 공유 태스크 파일과 `send_message`로 조율한다.

```markdown
---
name: {domain}-orchestrator
description: "{도메인} 에이전트 팀을 조율하는 오케스트레이터. {초기 실행 키워드}. 후속 작업: {도메인} 결과 수정, 부분 재실행, 업데이트, 보완, 다시 실행, 이전 결과 개선 요청 시에도 반드시 이 스킬을 사용."
---

# {Domain} Orchestrator

{도메인}의 에이전트 팀을 조율하여 {최종 산출물}을 생성하는 통합 스킬.

## 실행 모드: 에이전트 팀

## 에이전트 구성

| 팀원 | 에이전트 타입 | 역할 | 스킬 | 출력 |
|------|-------------|------|------|------|
| {teammate-1} | {커스텀 또는 빌트인} | {역할} | {skill} | {output-file} |
| {teammate-2} | {커스텀 또는 빌트인} | {역할} | {skill} | {output-file} |
| ... | | | | |

## 워크플로우

### Phase 0: 컨텍스트 확인 (후속 작업 지원)

기존 산출물 존재 여부를 확인하여 실행 모드를 결정한다:

1. `_workspace/` 디렉토리 존재 여부 확인
2. 실행 모드 결정:
   - **`_workspace/` 미존재** → 초기 실행. Phase 1로 진행
   - **`_workspace/` 존재 + 사용자가 부분 수정 요청** → 부분 재실행. 해당 에이전트만 재호출하고, 기존 산출물 중 수정 대상만 덮어쓴다
   - **`_workspace/` 존재 + 새 입력 제공** → 새 실행. 기존 `_workspace/`를 `_workspace_{YYYYMMDD_HHMMSS}/`로 이동한 뒤 Phase 1 진행
3. 부분 재실행 시: 이전 산출물 경로를 에이전트 프롬프트에 포함하여, 에이전트가 기존 결과를 읽고 피드백을 반영하도록 지시

### Phase 1: 준비
1. 사용자 입력 분석 — {무엇을 파악하는지}
2. 작업 디렉토리에 `_workspace/` 생성
   - **초기 실행**: 새 `_workspace/` 생성
   - **새 실행**: 기존 `_workspace/`를 `_workspace_{YYYYMMDD_HHMMSS}/`로 이동한 직후 새 `_workspace/` 재생성
3. 입력 데이터를 `_workspace/00_input/`에 저장
4. 공유 태스크 파일 생성: `_workspace/tasks.json`에 수행할 작업 목록을 작성하여 에이전트들이 이를 바탕으로 상태를 인지할 수 있도록 함

### Phase 2: 팀 구성

1. 에이전트 정의:
   ```json
   define_subagent(
     name: "{teammate-1}",
     description: "{역할 설명}",
     system_prompt: "{페르소나 및 지시사항}",
     enable_write_tools: true,
     enable_subagent_tools: false
   )
   define_subagent(
     name: "{teammate-2}",
     description: "{역할 설명}",
     system_prompt: "{페르소나 및 지시사항}",
     enable_write_tools: true,
     enable_subagent_tools: false
   )
   ```

2. 에이전트 호출 (Workspace: "share"로 공간 공유):
   ```json
   invoke_subagent(
     Subagents: [
       { TypeName: "{teammate-1}", Role: "{역할}", Prompt: "{초기 지시사항}", Workspace: "share" },
       { TypeName: "{teammate-2}", Role: "{역할}", Prompt: "{초기 지시사항}", Workspace: "share" }
     ]
   )
   ```

### Phase 3: {주요 작업 — 예: 조사/생성/분석}

**실행 방식:** 팀원들이 자체 조율

팀원들은 공유 작업 파일(`_workspace/tasks.json`)에서 자신이 할 작업을 확인하고 업데이트하며 독립적으로 수행한다.
오케스트레이터는 진행 상황을 모니터링하며 필요 시 개입한다.

**팀원 간 통신 규칙:**
- {teammate-1}은 {teammate-2}에게 {어떤 정보}를 `send_message`로 전달
- {teammate-2}는 작업 완료 시 결과를 파일로 저장하고 공유 태스크 파일의 상태를 완료로 업데이트
- 팀원이 다른 팀원의 결과가 필요하면 `send_message`로 요청

**산출물 저장:**

| 팀원 | 출력 경로 |
|------|----------|
| {teammate-1} | `_workspace/{phase}_{teammate-1}_{artifact}.md` |
| {teammate-2} | `_workspace/{phase}_{teammate-2}_{artifact}.md` |

**오케스트레이터 모니터링:**
- 서브에이전트로부터 메시지 수신 시 대응
- 특정 팀원이 막혔을 때 `send_message`로 추가 힌트를 주거나, `manage_subagents`의 kill 액션 후 새로운 Prompt로 재호출

### Phase 4: {후속 작업 — 예: 검증/통합}
1. 모든 팀원의 작업 완료 대기 (`tasks.json` 또는 서브에이전트의 종료 보고 확인)
2. 각 팀원의 산출물을 수집
3. {통합/검증 로직}
4. 최종 산출물 생성: `{output-path}/{filename}`

### Phase 5: 정리
1. 팀원들에게 종료 요청 (`send_message`) 또는 `manage_subagents`를 사용하여 `kill` 액션으로 명시적 정리
2. `_workspace/` 디렉토리 보존 (중간 산출물은 삭제하지 않음 — 사후 검증·감사 추적용)
3. 사용자에게 결과 요약 보고
```

---

## 템플릿 B: 서브 에이전트 모드 (대안)

팀 통신 오버헤드가 불필요한 경우. `invoke_subagent` 도구로 각 서브에이전트를 호출하고 반환값이나 파일로 결과를 수집한다.

```markdown
---
name: {domain}-orchestrator
description: "{도메인} 에이전트를 조율하는 오케스트레이터. {초기 실행 키워드}. 후속 작업 키워드 포함."
---

## 실행 모드: 서브 에이전트

## 에이전트 구성

| 에이전트 | TypeName | 역할 | 스킬 | 출력 |
|---------|----------|------|------|------|
| {agent-1} | {빌트인 또는 커스텀} | {역할} | {skill} | {output-file} |
| {agent-2} | ... | ... | ... | ... |

## 워크플로우

### Phase 0: 컨텍스트 확인
(Template A와 동일 — `_workspace/` 존재 여부 분기)

### Phase 1: 준비
1. 입력 분석
2. `_workspace/` 생성 (초기 실행 시, 또는 새 실행에서 기존 `_workspace/`를 보관 디렉토리로 이동한 직후)

### Phase 2: 병렬 실행
단일 메시지에서 `invoke_subagent`를 사용하여 여러 서브에이전트 호출:

```json
invoke_subagent(
  Subagents: [
    { TypeName: "{agent-1}", Role: "{역할}", Prompt: "{소스}", Workspace: "branch" },
    { TypeName: "{agent-2}", Role: "{역할}", Prompt: "{소스}", Workspace: "branch" }
  ]
)
```

### Phase 3: 통합
1. 각 에이전트의 반환값 수집
2. 파일 기반 산출물은 수집하여 통합 로직 적용 → 최종 산출물

### Phase 4: 정리
1. `_workspace/` 보존
2. 결과 요약 보고
```

---

## 템플릿 C: 하이브리드 모드

Phase마다 다른 실행 모드를 사용한다. 각 Phase 상단에 `**실행 모드:** {팀 | 서브}`를 명시한다.

```markdown
---
name: {domain}-orchestrator
description: "{도메인} 오케스트레이터 (하이브리드). {키워드}. 후속 작업 키워드 포함."
---

## 실행 모드: 하이브리드

| Phase | 모드 | 이유 |
|-------|------|------|
| Phase 2 (병렬 수집) | 서브 에이전트 | 독립 자료 수집, 팀 통신 불필요 |
| Phase 3 (합의 통합) | 에이전트 팀 | 상충 데이터 토론·합의 필요 |
| Phase 4 (독립 검증) | 서브 에이전트 | QA 에이전트 1명이 객관 검증 |

## 워크플로우

### Phase 2: 병렬 자료 수집
**실행 모드:** 서브 에이전트

`invoke_subagent` 도구로 N개 에이전트 병렬 호출 (`Workspace: 'branch'`).
각 결과는 `_workspace/02_{agent}_raw.md`에 저장.

### Phase 3: 합의 기반 통합
**실행 모드:** 에이전트 팀

1. `define_subagent`로 통합 팀원 정의 (editor, fact-checker, synthesizer)
2. `invoke_subagent`로 팀 구성 (`Workspace: 'share'`)
3. `_workspace/tasks.json`에 공동 작업 분배 및 등록
4. 팀원들이 `send_message`로 상충 데이터를 논의, 파일 기반으로 합의안 도출
5. 최종 통합본 `_workspace/03_integrated.md` 생성
6. `manage_subagents`로 팀원 정리

### Phase 4: 독립 검증
**실행 모드:** 서브 에이전트

단일 QA 서브 에이전트를 `invoke_subagent`로 호출하여 `_workspace/03_integrated.md`를 입력으로 받아 검증 보고서 생성.
```

**하이브리드 전환 규칙:**
- 팀 → 서브: 팀원을 반드시 `manage_subagents: kill`로 정리한 후 서브에이전트 호출
- 서브 → 팀: 서브 에이전트의 파일 산출물을 팀원들이 공유 공간(`Workspace: 'share'`)을 통해 접근하도록 유도
- 팀 → 팀: 이전 팀을 정리한 후 새 `invoke_subagent` 호출로 다음 Phase의 팀을 구성
