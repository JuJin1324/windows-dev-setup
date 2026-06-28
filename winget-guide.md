# winget 설치 가이드 — Homebrew 대응 프로그램

맥 Brewfile 기준으로 윈도우 대응 항목을 정리했다. 각 항목의 설치 여부는 필요에 따라 판단한다.

winget 외에 **Scoop**을 보조로 사용한다. CLI 도구에 특화되어 있고, 관리자 권한 없이 설치·제거가 깔끔하다.

```powershell
# Scoop 설치 (PowerShell)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

---

## 언어·런타임

| Homebrew | winget | 비고 |
|---|---|---|
| node | `winget install --id OpenJS.NodeJS.LTS -e --source winget` | |
| python@3.10 | `winget install --id Python.Python.3.10 -e --source winget` | |
| rust | `winget install --id Rustlang.Rustup -e --source winget` | |

```powershell
winget install --id OpenJS.NodeJS.LTS -e --source winget
winget install --id Python.Python.3.10 -e --source winget
winget install --id Rustlang.Rustup -e --source winget
```

---

## 터미널 UX

| Homebrew | 윈도우 설치 | 비고 |
|---|---|---|
| bat | `winget install --id sharkdp.bat -e --source winget` | |
| eza | `scoop install eza` | winget 패키지 불안정 — Scoop 사용 |
| fd | `winget install --id sharkdp.fd -e --source winget` | |
| fzf | `winget install --id junegunn.fzf -e --source winget` | |
| ripgrep | `winget install --id BurntSushi.ripgrep.MSVC -e --source winget` | |
| wget | `winget install --id GNU.Wget2 -e --source winget` | |
| tree | 윈도우 기본 내장 (`tree` 명령) | 별도 설치 불필요 |
| thefuck | `pip install thefuck` | npm 미지원, pip 사용 |

```powershell
winget install --id sharkdp.bat -e --source winget
winget install --id sharkdp.fd -e --source winget
winget install --id junegunn.fzf -e --source winget
winget install --id BurntSushi.ripgrep.MSVC -e --source winget
winget install --id GNU.Wget2 -e --source winget
scoop install eza
pip install thefuck
```

---

## 시스템 도구

| Homebrew | winget | 비고 |
|---|---|---|
| fastfetch | `winget install --id Fastfetch-cli.Fastfetch -e --source winget` | |
| sevenzip | `winget install --id 7zip.7zip -e --source winget` | |
| speedtest-cli | `winget install --id Ookla.Speedtest.CLI -e --source winget` | |
| htop | `scoop install btop` | htop 윈도우 미지원 — btop이 가장 유사한 TUI |

```powershell
winget install --id Fastfetch-cli.Fastfetch -e --source winget
winget install --id 7zip.7zip -e --source winget
winget install --id Ookla.Speedtest.CLI -e --source winget
scoop install btop
```

---

## 개발 도구

| Homebrew | winget | 비고 |
|---|---|---|
| gh | `winget install --id GitHub.cli -e --source winget` | |
| jq | `winget install --id jqlang.jq -e --source winget` | |
| lazygit | `winget install --id JesseDuffield.lazygit -e --source winget` | |
| docker | `winget install --id Docker.DockerDesktop -e --source winget` | **선행: [wsl-setup-guide.md](wsl-setup-guide.md)** (WSL2 활성화 필요) |
| cmake | `winget install --id Kitware.CMake -e --source winget` | |
| ffmpeg | `winget install --id Gyan.FFmpeg -e --source winget` | |
| graphviz | `winget install --id Graphviz.Graphviz -e --source winget` | |
| pandoc | `winget install --id JohnMacFarlane.Pandoc -e --source winget` | |
| k6 | `winget install --id k6.k6 -e --source winget` | |
| httpie | `scoop install xh` | npm 미지원, Rust 기반 대안(xh) 사용 |
| mycli | `pip install mycli` | npm 미지원, pip 사용 |
| mysql | `winget install --id Oracle.MySQL -e --source winget` | |
| lazydocker | `winget install --id jesseduffield.lazydocker -e --source winget` | |
| netcat | nmap 패키지에 포함 (`winget install --id Insecure.Nmap -e --source winget`) | |
| telnet | Windows 선택적 기능으로 활성화 | |

```powershell
winget install --id GitHub.cli -e --source winget
winget install --id jqlang.jq -e --source winget
winget install --id JesseDuffield.lazygit -e --source winget
winget install --id Docker.DockerDesktop -e --source winget
winget install --id Kitware.CMake -e --source winget
winget install --id Gyan.FFmpeg -e --source winget
winget install --id Graphviz.Graphviz -e --source winget
winget install --id JohnMacFarlane.Pandoc -e --source winget
winget install --id k6.k6 -e --source winget
scoop install xh
pip install mycli
```

---

## GUI 앱

| Homebrew cask | winget | 비고 |
|---|---|---|
| visual-studio-code | vscode-setup-guide.md에서 설치 | |
| notion | `winget install --id Notion.Notion -e --source winget` | |
| postman | `winget install --id Postman.Postman -e --source winget` | |
| drawio | `winget install --id JGraph.Draw -e --source winget` | |
| google-chrome | `winget install --id Google.Chrome -e --source winget` | |
| chatgpt | `winget install --id OpenAI.ChatGPT -e --source winget` | |
| claude | bootstrap-guide.md에서 설치 | |
| kakaotalk | `winget install --id Kakao.KakaoTalk -e --source winget` | |

```powershell
winget install --id Notion.Notion -e --source winget
winget install --id Postman.Postman -e --source winget
winget install --id JGraph.Draw -e --source winget
winget install --id Google.Chrome -e --source winget
winget install --id OpenAI.ChatGPT -e --source winget
winget install --id Kakao.KakaoTalk -e --source winget
```

---

## npm 글로벌

| 항목 | 설치 명령 |
|---|---|
| bash-language-server | `npm install -g bash-language-server` |

```bash
npm install -g bash-language-server
```
