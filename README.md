# harness_antigravity
Anti-Gravity를 위한 Harness

## 🛠️ 하네스(Harness) 프레임워크 가이드

이 프로젝트는 에이전트 팀과 스킬 기반의 자동화 체계인 **하네스(Harness) 프레임워크**를 탑재하여 설계 및 유지보수를 수행합니다. 상세 스킬 명세는 [.agents/skills/harness/SKILL.md](file:///mnt/c/Users/kwbyun/Desktop/resume/.agents/skills/harness/SKILL.md) 파일에 정의되어 있습니다.

### 🔄 하네스 워크플로우 (Workflow)

하네스는 총 8개 단계(Phase 0 ~ Phase 7)의 체계적인 수명 주기를 따릅니다.

1. **Phase 0: 현황 감사 (Audit)**
   * 프로젝트 내 기존 에이전트(`.agents/`), 스킬(`.agents/skills/`), `README.md` 지침의 일관성을 체크하고 충돌 및 변경 사항(Drift)을 감지합니다.
2. **Phase 1: 도메인 분석 (Domain Analysis)**
   * 사용자의 세부 요구사항, 프로젝트 기술 스택, 최적의 구현 모듈 및 사용자 숙련도를 판단합니다.
3. **Phase 2: 팀 아키텍처 설계 (Team Architecture)**
   * 여러 에이전트가 협업하는 **에이전트 팀(Agent Team)** 모드와 단독 작업을 위한 **서브 에이전트** 모드 중 최적의 협업 구조를 설계합니다.
4. **Phase 3: 에이전트 정의 생성 (Agent Definition)**
   * 각 에이전트의 역할, 원칙, 입출력 및 통신 규약을 정의하는 커스텀 에이전트 스펙 파일(`.agents/{name}.md`)을 생성합니다.
5. **Phase 4: 스킬 생성 (Skill Creation)**
   * 에이전트들이 도메인에 특화되어 수행할 구체적인 행동 매뉴얼인 `SKILL.md` 스킬 파일을 생성 및 일반화합니다.
6. **Phase 5: 통합 및 오케스트레이션 (Integration)**
   * 전체 에이전트 팀의 작업 의존성을 관리하는 `design-orchestrator` 등 메인 조율 워크플로우를 구성하고 공유 태스크 파일(`tasks.json`)을 활성화합니다.
7. **Phase 6: 검증 및 테스트 (Validation & Testing)**
   * 구현된 코드가 에러 없이 동작하는지, 반응형/인쇄 접근성에 결함이 없는지 교차 검증 및 테스트 시나리오 드라이런을 진행합니다.
8. **Phase 7: 하네스 진화 (Harness Evolution)**
   * 사용자 피드백과 버그 조치 내용을 누적 반영하며 하네스의 스킬과 에이전트의 구조를 점진적으로 진화 및 업데이트합니다.

### 🚀 하네스 사용 방법 (Usage)

#### 📦 다른 프로젝트에 하네스 이식 및 실행 방법

새로운 개발 프로젝트에 하네스 프레임워크를 설치하여 자동 개발 환경(예: FastAPI 백엔드 구축 등)을 작동시키는 방법입니다.

1. **폴더 구성 및 소스 코드 클론**
   ```bash
   mkdir .agents
   cd .agents
   git clone https://github.com/Kang812/harness_antigravity.git
   ```

2. **Antigravity CLI 실행 및 명령**
   ```bash
   # Antigravity CLI 구동
   agy
   
   # CLI 프롬프트에서 /harness 커맨드와 함께 생성 요구사항 입력
   /harness fastapi를 사용해서 api 만들어줘
   ```

---

#### 🔄 로컬 프로젝트 내 구동 프로세스

1. **하네스 트리거 (Harness Trigger)**
   * 채팅 클라이언트 창에 `/harness` 슬래시 커맨드를 입력하거나 `"하네스 구축해줘"`, `"하네스 설계 및 엔지니어링 수행해줘"`와 같은 자연어 명령어로 하네스 프레임워크 스킬을 호출합니다.
2. **초기 감사 및 실행 계획 조율**
   * 에이전트가 현재 워크스페이스 현황을 감사하고 제안한 세부 실행 계획을 승인하여 진행합니다.
3. **에이전트 팀의 자체 조율 및 협업**
   * 하네스가 구동되면 `design-expert`(UI 구현)와 `design-qa`(정합성 및 가독성 검증) 등 역할별 전문 에이전트들이 공유 태스크 파일(`_workspace/tasks.json`)을 기반으로 실시간 피드백을 주고받으며 코드를 빌드하고 튜닝합니다.
4. **점진적 피드백 반영 및 진화**
   * 완료 후 추가 개선 사항을 전달하면 하네스가 피드백 유형을 식별하여 에이전트 정의, 스킬 파일, `README.md` 변경 이력을 즉각적이고 유기적으로 업데이트하며 진화합니다.
