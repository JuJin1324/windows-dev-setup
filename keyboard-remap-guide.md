# 키보드 리매핑 가이드 — LG 그램 맥 스타일 키 배열

LG 그램의 `Ctrl, Fn, Win, Alt` 배열을 맥 키 배열 `Win, Fn, Alt, Ctrl` 로 리매핑한다. AutoHotkey로 전체 키 매핑을 관리한다.

| 물리적 키 | 리매핑 후 동작 | 역할 |
|---|---|---|
| Ctrl (가장 왼쪽) | Win | Start 메뉴·창 스냅 |
| Fn | Fn | 변경 불가 (하드웨어) |
| Win | Alt | 맥 Option 위치 |
| Alt (스페이스 왼쪽) | Ctrl | 맥 Cmd 위치 → 복사·붙여넣기 등 |

---

## 1. AutoHotkey — 키 배열 리매핑

### 1-1. AutoHotkey 설치

```powershell
winget install --id AutoHotkey.AutoHotkey -e --source winget
```

### 1-2. 스크립트 작성 및 작업 스케줄러 등록

관리자 권한 프로그램(예: 터미널, IDE)에서도 단축키가 동작하도록 작업 스케줄러에 "가장 높은 수준의 권한으로 실행" 옵션으로 등록한다.

> **PowerShell을 관리자 권한으로 열고** 아래 명령을 순서대로 실행한다.

```powershell
# 스크립트 생성
@'
LCtrl & c::Return
LCtrl::LWin
LWin::LAlt
LAlt::LCtrl
'@ | Out-File "$env:USERPROFILE\lg-gram-key-mac-remap.ahk" -Encoding UTF8

# 작업 스케줄러에 등록 (로그온 시 관리자 권한으로 자동 시작)
$ahkPath = "$env:USERPROFILE\lg-gram-key-mac-remap.ahk"
$action   = New-ScheduledTaskAction -Execute $ahkPath
$trigger  = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest -LogonType Interactive
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName "LGGramKeyMacRemap" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
```

작업 스케줄러 등록은 다음 로그온부터 적용된다. UAC 팝업 없이 자동으로 관리자 권한으로 실행된다.

### 1-3. 즉시 실행

현재 세션에 바로 적용하려면 기존 프로세스를 종료 후 재실행한다:

```powershell
Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like "*lg-gram-key-mac-remap*" } | ForEach-Object { Stop-Process -Id $_.ProcessId }
Start-Process "$env:USERPROFILE\lg-gram-key-mac-remap.ahk" -Verb RunAs
```

---

## 2. 동작 확인

- 물리적 Alt (스페이스 왼쪽) → `Ctrl+C` / `Ctrl+V` 동작 확인
- 물리적 Ctrl (가장 왼쪽) 단독 누름 → Start 메뉴 열림 확인
- 물리적 Ctrl + 방향키 → 창 스냅 동작 확인

---

## 3. 트랙패드 — 탭 클릭 비활성화

터치만으로 클릭되는 동작을 끄고, 실제로 눌러야(물리 클릭) 반응하도록 설정한다.

**설정** (`Win+I`) → **Bluetooth 및 디바이스** → **터치패드** → **탭** 섹션에서 아래 항목을 모두 끈다.

| 항목 | 설정 |
|---|---|
| 한 손가락으로 탭하여 한 번 클릭 | **끄기** |
| 두 손가락으로 탭하여 오른쪽 단추 클릭 | **끄기** |
| 두 번 탭하고 끌어 여러 항목 선택 | **끄기** |
| 터치패드의 오른쪽 아래 모서리를 눌러 오른쪽 단추 클릭 | **끄기** |

설정은 즉시 적용된다.

---

## 참고 — 연계 산출물

- **셋업 실행 기록**: [../../epics/win11-dev-env-setup/3-plan/story2/story2-executed.md](../../epics/win11-dev-env-setup/3-plan/story2/story2-executed.md)
