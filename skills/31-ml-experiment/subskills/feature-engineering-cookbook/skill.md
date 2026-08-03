---
name: feature-engineering-cookbook
description: "피처 엔지니어링 기법 카탈로그: 수치형/범주형/시계열 변환, 피처 선택, 피처 스토어 설계. data-engineer의 피처 엔지니어링 역량을 강화한다."
---

# Feature Engineering Cookbook — 피처 엔지니어링 기법 카탈로그

데이터 타입별 변환 기법, 피처 선택 방법, 피처 스토어 설계 가이드.

## 수치형 변환 & 스케일링
- StandardScaler, MinMaxScaler, RobustScaler, PowerTransformer
- 로그 변환, 제곱근 변환, 분위수 이산화 (Binning)

## 범주형 인코딩
- One-Hot Encoding, Target Encoding (K-Fold CV 적용으로 누수 방지), Frequency Encoding

## 피처 선택 및 중요도
- Permutation Importance, SHAP, Tree Feature Importance

## 데이터 누수 방지 체크리스트
- [ ] train/test 분할 전에 인코딩/스케일링하지 않았는가?
- [ ] Target Encoding 시 CV를 적용했는가?
