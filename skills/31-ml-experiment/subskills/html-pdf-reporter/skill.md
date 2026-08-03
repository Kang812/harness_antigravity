---
name: html-pdf-reporter
description: "A4 규격 단일 파일 HTML + 내장 CSS 및 PDF 자동 생성 보고서 스킬. 최종 결과 보고서를 EDA → 방법론(Methodology) → 결과(Results) 순서로 구성하고, 전문용어 대신 비전문가도 읽기 쉬운 용어를 적용하여 A4 스타일 HTML과 PDF 파일을 동시에 생성한다."
---

# HTML & PDF Executive Reporter — A4 양식 결과 보고서 생성기

ML 및 데이터 분석 프로젝트의 최종 결과 보고서를 **EDA → 방법론 → 결과**의 표준 목차 구조로 구성하고, 비전문가/경영진도 읽기 쉬운 용어를 사용하여 A4 용지 규격에 최적화된 단일 HTML(내장 CSS) 및 PDF 파일로 자동 생성한다.

---

## 1. 보고서 목차 구조 (필수 순서)

반드시 아래 3단계 순서대로 보고서 섹션을 구성한다:

```
┌─────────────────────────────────────────────────────────┐
│ 1. 탐색적 데이터 분석 (EDA - Exploratory Data Analysis)  │
├─────────────────────────────────────────────────────────┤
│ 2. 데이터 전처리 및 분석 방법론 (Methodology)            │
├─────────────────────────────────────────────────────────┤
│ 3. 실험 결과 및 인사이트 (Results & Evaluation)          │
└─────────────────────────────────────────────────────────┘
```

### 상세 구성 요소
1. **Section 1: 탐색적 데이터 분석 (EDA)**
   - 데이터셋 요약 (샘플 수, 피처 수, 타깃 분포)
   - 주요 변수 통계치, 결측치/이상치 현황
   - EDA 시각화 및 주요 데이터 특성 관찰 결과
2. **Section 2: 데이터 전처리 및 방법론 (Methodology)**
   - 전처리 파이프라인 (스케일링, 인코딩, 결측치 대체)
   - 피처 엔지니어링 및 변수 선택 기법
   - 사용 모델 아키텍처, 손실함수, 최적화 조건 탐색 및 교차 검증 설계
3. **Section 3: 실험 결과 및 인사이트 (Results & Evaluation)**
   - 모델별 평가 메트릭 비교표 (정확도, 변별력 지표 등)
   - 오분류 사례 분석 및 모델 판단 근거 해석
   - 최종 결론 및 비즈니스 실행 권고사항 (Actionable Recommendations)

---

## 2. 용어 순화 및 읽기 쉬운 표현 가이드라인 (Plain Language Policy)

누구나 보고서를 한눈에 쉽게 읽고 이해할 수 있도록 **난해한 개발/학술 용어를 직관적이고 쉬운 표현으로 풀어서 작성**한다:

- **전문용어 단독 표기 금지**: 약어나 개발자용 은어를 단독으로 표기하지 않고, 반드시 쉬운 설명이나 괄호 표기를 병행한다.
- **주요 용어 순화 가이드**:
  - `CV` / `Cross Validation` ➔ **"교차 검증 (데이터를 여러 조각으로 나누어 다각도로 검증하는 방식)"**
  - `데이터 누수` / `Data Leakage` ➔ **"미래 정보 유출 방지 (시험 문제 사전 유출 방지 처리)"**
  - `시드 고정` / `Seed Fixing` ➔ **"실험 재현성 확보 (동일 환경 결과 고정)"**
  - `F1-Score`, `AUC-ROC` ➔ **"종합 예측 정확도 지표"**, **"모델 변별력 지표"** (비전문가용 부연 설명 포함)
  - `Hyperparameter Tuning` ➔ **"최적 분석 조건 자동 탐색"**
  - `Overfitting` / `과적합` ➔ **"특정 데이터에만 과도하게 융통성 없이 적응하는 현상"**
- **대상 중심 어조**: 경영진, 기획자, 비즈니스 담당자가 별도의 서치 없이 즉시 인사이트를 얻을 수 있는 가독성 높은 한국어 문체를 사용한다.

---

## 3. A4 HTML + 내장 CSS (Embedded CSS) 설계 스펙

- **Single-file HTML**: 별도의 external `.css` 파일 없이 HTML 문서 내부 `<style>` 태그에 모든 CSS 스타일을 내장한다.
- **A4 규격 & Page-break 대응**:
  ```html
  <style>
    @page {
      size: A4 portrait;
      margin: 20mm 15mm 20mm 15mm;
    }
    @media print {
      body {
        width: 210mm;
        margin: 0 auto;
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
      }
      .page-break {
        page-break-before: always;
        break-before: page;
      }
      .no-break {
        page-break-inside: avoid;
        break-inside: avoid;
      }
    }
    body {
      font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      line-height: 1.6;
      color: #1e293b;
      background-color: #ffffff;
      padding: 0;
      margin: 0;
    }
    .header-banner {
      background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
      color: white;
      padding: 24px;
      border-radius: 8px;
      margin-bottom: 24px;
    }
    .section-title {
      font-size: 20px;
      font-weight: 700;
      color: #0f172a;
      border-bottom: 2px solid #3b82f6;
      padding-bottom: 8px;
      margin-top: 32px;
      margin-bottom: 16px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 16px 0;
    }
    th, td {
      border: 1px solid #e2e8f0;
      padding: 10px 14px;
      text-align: left;
      font-size: 14px;
    }
    th {
      background-color: #f8fafc;
      font-weight: 600;
      color: #334155;
    }
    .metric-badge {
      display: inline-block;
      padding: 4px 8px;
      border-radius: 4px;
      font-weight: bold;
      font-size: 13px;
      background-color: #dbeafe;
      color: #1e40af;
    }
  </style>
  ```

---

## 4. Dual Output: HTML + PDF 생성 파이프라인

HTML 보고서(`_workspace/06_final_report.html`) 파일 작성이 완료되면, 파이썬 랜더링 스크립트 `scripts/render_pdf.py`를 호출하여 **PDF 파일(`_workspace/06_final_report.pdf`)을 동일 경로에 즉시 자동 생성**한다.

```bash
python scripts/render_pdf.py --input _workspace/06_final_report.html --output _workspace/06_final_report.pdf
```
