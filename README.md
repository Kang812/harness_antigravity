# harness_antigravity
Anti-Gravity, Claude Code, Codex 및 범용 AI 에이전트를 위한 하네스 (Harness)

---

## 🛠️ 하네스(Harness) 프레임워크 가이드

이 프로젝트는 에이전트 팀과 스킬 기반의 자동화 체계인 **하네스(Harness) 프레임워크**를 탑재하여 설계, 분석, 실험 및 코드 조율을 수행합니다. 상세 스킬 명세는 [`skills/harness/SKILL.md`](file:///home/okit/workspac/harness_antigravity/skills/harness/SKILL.md) 파일에 정의되어 있습니다.

### 🔄 하네스 워크플로우 (Workflow)

하네스는 총 8개 단계(Phase 0 ~ Phase 7)의 체계적인 수명 주기를 따릅니다.

1. **Phase 0: 현황 감사 (Audit)**
   - 프로젝트 내 기존 에이전트(`agents/`), 스킬(`skills/`), `README.md` 지침의 일관성을 체크하고 충돌 및 변경 사항(Drift)을 감지합니다.
2. **Phase 1: 도메인 분석 (Domain Analysis)**
   - 사용자의 세부 요구사항, 프로젝트 기술 스택, 최적의 구현 모듈 및 사용자 숙련도를 판단합니다.
3. **Phase 2: 팀 아키텍처 설계 (Team Architecture)**
   - 여러 에이전트가 협업하는 **에이전트 팀(Agent Team)** 모드와 단독 작업을 위한 **서브 에이전트** 모드 중 최적의 협업 구조를 설계합니다.
4. **Phase 3: 에이전트 정의 생성 (Agent Definition)**
   - 각 에이전트의 역할, 원칙, 입출력 및 통신 규약을 정의하는 커스텀 에이전트 스펙 파일(`agents/{name}.md`)을 생성합니다.
5. **Phase 4: 스킬 생성 (Skill Creation)**
   - 에이전트들이 도메인에 특화되어 수행할 구체적인 행동 매뉴얼인 `SKILL.md` 스킬 파일을 생성 및 일반화합니다.
6. **Phase 5: 통합 및 오케스트레이션 (Integration)**
   - 전체 에이전트 팀의 작업 의존성을 관리하는 메인 조율 워크플로우를 구성합니다.
7. **Phase 6: 검증 및 테스트 (Validation & Testing)**
   - 구현된 코드가 에러 없이 동작하는지, 반응형/인쇄 접근성에 결함이 없는지 교차 검증 및 드라이런을 진행합니다.
8. **Phase 7: 하네스 진화 (Harness Evolution)**
   - 사용자 피드백과 버그 조치 내용을 누적 반영하며 하네스의 스킬과 에이전트의 구조를 점진적으로 진화 및 업데이트합니다.

---

### 📦 주요 내장 스킬 (Included Skills)

| 스킬명 | 경로 | 설명 | 지원 플랫폼 |
| :--- | :--- | :--- | :--- |
| **31-ml-experiment** | [`skills/31-ml-experiment`](file:///home/okit/workspac/harness_antigravity/skills/31-ml-experiment/SKILL.md) | ML 실험 풀 파이프라인 (데이터전처리→모델설계→학습→평가→리뷰). **EDA → 방법론 → 결과** 순서의 A4 HTML+PDF 자동 보고서 생성 및 용어 순화 지침 포함 | ChatGPT, Claude, Anti-Gravity, Codex 공용 |
| **data_analysis** | [`skills/data_analysis`](file:///home/okit/workspac/harness_antigravity/skills/data_analysis/skill.md) | 데이터 탐색(EDA), 정제, 통계 분석, 시각화, 보고서 생성을 5인 팀으로 수행하는 파이프라인 | Anti-Gravity, Claude 공용 |
| **fable** | [`skills/fable`](file:///home/okit/workspac/harness_antigravity/skills/fable/SKILL.md) | Claude Fable 에뮬레이션 및 고급 디자인/아티팩트 스펙 연동 | 공용 |
| **fable_ko** | [`skills/fable_ko`](file:///home/okit/workspac/harness_antigravity/skills/fable_ko/SKILL.md) | Fable 스킬의 한국어 번역 및 맞춤형 레퍼런스 가이드 | 공용 |
| **harness** | [`skills/harness`](file:///home/okit/workspac/harness_antigravity/skills/harness/SKILL.md) | 에이전트 및 스킬 오케스트레이션 하네스 스킬 | 공용 |

---

### 🌍 전역 스킬 설치 가이드 (Global Installation)

AI CLI 환경(Anti-Gravity, Claude Code, Codex)이 모든 프로젝트 워크스페이스에서 이 레포지토리의 스킬들을 전역 스킬로 자동 인식하도록 심볼릭 링크(또는 복사)하여 설치할 수 있습니다.

#### 1. 모든 플랫픔 동시 설치 (통합 설치 - 권장)
```bash
# Anti-Gravity, Claude Code, Codex에 한 번에 심볼릭 링크 설치
./install_all_global.sh
```

#### 2. 환경별 개별 설치
```bash
# Anti-Gravity 전역 설치 (~/.gemini/antigravity-cli/skills)
./anti_gravity_install_global.sh

# Claude Code 전역 설치 (~/.claude/skills)
./claude_install_global.sh

# Codex 전역 설치 (~/.codex/skills)
./codex_install_global.sh
```

> **옵션**: `--symlink` (기본값, 레포지토리 수정 시 자동 갱신) 또는 `--copy` (직접 파일 복사) 옵션을 지원합니다.

---

## 🚀 하네스 구성 변경 이력 (Harness Changelog)

| 날짜 | 변경 내용 | 대상 | 사유 |
| :--- | :--- | :--- | :--- |
| 2026-08-03 | `31-ml-experiment` 범용화 & A4 HTML/PDF 보고서 생성 스킬 구축 및 용어 순화 적용 | [`skills/31-ml-experiment`](file:///home/okit/workspac/harness_antigravity/skills/31-ml-experiment/SKILL.md) | ChatGPT, Claude, Anti-Gravity, Codex 전 플랫폼 호환 구조로 전환, **EDA→방법론→결과** 순서의 내장 CSS A4 HTML+PDF 자동 생성 기능 및 전문용어(CV, 데이터 누수, 시드 고정) 쉬운 한국어 순화 지침 반영 |
| 2026-08-03 | 전역 스킬 설치 스크립트 다중 플랫폼 지원 확장 | [`install_all_global.sh`](file:///home/okit/workspac/harness_antigravity/install_all_global.sh), [`anti_gravity_install_global.sh`](file:///home/okit/workspac/harness_antigravity/anti_gravity_install_global.sh), [`claude_install_global.sh`](file:///home/okit/workspac/harness_antigravity/claude_install_global.sh), [`codex_install_global.sh`](file:///home/okit/workspac/harness_antigravity/codex_install_global.sh) | Anti-Gravity 외에 Claude Code (`~/.claude/skills`) 및 Codex (`~/.codex/skills`) 환경에도 동시/개별 전역 스킬 등록이 가능하도록 설치 스크립트 개편 |
| 2026-06-18 | Antigravity CLI 호환성 개선 패치 (data_analysis, harness) | [`skills/data_analysis/skill.md`](file:///home/okit/workspac/harness_antigravity/skills/data_analysis/skill.md), [`skills/harness/SKILL.md`](file:///home/okit/workspac/harness_antigravity/skills/harness/SKILL.md) | data_analysis 및 harness 스킬 내의 Claude 전용 디렉토리 경로(.claude/agents/, .claude/skills/), 도구명(SendMessage), 규칙 파일(CLAUDE.md)을 Antigravity 구조(.agents/, .agents/skills/, send_message, AGENTS.md)에 맞추어 수정 |
| 2026-06-17 | `fable` & `fable_ko` 스킬 및 레퍼런스 추가 | [`skills/fable`](file:///home/okit/workspac/harness_antigravity/skills/fable/SKILL.md), [`skills/fable_ko`](file:///home/okit/workspac/harness_antigravity/skills/fable_ko/SKILL.md) | Claude Fable 에뮬레이션 및 아티팩트 고급 스펙 연동 스킬 구축 |
| 2026-06-17 | 전역 스킬 설치 스크립트 추가 및 README 업데이트 | `install_global.sh` | Antigravity CLI 전역 스킬(`~/.gemini/antigravity-cli/skills`) 등록 자동화 스크립트 구축 및 문서화 |
