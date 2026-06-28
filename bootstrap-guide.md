# Claude Code 부트스트랩 가이드

Claude Code를 획득하기 위한 최소 설치. 이후 나머지 설정은 Claude Code에 위임한다.

```powershell
# 1. Node.js (Claude Code 실행 런타임)
winget install --id OpenJS.NodeJS.LTS -e --source winget

# 2. Claude 데스크톱 앱
winget install --id Anthropic.Claude -e --source winget

# 3. Claude Code CLI
npm install -g @anthropic-ai/claude-code
```
