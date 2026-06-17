# 아티팩트용 지속성 저장소 API (Persistent Storage API)

> [!IMPORTANT]
> **Antigravity 환경 참고사항**: Antigravity는 사용자의 로컬 컴퓨터에서 구동되므로 `window.storage`를 위한 네이티브 키-값 프록시를 자체 지원하지 않습니다. Antigravity용 네이티브 아티팩트를 개발할 때는 일반적인 브라우저 저장소 API(`localStorage`, `sessionStorage`, `IndexedDB`)가 완벽히 지원되므로 이를 사용해 데이터를 영구 저장하십시오. `window.storage` API는 오직 Claude.ai 플랫폼 배포용 호환 모드에서만 사용합니다.

이 참조 문서는 Claude Fable 5 아티팩트 내에서 세션 간 데이터를 보존하는 데 사용할 수 있는 전역 `window.storage` API 스펙을 정의합니다.

---

## 1. 저장소 API 규격

모든 저장소 작업은 비동기(`async/await`)로 동작하며, `window.storage` 전역 객체를 통해 제공됩니다.

### 메서드 명세

#### 1. 값 조회 (Retrieve Value)
* **메서드**: `await window.storage.get(key, shared?)`
* **반환값**: `{key: string, value: string, shared: boolean} | null`
* **설명**: 지정한 키에 저장된 레코드를 가져옵니다. **주의**: 키가 존재하지 않을 경우 null을 반환하는 대신 에러(Exception)를 발생시킵니다.

#### 2. 값 저장 (Store Value)
* **메서드**: `await window.storage.set(key, value, shared?)`
* **반환값**: `{key: string, value: string, shared: boolean} | null`
* **설명**: 지정한 키에 JSON 또는 일반 텍스트 문자열 값을 저장하거나 갱신합니다.

#### 3. 값 삭제 (Delete Value)
* **메서드**: `await window.storage.delete(key, shared?)`
* **반환값**: `{key: string, deleted: boolean, shared: boolean} | null`
* **설명**: 지정한 키의 저장 데이터를 영구 삭제합니다.

#### 4. 키 목록 조회 (List Keys)
* **메서드**: `await window.storage.list(prefix?, shared?)`
* **반환값**: `{keys: string[], prefix?: string, shared: boolean} | null`
* **설명**: 선택적 인자인 접두사(prefix)로 시작하는 모든 저장 키들의 목록을 조회합니다.

---

## 2. 사용 코드 예시

```javascript
// 1. 개인용 데이터 저장 (기본값: shared = false)
const entry = { date: '2026-06-17', note: '하네스 프레임워크 학습 완료' };
await window.storage.set('entries:123', JSON.stringify(entry));

// 2. 공유 데이터 저장 (shared = true)
const score = { username: '길동', score: 950 };
await window.storage.set('leaderboard:alice', JSON.stringify(score), true);

// 3. 값 조회 (키 비존재 시 에러가 발생하므로 try-catch 필수)
let myEntry = null;
try {
  const result = await window.storage.get('entries:123');
  if (result) {
    myEntry = JSON.parse(result.value);
  }
} catch (error) {
  console.log('저장된 키를 찾을 수 없거나 조회가 실패했습니다:', error);
}

// 4. 특정 prefix를 가진 키 목록 조회
const listResult = await window.storage.list('entries:');
const keys = listResult ? listResult.keys : [];
```

---

## 3. 설계 원칙 및 제약 조건

### 키 명명 규칙 (Key Conventions)
* **계층 구조 네이밍**: 콜론(`:`)으로 구분된 200자 이하의 키 이름을 사용합니다: `테이블명:레코드ID` (예: `todos:todo_1`, `users:user_abc`).
* **금지 문자**: 키 이름에는 공백, 경로 구분자(`/`, `\`), 따옴표(`'`, `"`)를 포함할 수 없습니다.

### 데이터 공개 범위 (Data Scope)
* **개인 데이터** (`shared: false` 또는 생략): 해당 데이터를 생성한 사용자 본인에게만 노출됩니다.
* **공유 데이터** (`shared: true`): 아티팩트를 조회하는 모든 사용자에게 전역 노출됩니다. 공유 데이터를 저장할 때는 사용자에게 타인에게 데이터가 노출될 수 있음을 안내해야 합니다.

### 한계점 및 오류 처리
* **필수 예외 처리**: 조회하려는 키가 존재하지 않으면 에러를 발생시키므로 반드시 `try-catch` 블록으로 안전하게 감싸서 호출하십시오.
* **배치 처리(Batching)**: 저장소 호출은 네트워크 통신으로 작동하며 호출 횟수가 제한(rate limit)되어 있습니다. 필드를 하나씩 각각 키로 저장하지 말고, 관련된 데이터 구조를 하나의 큰 객체로 묶어 단일 키로 대규모 업데이트를 처리하십시오. (예: 픽셀을 개별 저장하는 대신 전체 보드 상태를 묶어서 단일 키로 저장)
* **용량 제한**: 텍스트 및 JSON 문자열 데이터만 허용되며(바이너리 파일 업로드 불가), 키당 최대 크기는 **5MB**입니다.
* **동시성 처리**: 다수의 사용자가 동시에 변경을 시도할 경우, 가장 마지막에 쓰인 데이터가 덮어씌워집니다 (Last-write-wins).
