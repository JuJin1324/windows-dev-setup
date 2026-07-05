# VSCode 셋업 가이드 — 윈도우 11

맥 VSCode 가이드를 윈도우 기준으로 적용한 버전.

---

## 1. 설치

```powershell
winget install Microsoft.VisualStudioCode
```

설치 후 `code` 명령이 PATH에 자동으로 등록된다.

```bash
code --version   # 확인
code .           # 현재 폴더를 VSCode로 열기
```

---

## 2. 기본 설정

`Ctrl+Shift+P` → `Preferences: Open User Settings (JSON)` 에서 아래 내용을 적용한다.

```jsonc
{
  "workbench.colorTheme": "Dark Modern",
  "workbench.iconTheme": "material-icon-theme",

  "editor.fontSize": 16,
  "markdown.preview.fontSize": 18,
  "window.zoomLevel": 0,

  "files.autoSave": "afterDelay",  // 미저장 버퍼 방지 → git pull 후 탭에 옛 버전이 남지 않음
  "files.encoding": "utf8",
  "files.eol": "\n",
  "editor.tabSize": 4,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,

  "workbench.list.openMode": "singleClick",
  "workbench.editorAssociations": {
    "*.md": "vscode.markdown.preview.editor"
  },
  "workbench.diffEditorAssociations": {
    "*.md": "default"
  },

  "zenMode.fullScreen": false,
  "zenMode.centerLayout": false,
  "zenMode.showTabs": "multiple",
  "zenMode.hideActivityBar": false,
  "zenMode.hideStatusBar": false,
  "zenMode.restore": false,

  "git.autofetch": true,

  // 터미널 셸 — Git Bash + zsh 연결
  "terminal.integrated.defaultProfile.windows": "Git Bash",
  "terminal.integrated.profiles.windows": {
    "Git Bash": {
      "path": "C:\\Program Files\\Git\\bin\\bash.exe",
      "args": []
    }
  }
}
```

---

## 3. 추천 확장 설치

```bash
code --install-extension yzhang.markdown-all-in-one
code --install-extension davidanson.vscode-markdownlint
code --install-extension pkief.material-icon-theme
```

---

## 4. 단축키 설정

`Ctrl+Shift+P` → `기본 설정: 바로 가기 키 열기 (JSON)` → 아래 내용 붙여넣기.

맥 keybindings.json과의 매핑 원칙:
- 맥 `Cmd` → 윈도우 `Ctrl` (키보드 스왑으로 물리적 위치 동일)
- 맥 `Ctrl` → 윈도우 `Win` (키보드 스왑으로 물리적 위치 동일)

```jsonc
[
  // Ctrl+1 → 탐색기 포커스
  { "key": "ctrl+1", "command": "workbench.view.explorer" },
  { "key": "ctrl+1", "command": "-workbench.action.focusFirstEditorGroup" },

  // Ctrl+E → 파일 이름으로 빠른 열기
  { "key": "ctrl+e", "command": "workbench.action.quickOpen" },
  { "key": "ctrl+p", "command": "-workbench.action.quickOpen" },

  // Esc → 에디터로 복귀
  { "key": "escape", "command": "workbench.action.focusActiveEditorGroup", "when": "sideBarFocus && !inputFocus" },

  // Enter → 파일 열기 / 디렉터리 토글
  { "key": "enter", "command": "explorer.openAndPassFocus", "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus && !explorerResourceIsFolder" },
  { "key": "enter", "command": "list.toggleExpand", "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus && explorerResourceIsFolder" },
  { "key": "enter", "command": "-renameFile", "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus" },

  // Ctrl+N → 탐색기에서 선택 위치에 새 파일 / Ctrl+Shift+N → 새 폴더 (탐색기 포커스일 때만)
  // when으로 탐색기에 한정 — 에디터에선 기본 Ctrl+N(새 파일)·Ctrl+Shift+N(새 창) 그대로
  { "key": "ctrl+n", "command": "explorer.newFile", "when": "explorerViewletFocus" },
  { "key": "ctrl+shift+n", "command": "explorer.newFolder", "when": "explorerViewletFocus" },

  // Ctrl+Alt+F12 → 선택 파일·폴더를 파일 탐색기에서 표시 (Reveal in File Explorer). 기본 단축키 없는 동작
  { "key": "ctrl+alt+f12", "command": "revealFileInOS", "when": "explorerViewletFocus" },

  // Ctrl+Alt+Y → 파일 디스크에서 다시 읽기
  { "key": "ctrl+alt+y", "command": "workbench.action.files.revert" },

  // Win+←/→ → 이전/다음 탭
  // ⚠️ Win+←/→ 는 윈도우 창 스냅 단축키와 충돌. 시스템 설정에서 스냅 단축키를 끄거나 다른 키로 조정 필요
  { "key": "win+left", "command": "workbench.action.previousEditor" },
  { "key": "win+right", "command": "workbench.action.nextEditor" },

  // Ctrl+Alt+P → 풀 / Ctrl+Alt+K → 푸시
  { "key": "ctrl+alt+p", "command": "git.pull" },
  { "key": "ctrl+alt+k", "command": "git.push" },

  // Ctrl+9 → Git(소스 컨트롤) 사이드바
  { "key": "ctrl+9", "command": "workbench.view.scm" },

  // Ctrl+Y 줄 삭제 / Ctrl+D 줄 복제 / Ctrl+W 선택 확장
  { "key": "ctrl+y", "command": "editor.action.deleteLines", "when": "editorTextFocus && !editorReadonly" },
  { "key": "ctrl+d", "command": "editor.action.copyLinesDownAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "ctrl+w", "command": "editor.action.smartSelect.expand", "when": "editorTextFocus" },
  { "key": "ctrl+shift+w", "command": "editor.action.smartSelect.shrink", "when": "editorTextFocus" },

  // Win+F4 → 현재 탭 닫기
  // ⚠️ Win+F4 는 윈도우 창 닫기 단축키와 충돌. 다른 키로 조정 필요
  { "key": "win+f4", "command": "workbench.action.closeActiveEditor" },

  // Win+Alt+] 화면 분할 / Win+Alt+[ 분할 제거
  { "key": "win+alt+]", "command": "workbench.action.splitEditor" },
  { "key": "win+alt+[", "command": "workbench.action.joinAllGroups" },

  // 분할 화면 포커스 이동
  { "key": "win+alt+shift+]", "command": "workbench.action.focusRightGroup" },
  { "key": "win+alt+shift+[", "command": "workbench.action.focusLeftGroup" },

  // Ctrl+Shift+F12 → Zen Mode 토글
  { "key": "ctrl+shift+f12", "command": "workbench.action.toggleZenMode" },

  // Ctrl+Shift+→/← → 사이드바 폭 조정 (사이드바 포커스일 때만)
  { "key": "ctrl+shift+right", "command": "workbench.action.decreaseViewWidth", "when": "sideBarFocus" },
  { "key": "ctrl+shift+left",  "command": "workbench.action.increaseViewWidth", "when": "sideBarFocus" }
]
```

### 윈도우 시스템 충돌 주의

| 단축키 | 윈도우 시스템 동작 | 해결 방법 |
|---|---|---|
| `Win+←/→` | 창 스냅 (좌/우 절반 배치) | 설정 → 시스템 → 멀티태스킹 → 창 스냅 비활성화 |
| `Win+F4` | 현재 창 닫기 | 다른 키로 변경 권장 (예: `ctrl+F4`) |

---

## 5. Settings Sync (GitHub 계정 연동)

윈도우에서는 Settings Sync를 사용하지 않는다. 설정·확장·단축키는 이 가이드를 참고해 수동으로 적용한다.

