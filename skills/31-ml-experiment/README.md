# 🚀 ML Experiment Harness (Universal AI Agent Skill)

ML 실험의 **데이터 준비 → 모델 설계 → 학습 → 평가 → 리뷰 및 A4 HTML/PDF 보고서 생성**을 에이전트 팀이 수행하는 범용 스킬 패키지입니다.

**ChatGPT**, **Claude**, **Anti-Gravity (AGY)** 등 모든 주요 AI 에이전트 플랫폼에서 그대로 사용할 수 있도록 벤더 독립적(Vendor-Neutral) 아키텍처로 구성되어 있습니다.

---

## 📁 디렉토리 구조

```
skills/31-ml-experiment/
├── SKILL.md                          # 메인 스킬 진입점 및 범용 오케스트레이터
├── README.md                         # 본 사용 가이드
├── agents/                           # 5인 에이전트 역할 정의
│   ├── data-engineer.md             # 데이터 수집, EDA, 전처리, 분할
│   ├── model-designer.md            # 아키텍처, 손실함수, Optuna 공간 설계
│   ├── training-manager.md          # 학습 루프, 재현성(시드 고정), MLflow
│   ├── evaluation-analyst.md        # 성능 메트릭, 오분류 분석, SHAP XAI
│   └── experiment-reviewer.md       # 교차검증 & 최종 보고서 생성 조율
├── subskills/                        # 하위 도메인 스킬 패키지
│   ├── feature-engineering-cookbook/ # 변수변환/피처선택 가이드
│   ├── model-selection-guide/        # 모델 선택 & 튜닝 매트릭스
│   ├── experiment-tracking-setup/    # 실험 추적 & 재현성 시드 가이드
│   └── html-pdf-reporter/            # A4 규격 HTML+PDF 보고서 생성 스킬
└── scripts/
    └── render_pdf.py                # HTML -> PDF 자동 변환 랜더러
```

---

## 💻 플랫폼별 사용 방법

### 1. Anti-Gravity (AGY) / 멀티 에이전트 지원 환경
- `SKILL.md`를 스킬로 등록하거나 `/ml-experiment` 명령을 수행합니다.
- `send_message` 및 `invoke_subagent` 도구를 통해 5명의 에이전트 프로세스가 병렬 협업 및 교차 검증을 수행합니다.

### 2. Claude (Claude Code CLI / Desktop)
- Standard Skill 위치에 본 폴더를 배치합니다.
- `SKILL.md` 가이드에 따라 5개 에이전트 역할을 단계별(Phase 1 ~ Phase 3)로 순차 실행하여 산출물을 작성합니다.

### 3. ChatGPT / Custom GPTs / Open WebUI
- `SKILL.md` 내용과 `agents/*.md` 지침을 시스템 프롬프트(System Prompt) 또는 지식 베이스(Knowledge)로 첨부하여 사용합니다.

---

## 📊 결과 보고서 특징 (`html-pdf-reporter`)

1. **표준 보고서 목차**:
   - `Section 1: 탐색적 데이터 분석 (EDA)`
   - `Section 2: 데이터 전처리 및 방법론 (Methodology)`
   - `Section 3: 실험 결과 및 인사이트 (Results & Evaluation)`
2. **A4 단일 HTML (Embedded CSS)**: 외부 CSS 의존성 없이 단일 HTML 파일로 완결되며, `@page { size: A4 }` 적용.
3. **PDF 자동 생성 (Dual Output)**: HTML 생성 후 `python scripts/render_pdf.py`를 실행하여 `.html`과 `.pdf`를 동시에 도출.
