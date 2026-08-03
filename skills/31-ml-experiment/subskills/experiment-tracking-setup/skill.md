---
name: experiment-tracking-setup
description: "MLflow, W&B 등 실험 추적 도구 설정, 재현성(시드 고정) 보장, 모델 레지스트리 가이드. training-manager를 강화한다."
---

# Experiment Tracking Setup — 실험 추적 및 재현성 가이드

ML 실험의 추적, 재현성 보장, 모델 버전 관리를 위한 실전 가이드.

## MLflow 예시
```python
import mlflow

mlflow.set_experiment("ml-experiment")
with mlflow.start_run():
    mlflow.log_params({"n_estimators": 500, "lr": 0.05})
    mlflow.log_metrics({"f1": 0.88, "accuracy": 0.91})
```

## 재현성 시드 고정
```python
import random, numpy as np, torch, os

def set_seed(seed=42):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    os.environ['PYTHONHASHSEED'] = str(seed)
```
