# windows-dev-setup

## Phase 1 — Claude Code 부트스트랩 (PowerShell)

winget은 Win11 기본 탑재라 별도 설치 없이 PowerShell에서 바로 실행한다. Node.js → Claude 앱 → Claude Code 순으로 설치해 Phase 2를 위임할 수 있다.

| 순서 | 가이드 | 내용 |
|---|---|---|
| 1 | [bootstrap-guide.md](bootstrap-guide.md) | Node.js + Claude 앱 + Claude Code CLI |

## Phase 2 — 나머지 설정 (Claude Code 위임 또는 병렬 수동)

keyboard-remap-guide는 독립적으로 언제든 실행 가능. setup-guide 완료 후 git-setup-guide와 vscode-setup-guide를 진행한다.

| 순서 | 가이드 | 내용 |
|---|---|---|
| 2 | [keyboard-remap-guide.md](keyboard-remap-guide.md) | Ctrl ↔ Win 키 스왑 + 트랙패드 탭 클릭 비활성화 |
| 2 | [wsl-setup-guide.md](wsl-setup-guide.md) | WSL2 활성화 + 최적화 (Docker 설치 선행) |
| 2 | [winget-guide.md](winget-guide.md) | CLI 도구·GUI 앱 설치 (언어 런타임 포함) |
| 2 | [setup-guide.md](setup-guide.md) | Git Bash + zsh + Windows Terminal 설치 및 설정 + OS 성능 설정 |
| 3 | [git-setup-guide.md](git-setup-guide.md) | Git config + SSH 키 생성 및 GitHub 등록 |
| 3 | [vscode-setup-guide.md](vscode-setup-guide.md) | VSCode 설치 및 설정 |
| 3 | [browser-memory-guide.md](browser-memory-guide.md) | Edge·Chrome 메모리 절약 설정 |
