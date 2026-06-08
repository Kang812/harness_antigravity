# 스킬 테스트 & 반복 개선 가이드 (Antigravity 버전)

하네스에서 생성한 스킬의 품질을 검증하고 반복적으로 개선하는 방법론. SKILL.md Phase 6의 보충 레퍼런스.

---

## 1. 테스트 프레임워크 개요

스킬 품질 검증은 **정성적 평가**와 **정량적 평가**의 조합이다.

| 평가 유형 | 방법 | 적합한 스킬 |
|----------|------|-----------|
| **정성적** | 사용자가 산출물을 직접 리뷰 | 문체, 디자인, 창작물 등 주관적 품질 |
| **정량적** | assertion 기반 자동 채점 | 파일 생성, 데이터 추출, 코드 생성 등 객관적 검증 가능 |

핵심 루프: **작성 → 테스트 실행 → 평가 → 개선 → 재테스트**

---

## 2. 실행 테스트: With-skill vs Baseline

### 2-1. 비교 실행 구조

각 테스트 프롬프트에 대해 두 개의 서브에이전트를 스폰하여 실행 결과를 비교한다.

**With-skill 실행:**
```json
invoke_subagent(
  Subagents: [
    { TypeName: "expert", Role: "Skill Evaluator", Prompt: "{테스트 프롬프트}", Workspace: "branch" }
  ]
)
// 에이전트에게 관련 스킬 파일을 로드하여 읽도록 지시
```

**Baseline 실행:**
```json
invoke_subagent(
  Subagents: [
    { TypeName: "expert", Role: "Baseline Evaluator", Prompt: "{테스트 프롬프트}", Workspace: "branch" }
  ]
)
// 스킬 없이 기본 프롬프트만 주어 실행
```

---

## 3. Description 트리거 검증

새 스킬의 description이 기존 스킬의 트리거 영역과 겹치지 않는지 확인한다:

1. 기존 스킬 목록의 description을 수집
2. 새 스킬의 should-trigger 쿼리가 기존 스킬을 잘못 트리거하지 않는지 확인
3. 충돌 발견 시 description의 경계 조건을 더 명확히 기술

---

## 4. 워크스페이스 구조

테스트/평가 결과를 체계적으로 관리하는 디렉토리 구조:

```
{skill-name}-workspace/
├── iteration-1/
│   ├── eval-descriptive-name-1/
│   │   ├── eval_metadata.json
│   │   ├── with_skill/
│   │   │   ├── outputs/
│   │   │   └── grading.json
│   │   └── without_skill/
│   │       ├── outputs/
│   │       └── grading.json
│   └── benchmark.json
└── evals/
    └── evals.json
```
