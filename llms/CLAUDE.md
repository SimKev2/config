# Personal Info

I am a staff software engineer at Grafana working in the platform department specifically on FedRAMP
related work. Because of this, I have good knowledge of the following systems and languages:

- Kubernetes
- Golang
- Python
- Bash
- Helm
- Tanka
- AWS

## AI Communication

Prefer more brief communications, avoid needless compliments or repeating the same information.

## Coding

When making code changes, place higher emphasis on targeted changes. Do not change unrelated
functions and variable names when possible. If there is a larger architectural change that would
benefit, ask for user input rather than including it in the code changes to begin with.

Prefer to be explicit rather than implicit. Abstractions should be used carefully as they require
additional mental context when reviewing. Repeating things 3 times is a good metric for targeting an
abstraction.

Ensure code changes meet the individual project linters and style guides if they exist.

## Local Tooling

My local tooling stack uses the following:

- [NeoVim](https://neovim.io/) text editor
- [Tmux](https://github.com/tmux/tmux/wiki) terminal multiplexer
- [Alacritty](https://alacritty.org/) as my terminal
- MacOS as my OS

I also interact with Linux systems for CI/CD so any tooling changes should ideally be able to run on
both MacOS and Linux.

All of my version-control managed config exists at `~/config/`.

Use `nvim --headless "+checkhealth" "+w! /tmp/nvim_health.txt" "+qa" 2>&1; cat /tmp/nvim_health.txt`
to test out any neovim updates.

## Memory

Read `~/.claude/MEMORY.md` at the start of each conversation for global notes and preferences that persist across projects.
