---
name: ml-experiment
description: "ML 실험의 데이터 준비, 모델 설계, 학습, 평가, 배포 준비 및 A4 HTML/PDF 보고서 생성을 에이전트 팀이 협업하여 수행하는 범용 풀 ML 파이프라인. ChatGPT, Claude, Anti-Gravity 등 모든 AI 플랫폼에서 호환되며, 비전문가도 읽기 쉬운 쉬운 용어로 보고서를 자동 작성한다. 'ML 실험 설계해줘', '모델 학습해줘', '머신러닝 프로젝트', '딥러닝 모델 만들어줘', '분류 모델', '회귀 모델', '데이터 전처리', '모델 평가', '하이퍼파라미터 튜닝', 'MLOps 설정', 'ML 보고서 생성' 등 ML 실험 및 보고서 생성 전반에 이 스킬을 사용한다."
---

# ML Experiment Harness — 범용 ML 실험 & 보고서 풀 파이프라인

데이터 준비 → 모델 설계 → 학습 → 평가 → 리뷰 및 **A4 규격 HTML/PDF 최종 보고서(EDA → 방법론 → 결과)** 생성을 에이전트 팀이 협업하여 한 번에 수행한다.

> **범용 플랫폼 호환성**: 본 스킬은 **ChatGPT**, **Claude**, **Anti-Gravity (AGY)** 및 멀티/단일 에이전트 CLI 환경 모두에서 동작 가능하도록 설계되었습니다.
> **쉬운 용어 적용 (Plain Language)**: 난해한 약어나 개발자용 전문용어(CV, 데이터 누수, 시드 고정 등)를 단독 사용하지 않고 누구나 이해할 수 있는 쉬운 용어로 순화하여 최종 보고서를 작성합니다.

---

## 1. 실행 모드 및 플랫폼 지원

- **멀티 에이전트 모드 (Anti-Gravity / Teamwork 지원 환경)**:
  5명의 에이전트 프로세스가 메시지 통신(`send_message` / `invoke_subagent`)으로 역할 분담 및 교차 검증을 병렬 수행합니다.
- **단일 에이전트 모드 (ChatGPT / Claude 표준 대화 환경)**:
  단일 에이전트가 5개 역할의 작업 지침을 순차적(Phase 1 → Phase 2 → Phase 3)으로 전환하여 완수합니다.

---

## 2. 에이전트 팀 구성

| 에이전트 | 정의 경로 | 역할 |
|---------|----------|------|
| **data-engineer** | `agents/data-engineer.md` | 수집, EDA, 전처리, 피처 엔지니어링, 분할 |
| **model-designer** | `agents/model-designer.md` | 모델 아키텍처, 하이퍼파라미터, 손실함수 설계 |
| **training-manager** | `agents/training-manager.md` | 학습 루프, 재현성(시드), GPU 관리, 실험 추적 |
| **evaluation-analyst** | `agents/evaluation-analyst.md` | 메트릭, 오분류 분석, 편향 검증, XAI (SHAP) |
| **experiment-reviewer** | `agents/experiment-reviewer.md` | 데이터 누수/정합성 교차검증 & 누구나 읽기 쉬운 A4 HTML/PDF 보고서 생성 조율 |

---

## 3. 워크플로우

### Phase 1: 준비 및 초기화
1. 사용자 입력에서 요구사항 추출:
   - **문제 정의**: 분류 / 회귀 / 시계열 / 추천 등
   - **데이터**: 파일 경로, 포맷, 크기, 클래스 비율
   - **목표 메트릭**: F1-score, Accuracy, RMSE, ROC-AUC 등
2. `_workspace/` 및 `_workspace/scripts/` 디렉토리 생성.
3. 입력을 `_workspace/00_input.md`에 정리 및 원본 데이터 복사.

### Phase 2: 파이프라인 수행 (순차/병렬)

| 순서 | 작업 | 담당 에이전트 | 산출물 |
|------|------|-------------|--------|
| 1 | 데이터 준비 & EDA | data-engineer | `_workspace/01_data_preparation.md` |
| 2 | 모델 설계 | model-designer | `_workspace/02_model_design.md` |
| 3 | 학습 설정 & 실행 | training-manager | `_workspace/03_training_config.md` |
| 4 | 성능 평가 & XAI | evaluation-analyst | `_workspace/04_evaluation_report.md` |
| 5 | 실험 리뷰 & 최종 보고서 생성 | experiment-reviewer | `_workspace/05_review_report.md`, `_workspace/06_final_report.html`, `_workspace/06_final_report.pdf` |

### Phase 3: 최종 보고서 생성 (A4 HTML + PDF)
`subskills/html-pdf-reporter`를 호출하여 아래 순서로 지정된 최종 결과 보고서 생성을 완료합니다:
1. **EDA (Exploratory Data Analysis)**: 데이터 프로파일링, 결측치/이상치, 주요 분포 및 상관분석
2. **방법론 (Methodology)**: 전처리/피처엔지니어링 파이프라인, 모델 아키텍처, 손실함수, 최적화 조건 탐색 및 무작위 다각도 검증 설계
3. **결과 (Results & Evaluation)**: 성능 메트릭 비교, 오차 분석, SHAP 기여도, 비즈니스 인사이트 및 실행 권고사항

HTML 파일은 **단일 파일 내장 CSS (Embedded CSS)** 및 **A4 규격 Print Stylesheet**를 사용하며, 생성 직후 `scripts/render_pdf.py`를 실행하여 **PDF 파일(`06_final_report.pdf`)을 함께 자동 생성**합니다.

---

## 4. 데이터 전달 및 교차 검증 프로토콜

- **파일 기반**: `_workspace/` 내 마크다운 및 `_workspace/experiment_code/` 실행 가능 Python 코드
- **검증 규칙**: `experiment-reviewer`가 데이터 누수, 과적합, 재현성 시드 고정을 확인하고 🔴 필수 수정 시 담당 에이전트에 재작업 요청 (최대 2회).

---

## 5. 확장 서브스킬 (Subskills)

| 스킬 | 경로 | 담당 / 역할 |
|------|------|------------|
| **feature-engineering-cookbook** | `subskills/feature-engineering-cookbook/skill.md` | `data-engineer` (변수변환/피처선택) |
| **model-selection-guide** | `subskills/model-selection-guide/skill.md` | `model-designer`, `evaluation-analyst` (모델추천/튜닝) |
| **experiment-tracking-setup** | `subskills/experiment-tracking-setup/skill.md` | `training-manager` (MLflow/시드고정) |
| **html-pdf-reporter** | `subskills/html-pdf-reporter/skill.md` | `experiment-reviewer` (A4 HTML+PDF 보고서 생성 & 쉬운 용어 순화) |
