---
name: model-selection-guide
description: "ML 문제 유형별 모델 선택 매트릭스, 하이퍼파라미터 튜닝 전략, 앙상블 방법론 가이드. model-designer와 evaluation-analyst를 강화한다."
---

# Model Selection Guide — ML 모델 선택 매트릭스 가이드

문제 유형, 데이터 특성, 제약 조건에 따른 최적 모델 선택과 튜닝 전략.

## 문제 유형별 모델 추천
- **정형 데이터**: LogisticRegression(베이스라인) → XGBoost / LightGBM / CatBoost
- **비정형 데이터**: ResNet/ViT(이미지), BERT/RoBERTa(텍스트)

## Optuna 튜닝 패턴
```python
import optuna

def objective(trial):
    params = {
        'n_estimators': trial.suggest_int('n_estimators', 100, 1000),
        'max_depth': trial.suggest_int('max_depth', 3, 10),
        'learning_rate': trial.suggest_float('learning_rate', 0.01, 0.3, log=True),
    }
    model = XGBClassifier(**params)
    return cross_val_score(model, X, y, cv=5, scoring='f1').mean()
```

## 교차 검증 전략
- StratifiedKFold (불균형 분류), TimeSeriesSplit (시계열), GroupKFold (그룹 데이터)
