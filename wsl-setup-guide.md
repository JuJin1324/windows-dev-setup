# WSL2 설치 가이드

WSL2(Windows Subsystem for Linux 2)는 Windows 위에서 실제 리눅스 커널을 돌리는 환경이다. 두 가지 이유로 먼저 깐다.

- **리눅스 개발 기반**: 셸·빌드·런타임을 리눅스에서 그대로 쓴다.
- **Docker Desktop의 백엔드**: Docker Desktop은 WSL2 위에서 컨테이너를 돌린다. 그래서 **Docker 설치보다 WSL2 활성화가 먼저**다. ([winget-guide.md](winget-guide.md)의 Docker 항목 선행 조건)

---

## 1. 가상화 활성화 확인

WSL2는 하드웨어 가상화가 필요하다. 대개 기본 켜져 있다.

- 작업 관리자(Ctrl+Shift+Esc) → 성능 → CPU → **가상화: 사용**인지 확인.
- "사용 안 함"이면 재부팅 → BIOS/UEFI 진입 → Intel VT-x(가상화) 활성화.

## 2. WSL2 설치

관리자 PowerShell에서 한 줄이면 WSL 기능·가상 머신 플랫폼 활성화 + 기본 Ubuntu 배포판 설치 + WSL2 기본 버전 지정까지 끝난다.

```powershell
wsl --install
```

- 완료 후 **재부팅**.
- 재부팅하면 Ubuntu가 자동 실행되며 UNIX 사용자 이름·비밀번호를 묻는다. (Windows 계정과 별개)

## 3. 설치 확인 및 기본값 설정

```powershell
wsl -l -v                    # 배포판 목록 + 버전. VERSION이 2인지 확인
wsl --set-default-version 2  # 이후 설치할 배포판도 WSL2로
wsl --update                 # 리눅스 커널 최신화
```

`VERSION`이 `1`로 나오면 `wsl --set-version Ubuntu 2`로 올린다.

---

## 4. Docker Desktop 연동

WSL2가 준비되면 Docker Desktop을 설치한다. (설치 명령은 [winget-guide.md](winget-guide.md))

- 설치 후 Docker Desktop → Settings → General에서 **Use the WSL 2 based engine**이 켜져 있는지 확인.
- Settings → Resources → **WSL Integration**에서 사용할 배포판(Ubuntu)을 켠다. 그래야 WSL 셸에서 `docker` 명령이 먹는다.
- Docker의 메모리·CPU는 별도 슬라이더가 아니라 아래 5번의 `.wslconfig` 상한을 따른다.

---

## 5. 최적화

RAM 16GB 온보드(증설 불가) 환경에서 WSL2·Docker가 자원을 독식하지 않게 통제하고, I/O 성능을 끌어올린다.

### 5-1. 메모리·CPU 상한 (`.wslconfig`)

WSL2는 기본적으로 호스트 RAM을 크게 잡고 작업이 끝나도 잘 돌려주지 않는다. 16GB 고정이라 상한을 안 걸면 Windows 쪽(VSCode·Chrome)이 메모리를 굶는다.

`C:\Users\<사용자>\.wslconfig` 파일을 만들고:

```ini
[wsl2]
memory=6GB          # WSL2(+Docker)가 쓸 상한(예약 아님). 평소엔 다 안 잡음
swap=4GB
processors=8        # 선택: 코어 일부만 할당하려면

[experimental]
autoMemoryReclaim=gradual   # 유휴 메모리를 호스트에 점진 반환
sparseVhd=true              # 가상 디스크에서 빈 공간 회수
```

- 적용: PowerShell에서 `wsl --shutdown` 후 WSL 재시작.
- `memory`는 예약이 아니라 상한이다. Docker를 본격적으로(여러 컨테이너+빌드 동시) 돌리다 WSL 안에서 OOM(빌드 실패·컨테이너 강제 종료)이 나면 `8GB`로 올린다.
- Docker Desktop은 WSL2 백엔드라 이 상한을 그대로 따른다. 상주 오버헤드까지 줄이려면 Docker 엔진을 WSL2 배포판 안에 직접 설치해 Desktop을 빼는 방법도 있다(트레이드오프: GUI·자동 업데이트 포기). 쓰지 않는 동안은 Docker Desktop을 종료해 둔다.

### 5-2. 프로젝트 파일은 리눅스 파일시스템에

WSL 안에서 작업하는 프로젝트는 `/mnt/c/...`(Windows 디스크)가 아니라 **리눅스 홈(`~`)** 에 둔다. WSL↔Windows 파일 접근은 느린 프로토콜을 거쳐 빌드·`git`·`npm install`이 크게 느려진다. 같은 코드라도 `~/projects/`에 두면 디스크 I/O가 몇 배 빠르다.

### 5-3. Windows Defender 실시간 검사 제외

Defender가 WSL 가상 디스크의 I/O를 매번 검사하면 성능이 떨어진다. 배포판 가상 디스크를 실시간 검사에서 제외한다.

```powershell
# Ubuntu(Store) 기준 vhdx 경로 — 실제 경로는 환경마다 다름
Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\Packages\CanonicalGroupLimited.Ubuntu_*\LocalState\ext4.vhdx"
```

- 또는 Windows 보안 → 바이러스 및 위협 방지 → 제외 항목에서 위 `ext4.vhdx`를 추가.
- 트레이드오프: 해당 파일은 백신 실시간 검사에서 빠진다. 신뢰하는 개발 환경 전제.
