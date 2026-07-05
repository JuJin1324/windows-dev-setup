# 윈도우 11 환경 셋업 가이드

Git Bash + zsh 기반 터미널 환경을 구성하고(1~9), 이어서 OS 성능 설정을 적용한다(10~12).

---

## 1. Git for Windows 설치 (Git Bash 포함)

```powershell
winget install --id Git.Git -e --source winget
```

설치 후 시작 메뉴에서 **Git Bash** 실행 확인.

---

## 2. Windows Terminal 설치 및 기본 프로필 설정

### 2-1. Windows Terminal 설치

Windows 11 일부 버전에는 기본 내장되어 있지 않다. 시작 메뉴에서 **터미널**이 없으면 설치한다.

```powershell
winget install --id Microsoft.WindowsTerminal -e --source winget
```

### 2-2. 새 프로필 추가

설정(`Ctrl+,`) → **프로필 추가** → **새 빈 프로필**을 선택해 아래와 같이 입력한다.

| 항목 | 값 |
|---|---|
| 이름 | Git Bash (zsh) |
| 명령줄 | `C:\Program Files\Git\bin\bash.exe` |
| 시작 디렉터리 | `%USERPROFILE%` |

### 2-3. 기본 프로필로 설정

설정 → **시작** → **기본 프로필**에서 위에서 만든 `Git Bash (zsh)` 선택.

### 2-4. 탭 단축키

| 동작 | 단축키 |
|---|---|
| 현재 탭 닫기 | `Ctrl + W` |
| 다음 탭으로 이동 | `Ctrl + Tab` |
| 이전 탭으로 이동 | `Ctrl + Shift + Tab` |
| 특정 탭으로 이동 | `Ctrl + 1` ~ `Ctrl + 8` |

---

## 3. zsh 설치

Git Bash에는 zsh가 포함되어 있지 않아 MSYS2를 통해 설치한다. PowerShell을 **관리자 권한**으로 열고 순서대로 실행한다.

> **주의**: 관리자 권한 PowerShell에서는 AutoHotkey 키 매핑이 동작하지 않는다. 키보드는 물리 배열(Ctrl=Ctrl, Win=Win, Alt=Alt) 그대로 입력해야 한다.

### 3-1. MSYS2 설치

```powershell
winget install --id MSYS2.MSYS2 -e --source winget
```

### 3-2. zsh 설치 및 Git Bash에 복사

```powershell
# pacman으로 zsh 설치
C:\msys64\usr\bin\bash.exe -lc "pacman -S --noconfirm zsh"

# Git Bash에 복사
Copy-Item "C:\msys64\usr\bin\zsh.exe" "C:\Program Files\Git\usr\bin\" -Force
Copy-Item "C:\msys64\usr\bin\msys-zsh*.dll" "C:\Program Files\Git\usr\bin\" -Force
Copy-Item "C:\msys64\usr\lib\zsh" "C:\Program Files\Git\usr\lib\" -Recurse -Force
Copy-Item "C:\msys64\usr\share\zsh" "C:\Program Files\Git\usr\share\" -Recurse -Force
```

### 3-3. zsh 동작 확인

Git Bash를 열고 실행:

```bash
zsh --version
```

---

## 4. Git Bash 기본 셸을 zsh로 설정

Git Bash에서 실행:

```bash
cat >> ~/.bashrc << 'EOF'
if [ -t 1 ]; then
  exec zsh
fi
EOF
```

Git Bash를 재시작하면 zsh로 자동 진입. 재시작 후 동작 확인:

```bash
echo $0  # zsh 출력되면 성공
```

---

## 5. Oh-My-Zsh 설치

zsh 진입 후 실행:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

## 6. powerlevel10k 설치

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

---

## 7. zsh 플러그인 설치

```bash
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  ~/.oh-my-zsh/plugins/zsh-autosuggestions
```

---

## 8. 워크스페이스 디렉터리 생성 및 레포 클론

`.zshrc`는 이 레포에 포함되어 있다. SSH 설정(git-setup-guide.md)을 완료한 뒤 아래 순서로 클론한다.

```bash
mkdir -p ~/Documents/dev/workspace-pe
cd ~/Documents/dev/workspace-pe
git clone git@github.com:JuJin1324/windows-dev-setup.git
```

---

## 9. .zshrc 적용

클론한 레포의 `.zshrc`를 홈 디렉터리에 복사한다.

```bash
cp ~/Documents/dev/workspace-pe/windows-dev-setup/.zshrc ~/.zshrc
source ~/.zshrc
```

복사 후 powerlevel10k 초기 설정 마법사가 실행되면 안내에 따라 진행.

---

## 10. 하이버네이션 파일 제거

하이버네이션(최대 절전)은 RAM 내용을 통째로 디스크에 저장하고 전원을 완전히 끄는 절전 방식이다. 슬립(RAM에 상태를 두고 전기를 조금씩 먹음)과 달리 배터리를 안 쓰지만 복귀가 느리다. 이 RAM 내용을 받아 둘 파일이 `hiberfil.sys`다.

`hiberfil.sys`는 한 번도 안 써도 RAM의 약 40%(이 기기 기준 ~6GB)를 디스크에 상시 점유한다. 256GB에서 즉시 회수 가치가 크다.

관리자 PowerShell에서:

```powershell
powercfg /h off
```

- 트레이드오프: 최대 절전(하이버네이트)과 빠른 시작(Fast Startup)을 못 쓴다. 개발 환경에선 빠른 시작이 오히려 드라이버·WSL 상태 꼬임을 만들기도 해 끄는 편이 무난하다. 슬립(덮개 닫기)은 영향 없다.

---

## 11. 전원 모드 — AC·배터리 모두 최고 성능

전원 모드만 최고로 둬도 **배터리 세이버 자동 작동**(기본 잔량 20%에서 성능 제한)에 걸리면 배터리에서 throttle된다. 둘을 함께 처리한다.

1. **전원 모드 최고 성능**: 설정 → 시스템 → 전원 및 배터리 → 전원 모드 → **최고의 성능**. 또는 PowerShell:

   ```powershell
   powercfg /overlaysetactive overlay_scheme_max
   ```

2. **배터리 세이버 자동 작동 끄기**: 설정 → 시스템 → 전원 및 배터리 → 배터리 절약 모드 → 자동 켜기 기준을 **사용 안 함(0%)** 으로. 배터리에서도 성능이 안 떨어진다.

3. (선택) **궁극의 성능 전원 계획** 활성화 — 슬립/throttle을 더 막고 싶을 때:

   ```powershell
   powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
   ```

   생성 후 설정 → 추가 전원 설정에서 "궁극의 성능" 선택.

- 발열 주의: Core Ultra 5 125H는 얇은 새시라 풀로드 시 발열·팬 소음이 있다. 성능 우선이 목적이면 감수, 무릎 위 사용이 많으면 균형을 고려.

---

## 12. 시작 프로그램·백그라운드 앱 정리

16GB 환경에서 상주 메모리를 회수한다.

- **시작 프로그램**: 작업 관리자(Ctrl+Shift+Esc) → 시작 프로그램 앱 → 안 쓰는 항목 사용 안 함. (Docker Desktop·각종 업데이터·OneDrive 등)
- **백그라운드 앱 권한**: 설정 → 앱 → 설치된 앱 → 개별 앱 ⋯ → 고급 옵션 → 백그라운드 앱 권한을 **안 함**으로. (Win11 Home은 그룹 정책이 없어 앱별로 처리)
- **OneDrive**: 동기화를 쓰지 않으면 종료·제거. 상시 인덱싱·업로드로 디스크·CPU를 먹는다.
