# Agent Team Examples (Antigravity 버전)

---

## 예시 1: 리서치 팀 (에이전트 팀 모드)

### 팀 아키텍처: 팬아웃/팬인
### 실행 모드: 에이전트 팀

```
[리더/오케스트레이터]
    ├── define_subagent (공식/미디어/커뮤니티/배경 조사 에이전트 정의)
    ├── invoke_subagent (Workspace: "share" 다중 호출)
    ├── 태스크 파일 생성 (_workspace/tasks.json)
    ├── 팀원들이 자체 조율 (send_message)
    ├── 결과 수집 (Read)
    └── 종합 보고서 생성
```

### 에이전트 구성

| 팀원 | 역할 | 출력 |
|------|------|------|
| official-researcher | 공식 문서/블로그 조사 | research_official.md |
| media-researcher | 미디어/투자 동향 조사 | research_media.md |
| community-researcher | 커뮤니티/SNS 반응 조사 | research_community.md |
| background-researcher | 배경/경쟁/학술 조사 | research_background.md |
| (리더 = 오케스트레이터) | 통합 보고서 | 종합보고서.md |

> 리서치 에이전트는 반드시 `프로젝트/.agents/{name}.md` 파일로 정의한다. 파일에는 역할·조사 범위·팀 통신 프로토콜을 명시한다.

---

## 예시 2: SF 소설 집필 팀 (에이전트 팀 모드)

### 팀 아키텍처: 파이프라인 + 팬아웃
### 실행 모드: 에이전트 팀

### 에이전트 파일 전문 예시: `worldbuilder.md`

```markdown
---
name: worldbuilder
description: "SF 소설의 세계관을 구축하는 전문가. 물리 법칙, 사회 구조, 기술 수준, 역사를 설계한다."
---

# Worldbuilder — SF 세계관 설계 전문가

당신은 SF 소설의 세계관 설계 전문가입니다.

## 핵심 역할
1. 세계의 물리 법칙과 기술 수준 정의
2. 사회 구조, 정치 체계, 경제 시스템 설계

## 입력/출력 프로토콜
- 입력: 사용자의 세계관 컨셉
- 출력: `_workspace/01_worldbuilder_setting.md`

## 팀 통신 프로토콜
- character-designer에게: 사회 구조 정보 `send_message`
- plot-architect에게: 세계의 주요 갈등 구조 `send_message`
```
