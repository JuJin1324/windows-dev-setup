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

## 3. 확장 프로그램

### 3-1. 원칙

확장은 대부분 별도 프로세스나 언어 서버를 띄운다. 특히 **Java 언어 서버(JDTLS)는 자체 JVM을 띄워 1GB 안팎을 먹는다.** 16GB 환경에서 React와 Spring Boot를 같이 보려면 개수 관리가 필요하다.

- **기본 기능으로 되는 건 설치하지 않는다.** VSCode에 이미 들어간 기능을 확장으로 중복 설치한 경우가 많다 (3-5 참고).
- **프로젝트 성격이 다르면 프로필로 분리한다** (3-6 참고). React 창에서 Java 언어 서버가 뜰 이유가 없다.
- 설치 후에는 `Ctrl+Shift+P` → **Developer: Show Running Extensions**로 실제 로드된 확장과 활성화 시간을 확인한다.

### 3-2. 공통

```bash
code --install-extension pkief.material-icon-theme
code --install-extension editorconfig.editorconfig
```

#### EditorConfig가 하는 일

프로젝트 루트의 `.editorconfig` 파일에 적힌 **들여쓰기·개행·인코딩 규칙을 VSCode가 따르게** 한다. 규칙이 사람이 아니라 저장소에 붙는다는 게 핵심이다.

2번 설정에서 `editor.tabSize`를 4로 박아 뒀는데, 이건 **모든 프로젝트에 4칸이 적용된다**는 뜻이다. React(관례상 2칸)와 Java(4칸)를 오가면 한쪽은 계속 어긋난다. 저장소에 `.editorconfig`가 있으면 그 폴더에서만 규칙이 자동으로 바뀐다.

```ini
# React 프로젝트의 .editorconfig 예시
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.{ts,tsx,js,jsx,json}]
indent_style = space
indent_size = 2
```

- **작업 중인 저장소에 `.editorconfig`가 없다면 이 확장은 아무 일도 하지 않는다.** 그 경우 설치할 이유가 없다.
- 팀 저장소에 이미 파일이 있다면 설치하는 편이 낫다. 없이 작업하면 본인 설정대로 저장되어 diff에 공백 변경이 섞인다.
- Prettier와 역할이 겹치는 부분(들여쓰기)이 있는데, Prettier가 `.editorconfig`를 읽어 반영하므로 충돌하지 않는다.

### 3-3. 프론트엔드 (React + TypeScript)

```bash
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
```

이 둘이면 충분하다. **TypeScript는 VSCode에 내장**되어 있다. `.tsx` 타입 체크·자동 완성·리팩터링·Import 정리·Emmet·npm 스크립트 실행이 모두 기본 기능이라, TypeScript 관련 확장은 설치할 게 없다.

프로젝트의 TypeScript 버전과 에디터 버전을 맞추려면 (타입 오류가 터미널과 에디터에서 다르게 나올 때) 설정에 추가한다:

```jsonc
{
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true
}
```

프로젝트에서 실제로 쓸 때만 추가한다.

| 확장 | ID | 조건 |
|---|---|---|
| Tailwind CSS IntelliSense | `bradlc.vscode-tailwindcss` | Tailwind를 쓸 때만 |
| Vitest / Jest | `vitest.explorer` / `orta.vscode-jest` | 테스트를 에디터에서 돌릴 때만 |

#### Prettier 포맷 시점

확장만 설치해도 `Shift+Alt+F`(Format Document)로 **수동 포맷은 된다.** 아래 설정은 자동화를 위한 것이다.

```jsonc
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",  // 포매터 선택 프롬프트 제거
  "editor.formatOnSave": true                            // 저장 시 자동 포맷
}
```

- `defaultFormatter`가 없으면 포매터가 여러 개일 때(ESLint·TS 기본 포매터 등) 포맷할 때마다 무엇을 쓸지 묻는다.
- **`formatOnSave`는 `files.autoSave: "afterDelay"`의 지연 저장에는 발동하지 않는다.** 명시적 저장(`Ctrl+S`)에만 걸린다. 2번 설정이 `afterDelay`이므로 실제 동작은 이렇게 된다:

  | 저장 방식 | 포맷 |
  |---|---|
  | 지연 자동 저장 | 안 됨 |
  | `Ctrl+S` | 됨 |

  타이핑 중에 코드가 재배치되지 않아 오히려 방해가 적다. **정리하고 싶을 때 `Ctrl+S`를 누르는 식**으로 쓰면 된다.

### 3-4. 백엔드 (Java + Spring Boot)

```bash
code --install-extension vscjava.vscode-java-pack
code --install-extension vmware.vscode-boot-dev-pack
```

두 개가 **확장 팩**이라 각각 여러 확장을 함께 설치한다. 개별 설치보다 이쪽이 버전 호환이 안전하다.

| 팩 | 포함 내용 |
|---|---|
| Extension Pack for Java | Language Support for Java(JDTLS), 디버거, 테스트 러너, Maven, 프로젝트 매니저, IntelliCode |
| Spring Boot Extension Pack | Spring Boot Tools(`application.yml`·빈 탐색), Initializr, Dashboard |

**Maven 프로젝트에는 추가 확장이 필요 없다.** Maven for Java가 Extension Pack for Java에 이미 포함되어 있어, `pom.xml`이 있는 폴더를 열면 탐색기 하단에 **MAVEN** 패널이 생기고 여기서 라이프사이클(clean·compile·test·package)을 실행할 수 있다. Gradle 확장(`vscjava.vscode-gradle`)은 설치하지 않는다.

**JDK가 먼저 설치되어 있어야 한다.** winget-guide에서 설치한 JDK 경로를 설정에 지정한다:

```jsonc
{
  "java.jdt.ls.java.home": "C:\\Program Files\\Eclipse Adoptium\\jdk-21...",
  "java.configuration.runtimes": [
    { "name": "JavaSE-21", "path": "C:\\Program Files\\Eclipse Adoptium\\jdk-21...", "default": true }
  ]
}
```

#### 언어 서버 메모리 제한

JDTLS는 기본적으로 넉넉히 잡는다. 16GB 환경에서는 상한을 명시하는 편이 낫다.

```jsonc
{
  "java.jdt.ls.vmargs": "-XX:+UseParallelGC -XX:GCTimeRatio=4 -Xmx1G",
  "java.autobuild.enabled": false  // 저장할 때마다 전체 빌드하지 않음. 대신 수동 빌드 필요
}
```

> `java.autobuild.enabled`를 끄면 컴파일 오류를 실시간으로 못 본다. 프로젝트가 커서 저장할 때마다 버벅일 때만 끈다.

### 3-5. 설치하지 않는 것

#### 이미 내장된 기능

| 흔히 설치하는 확장 | 대체 |
|---|---|
| Auto Rename Tag | 설정 `"editor.linkedEditing": true` |
| Bracket Pair Colorizer | 기본 활성화 (`editor.bracketPairColorization.enabled`) |
| Path Intellisense | JS/TS 언어 서비스에 내장 |
| npm scripts 실행 확장 | 탐색기 하단 **NPM 스크립트** 패널 |
| Live Server | Vite/CRA 개발 서버로 대체 |
| ES7 React snippets | 스니펫만 제공. 자동 완성과 중복되어 오히려 방해되는 경우가 많음 |
| TypeScript 관련 확장 | VSCode에 내장 (3-3 참고) |

#### 충돌·성능 때문에 빼는 것

| 확장 | 이유 |
|---|---|
| Markdown All in One (`yzhang.markdown-all-in-one`) | 2번 설정의 `workbench.editorAssociations`가 `.md`를 기본 미리보기로 여는데 자체 미리보기와 충돌한다. 미리보기·목차·문법 강조는 기본 기능으로 충분 |
| markdownlint (`davidanson.vscode-markdownlint`) | 문서 저장소에서 경고가 과하게 뜬다. 린트가 필요한 규모가 아님 |
| GitLens (`eamodio.gitlens`) | 무겁고, 저장소가 크면 백그라운드에서 계속 git 명령을 돌린다. blame·히스토리는 기본 소스 컨트롤로 확인 |
| Gradle for Java (`vscjava.vscode-gradle`) | Maven 프로젝트라 불필요 (3-4 참고) |

### 3-6. 프로필로 프론트/백엔드 분리

VSCode 프로필은 **설정·확장·단축키 묶음**을 통째로 전환한다. React 프로젝트를 열 때 Java 확장이 로드되지 않게 하는 가장 확실한 방법이다.

1. `Ctrl+Shift+P` → **Profiles: Create Profile** → `react`, `java` 두 개 생성
2. 각 프로필에서 해당 섹션(3-3 / 3-4)의 확장만 설치
3. 폴더에 프로필 고정: 해당 폴더를 연 상태에서 `Ctrl+Shift+P` → **Profiles: Switch Profile** 로 선택하면 이후 그 폴더는 같은 프로필로 열린다

공통 확장(3-2)은 **Default 프로필**에 두고 각 프로필이 상속받게 하거나, 프로필 생성 시 기존 프로필에서 복사한다.

CLI로 지정해 열 수도 있다:

```bash
code --profile java ~/Documents/dev/workspace-pe/some-spring-project
```

> 프론트·백엔드를 한 창에서 동시에 봐야 하는 상황(예: API 스펙 대조)이 잦다면 프로필 분리가 오히려 불편하다. 그때는 창을 두 개 띄우되 프로필을 나눠 쓴다.

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

