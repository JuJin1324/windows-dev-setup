# Git 설정 가이드 — 윈도우 11

Git Bash + zsh 환경에서 Git을 사용할 수 있도록 기본 설정을 잡는다.

---

## 1. git config 설정

Git Bash(zsh)에서 실행:

```bash
git config --global user.name "JuJin"
git config --global user.email "drlivingston1324@gmail.com"
git config --global core.autocrlf input
git config --global core.editor "code --wait"
git config --global init.defaultBranch main
git config --global color.ui auto
```

설정 확인:

```bash
git config --list
```

---

## 2. SSH 키 생성

```bash
ssh-keygen -t ed25519 -C "drlivingston1324@gmail.com"
```

경로·파일명 입력 요청 시 기본값(`~/.ssh/id_ed25519`)으로 Enter. 패스프레이즈는 선택.

---

## 3. SSH 키 GitHub 등록

공개 키를 클립보드에 복사:

```bash
cat ~/.ssh/id_ed25519.pub
```

출력된 내용을 복사한 뒤 GitHub → **Settings → SSH and GPG keys → New SSH key** 에 붙여넣고 저장.

---

## 4. SSH 연결 확인

```bash
ssh -T git@github.com
```

`Hi JuJin! You've successfully authenticated...` 메시지가 나오면 완료.

---

## 5. 동작 확인

```bash
git clone git@github.com:JuJin1324/<레포명>.git
```

클론이 정상적으로 되면 Git 설정 완료.
