#!/bin/zsh
# Helper functions for CachyOS development environment

# ============================================================================
# ALIAS HELPER - Display all custom aliases with descriptions
# ============================================================================

alias-help() {
    # Colors
    local HEADER='\033[1;36m'    # Cyan bold
    local ALIAS='\033[1;32m'     # Green bold
    local DESC='\033[0;37m'      # White
    local RESET='\033[0m'
    local DIM='\033[0;90m'       # Gray

    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${HEADER}                    CUSTOM ALIASES REFERENCE                        ${RESET}"
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""

    echo -e "${HEADER}📦 PACKAGE MANAGEMENT (CachyOS/Arch)${RESET}"
    echo -e "  ${ALIAS}update${RESET}          ${DESC}Update all packages (pacman -Syu)${RESET}"
    echo -e "  ${ALIAS}install${RESET}         ${DESC}Install package (pacman -S)${RESET}"
    echo -e "  ${ALIAS}search${RESET}          ${DESC}Search packages (pacman -Ss)${RESET}"
    echo -e "  ${ALIAS}remove${RESET}          ${DESC}Remove package (pacman -Rns)${RESET}"
    echo -e "  ${ALIAS}aur${RESET}             ${DESC}AUR helper (paru/yay)${RESET}"
    echo ""

    echo -e "${HEADER}📁 NAVIGATION & DOTFILES${RESET}"
    echo -e "  ${ALIAS}..${RESET}              ${DESC}Go up one directory${RESET}"
    echo -e "  ${ALIAS}...${RESET}             ${DESC}Go up two directories${RESET}"
    echo -e "  ${ALIAS}....${RESET}            ${DESC}Go up three directories${RESET}"
    echo -e "  ${ALIAS}devdir${RESET}          ${DESC}cd ~/dev${RESET}"
    echo -e "  ${ALIAS}dotfiles${RESET}        ${DESC}cd ~/dev/cachyos-dev-ai-dotfiles${RESET}"
    echo ""

    echo -e "${HEADER}🔄 DOTFILES SYNC${RESET}"
    echo -e "  ${ALIAS}sync-status${RESET}     ${DESC}Check dotfiles sync status${RESET}"
    echo -e "  ${ALIAS}sync-push${RESET}       ${DESC}Push dotfiles to repo${RESET}"
    echo -e "  ${ALIAS}sync-pull${RESET}       ${DESC}Pull dotfiles from repo${RESET}"
    echo ""

    echo -e "${HEADER}🔧 GIT SHORTCUTS - BASIC${RESET}"
    echo -e "  ${ALIAS}gs${RESET}              ${DESC}git status${RESET}"
    echo -e "  ${ALIAS}gd${RESET}              ${DESC}git diff${RESET}"
    echo -e "  ${ALIAS}gc${RESET}              ${DESC}git commit${RESET}"
    echo -e "  ${ALIAS}ga${RESET}              ${DESC}git add${RESET}"
    echo -e "  ${ALIAS}gp${RESET}              ${DESC}git push${RESET}"
    echo -e "  ${ALIAS}gl${RESET}              ${DESC}git log (graph)${RESET}"
    echo -e "  ${ALIAS}gco${RESET}             ${DESC}git checkout${RESET}"
    echo ""

    echo -e "${HEADER}🔧 GIT SHORTCUTS - EXTENDED${RESET}"
    echo -e "  ${ALIAS}gaa${RESET}             ${DESC}git add --all${RESET}"
    echo -e "  ${ALIAS}gcm${RESET}             ${DESC}git commit -m${RESET}"
    echo -e "  ${ALIAS}gcam${RESET}            ${DESC}git commit -am${RESET}"
    echo -e "  ${ALIAS}gpl${RESET}             ${DESC}git pull${RESET}"
    echo -e "  ${ALIAS}gf${RESET}              ${DESC}git fetch${RESET}"
    echo -e "  ${ALIAS}grb${RESET}             ${DESC}git rebase${RESET}"
    echo -e "  ${ALIAS}gst${RESET}             ${DESC}git stash${RESET}"
    echo -e "  ${ALIAS}gstp${RESET}            ${DESC}git stash pop${RESET}"
    echo -e "  ${ALIAS}gcl${RESET}             ${DESC}git clone${RESET}"
    echo -e "  ${ALIAS}gb${RESET}              ${DESC}git branch${RESET}"
    echo -e "  ${ALIAS}gundo${RESET}           ${DESC}git reset --soft HEAD~1${RESET}"
    echo ""

    echo -e "${HEADER}🔧 DOTFILES GIT${RESET}"
    echo -e "  ${ALIAS}dotgit${RESET}          ${DESC}Git commands in dotfiles repo${RESET}"
    echo -e "  ${ALIAS}dotst${RESET}           ${DESC}dotfiles git status${RESET}"
    echo -e "  ${ALIAS}dotdiff${RESET}         ${DESC}dotfiles git diff${RESET}"
    echo -e "  ${ALIAS}dotlog${RESET}          ${DESC}dotfiles git log (graph)${RESET}"
    echo ""

    echo -e "${HEADER}🤖 CLAUDE CODE${RESET}"
    echo -e "  ${ALIAS}c${RESET}               ${DESC}Launch Claude Code${RESET}"
    echo -e "  ${ALIAS}cc${RESET}              ${DESC}Launch Claude Code${RESET}"
    echo -e "  ${ALIAS}claude${RESET}          ${DESC}Launch Claude Code${RESET}"
    echo -e "  ${ALIAS}ccd${RESET}             ${DESC}Claude (skip permissions)${RESET}"
    echo -e "  ${ALIAS}ccinit${RESET}          ${DESC}Initialize Claude in project${RESET}"
    echo -e "  ${ALIAS}claude-init${RESET}     ${DESC}Initialize Claude in project${RESET}"
    echo ""

    echo -e "${HEADER}📊 SYSTEM MONITORING${RESET}"
    echo -e "  ${ALIAS}sysmon${RESET}          ${DESC}btop + nvtop side-by-side (tmux)${RESET}"
    echo -e "  ${ALIAS}sysmon-kill${RESET}     ${DESC}Kill sysmon session${RESET}"
    echo -e "  ${ALIAS}cpu${RESET}             ${DESC}Watch CPU frequencies${RESET}"
    echo -e "  ${ALIAS}temp${RESET}            ${DESC}Watch temperatures${RESET}"
    echo -e "  ${ALIAS}ports${RESET}           ${DESC}Show listening ports${RESET}"
    echo ""

    echo -e "${HEADER}💻 TMUX${RESET}"
    echo -e "  ${ALIAS}ta${RESET}              ${DESC}tmux attach -t${RESET}"
    echo -e "  ${ALIAS}tl${RESET}              ${DESC}tmux list-sessions${RESET}"
    echo -e "  ${ALIAS}tn${RESET}              ${DESC}tmux new-session -s${RESET}"
    echo ""

    echo -e "${HEADER}✏️  EDITOR - MICRO${RESET}"
    echo -e "  ${ALIAS}micro${RESET}           ${DESC}Modern, mouse-friendly editor${RESET}"
    echo -e "  ${ALIAS}edit / e / m${RESET}    ${DESC}Shortcuts for micro${RESET}"
    echo -e "  ${ALIAS}vim${RESET}             ${DESC}Redirected to micro (use ovim for real vim)${RESET}"
    echo -e "  ${DIM}Ctrl+S: save, Ctrl+Q: quit, Ctrl+F: find, Mouse: full support${RESET}"
    echo ""

    echo -e "${HEADER}✏️  QUICK EDITS${RESET}"
    echo -e "  ${ALIAS}zshrc${RESET}           ${DESC}Edit ~/.zshrc${RESET}"
    echo -e "  ${ALIAS}aliases${RESET}         ${DESC}Edit aliases.sh${RESET}"
    echo -e "  ${ALIAS}vimrc${RESET}           ${DESC}Edit ~/.vimrc${RESET}"
    echo ""

    echo -e "${HEADER}🌐 NETWORK${RESET}"
    echo -e "  ${ALIAS}myip${RESET}            ${DESC}Show public IP${RESET}"
    echo -e "  ${ALIAS}localip${RESET}         ${DESC}Show local IP addresses${RESET}"
    echo ""

    echo -e "${HEADER}📄 MODERN CLI - BAT (better cat)${RESET}"
    echo -e "  ${ALIAS}cat${RESET}             ${DESC}bat with syntax highlighting${RESET}"
    echo -e "  ${ALIAS}b${RESET}               ${DESC}bat (short alias)${RESET}"
    echo -e "  ${ALIAS}bp${RESET}              ${DESC}bat with paging${RESET}"
    echo -e "  ${ALIAS}bn${RESET}              ${DESC}bat plain (no line numbers)${RESET}"
    echo -e "  ${DIM}Colored man pages enabled!${RESET}"
    echo ""

    echo -e "${HEADER}📂 MODERN CLI - EZA (better ls)${RESET}"
    echo -e "  ${ALIAS}ls${RESET}              ${DESC}eza with directories first${RESET}"
    echo -e "  ${ALIAS}ll${RESET}              ${DESC}long format with git status${RESET}"
    echo -e "  ${ALIAS}la${RESET}              ${DESC}show all files${RESET}"
    echo -e "  ${ALIAS}lt${RESET}              ${DESC}tree view (2 levels)${RESET}"
    echo -e "  ${ALIAS}lg${RESET}              ${DESC}with git status${RESET}"
    echo -e "  ${ALIAS}lm${RESET}              ${DESC}sort by modified time${RESET}"
    echo ""

    echo -e "${HEADER}🔎 MODERN CLI - FD (better find)${RESET}"
    echo -e "  ${ALIAS}find${RESET}            ${DESC}fd (respects .gitignore)${RESET}"
    echo -e "  ${ALIAS}fda${RESET}             ${DESC}find all (including hidden)${RESET}"
    echo -e "  ${ALIAS}fdd${RESET}             ${DESC}find directories only${RESET}"
    echo -e "  ${ALIAS}fdf${RESET}             ${DESC}find files only${RESET}"
    echo -e "  ${ALIAS}fde <ext>${RESET}       ${DESC}find by extension${RESET}"
    echo ""

    echo -e "${HEADER}🔍 SEARCH - RIPGREP${RESET}"
    echo -e "  ${ALIAS}rg${RESET}              ${DESC}Search for pattern (ripgrep)${RESET}"
    echo -e "  ${ALIAS}rgi${RESET}             ${DESC}Case-insensitive search${RESET}"
    echo -e "  ${ALIAS}rgh${RESET}             ${DESC}Include hidden files${RESET}"
    echo -e "  ${ALIAS}rgf${RESET}             ${DESC}List all files (respects .gitignore)${RESET}"
    echo -e "  ${ALIAS}rgpy/rgjs/rgsh${RESET}  ${DESC}Search specific file types${RESET}"
    echo -e "  ${ALIAS}rg1/rg3/rg5${RESET}     ${DESC}Search with 1/3/5 lines of context${RESET}"
    echo -e "  ${ALIAS}rgl${RESET}             ${DESC}Only show filenames with matches${RESET}"
    echo -e "  ${ALIAS}rgc${RESET}             ${DESC}Count matches per file${RESET}"
    echo -e "  ${DIM}Run 'rg-help' for detailed examples${RESET}"
    echo ""

    echo -e "${HEADER}🐳 DOCKER & CONTAINERS${RESET}"
    echo -e "  ${ALIAS}dps${RESET}             ${DESC}List running containers${RESET}"
    echo -e "  ${ALIAS}dex${RESET}             ${DESC}Execute command in container${RESET}"
    echo -e "  ${ALIAS}dlogs${RESET}           ${DESC}View container logs${RESET}"
    echo -e "  ${ALIAS}dc${RESET}              ${DESC}Docker compose${RESET}"
    echo -e "  ${ALIAS}dcu${RESET}             ${DESC}Docker compose up${RESET}"
    echo -e "  ${ALIAS}dprune${RESET}          ${DESC}Clean up docker system${RESET}"
    echo -e "  ${ALIAS}dgpu${RESET}            ${DESC}Docker run with GPU${RESET}"
    echo -e "  ${DIM}Run 'docker-help' for detailed examples${RESET}"
    echo ""

    echo -e "${HEADER}🐍 PYTHON (UV)${RESET}"
    echo -e "  ${ALIAS}v${RESET}               ${DESC}Run Python with uv venv${RESET}"
    echo -e "  ${ALIAS}v script.py${RESET}     ${DESC}Run script in uv venv${RESET}"
    echo -e "  ${ALIAS}v pip install${RESET}   ${DESC}Install package in uv venv${RESET}"
    echo -e "  ${ALIAS}vpy${RESET}             ${DESC}Interactive Python (uv venv)${RESET}"
    echo ""

    echo -e "${HEADER}🛠️  FUNCTIONS${RESET}"
    echo -e "  ${ALIAS}mkcd <dir>${RESET}      ${DESC}Create directory and cd into it${RESET}"
    echo -e "  ${ALIAS}extract <file>${RESET}  ${DESC}Extract any archive format${RESET}"
    echo ""

    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${DIM}💡 Tip: Use 'alias | grep <keyword>' to search for specific aliases${RESET}"
    echo -e "${DIM}💡 Tip: Run 'alias-help | less' for easier scrolling${RESET}"
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# Short alias for the helper
alias ah='alias-help'
alias aliases-help='alias-help'

# ============================================================================
# OTHER HELPER FUNCTIONS
# ============================================================================

# Quick system info
sysinfo() {
    echo -e "\033[1;36m=== System Information ===\033[0m"
    echo -e "\033[1;32mOS:\033[0m $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo -e "\033[1;32mKernel:\033[0m $(uname -r)"
    echo -e "\033[1;32mUptime:\033[0m $(uptime -p)"
    echo -e "\033[1;32mShell:\033[0m $SHELL"
    echo -e "\033[1;32mCPU:\033[0m $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    if command -v nvidia-smi &>/dev/null; then
        echo -e "\033[1;32mGPU:\033[0m $(nvidia-smi --query-gpu=name --format=csv,noheader | head -1)"
    fi
}

# Ripgrep cheatsheet - common patterns and examples
rg-help() {
    local HEADER='\033[1;36m'
    local CMD='\033[1;32m'
    local DESC='\033[0;37m'
    local EXAMPLE='\033[0;33m'
    local RESET='\033[0m'
    local DIM='\033[0;90m'

    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${HEADER}                    RIPGREP (rg) QUICK REFERENCE                   ${RESET}"
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""

    echo -e "${HEADER}📖 BASICS${RESET}"
    echo -e "  ${CMD}rg 'pattern'${RESET}              ${DESC}Search for pattern in current directory${RESET}"
    echo -e "  ${CMD}rg 'pattern' file.txt${RESET}     ${DESC}Search in specific file${RESET}"
    echo -e "  ${CMD}rg 'pattern' src/${RESET}         ${DESC}Search in specific directory${RESET}"
    echo ""

    echo -e "${HEADER}🔍 SEARCH OPTIONS${RESET}"
    echo -e "  ${CMD}rgi 'pattern'${RESET}             ${DESC}Case-insensitive search${RESET}"
    echo -e "  ${CMD}rgw 'word'${RESET}                ${DESC}Match whole words only${RESET}"
    echo -e "  ${CMD}rgh 'pattern'${RESET}             ${DESC}Include hidden files${RESET}"
    echo -e "  ${CMD}rg -v 'pattern'${RESET}           ${DESC}Invert match (show non-matching lines)${RESET}"
    echo ""

    echo -e "${HEADER}📁 FILE FILTERING${RESET}"
    echo -e "  ${CMD}rgpy 'pattern'${RESET}            ${DESC}Search only Python files${RESET}"
    echo -e "  ${CMD}rgjs 'pattern'${RESET}            ${DESC}Search only JavaScript files${RESET}"
    echo -e "  ${CMD}rg -g '*.json' 'pattern'${RESET}  ${DESC}Search only .json files${RESET}"
    echo -e "  ${CMD}rg -g '!*.min.js' 'pattern'${RESET} ${DESC}Exclude minified JS files${RESET}"
    echo ""

    echo -e "${HEADER}📋 OUTPUT OPTIONS${RESET}"
    echo -e "  ${CMD}rgl 'pattern'${RESET}             ${DESC}Only show matching filenames${RESET}"
    echo -e "  ${CMD}rgc 'pattern'${RESET}             ${DESC}Count matches per file${RESET}"
    echo -e "  ${CMD}rg3 'pattern'${RESET}             ${DESC}Show 3 lines of context${RESET}"
    echo -e "  ${CMD}rg -A 2 'pattern'${RESET}         ${DESC}Show 2 lines after match${RESET}"
    echo -e "  ${CMD}rg -B 2 'pattern'${RESET}         ${DESC}Show 2 lines before match${RESET}"
    echo ""

    echo -e "${HEADER}🎯 ADVANCED PATTERNS${RESET}"
    echo -e "  ${CMD}rg 'foo.*bar'${RESET}             ${DESC}Match 'foo' followed by 'bar'${RESET}"
    echo -e "  ${CMD}rg '^import'${RESET}              ${DESC}Match lines starting with 'import'${RESET}"
    echo -e "  ${CMD}rg 'TODO|FIXME'${RESET}           ${DESC}Match TODO or FIXME${RESET}"
    echo -e "  ${CMD}rg '\bword\b'${RESET}             ${DESC}Word boundary (exact word)${RESET}"
    echo ""

    echo -e "${HEADER}📝 PRACTICAL EXAMPLES${RESET}"
    echo -e "  ${EXAMPLE}# Find all TODO comments in Python files${RESET}"
    echo -e "  ${CMD}rgpy 'TODO|FIXME'${RESET}"
    echo ""
    echo -e "  ${EXAMPLE}# Find function definitions in current dir${RESET}"
    echo -e "  ${CMD}rg 'def \w+\(' --type=py${RESET}"
    echo ""
    echo -e "  ${EXAMPLE}# Find all import statements${RESET}"
    echo -e "  ${CMD}rg '^import |^from ' --type=py${RESET}"
    echo ""
    echo -e "  ${EXAMPLE}# Find all files containing 'API_KEY'${RESET}"
    echo -e "  ${CMD}rgl 'API_KEY'${RESET}"
    echo ""
    echo -e "  ${EXAMPLE}# Search in git-ignored files too${RESET}"
    echo -e "  ${CMD}rg --no-ignore 'pattern'${RESET}"
    echo ""
    echo -e "  ${EXAMPLE}# List all files (respects .gitignore)${RESET}"
    echo -e "  ${CMD}rgf${RESET}"
    echo ""

    echo -e "${HEADER}🔧 YOUR CUSTOM ALIASES${RESET}"
    echo -e "  ${CMD}rgi${RESET}    ${DESC}Case-insensitive${RESET}       ${CMD}rgpy${RESET}   ${DESC}Python files only${RESET}"
    echo -e "  ${CMD}rgh${RESET}    ${DESC}Include hidden${RESET}         ${CMD}rgjs${RESET}   ${DESC}JavaScript files only${RESET}"
    echo -e "  ${CMD}rgf${RESET}    ${DESC}List all files${RESET}         ${CMD}rgsh${RESET}   ${DESC}Shell scripts only${RESET}"
    echo -e "  ${CMD}rg1${RESET}    ${DESC}1 line context${RESET}         ${CMD}rgl${RESET}    ${DESC}Filenames only${RESET}"
    echo -e "  ${CMD}rg3${RESET}    ${DESC}3 lines context${RESET}        ${CMD}rgc${RESET}    ${DESC}Count matches${RESET}"
    echo ""

    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${DIM}💡 Tip: Run 'rg --help' for full documentation${RESET}"
    echo -e "${DIM}💡 Tip: Config file at ~/.rgrc (already set up for you!)${RESET}"
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# Docker shortcuts cheatsheet
docker-help() {
    local HEADER='\033[1;36m'
    local CMD='\033[1;32m'
    local DESC='\033[0;37m'
    local RESET='\033[0m'
    local DIM='\033[0;90m'

    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${HEADER}                    DOCKER SHORTCUTS REFERENCE                     ${RESET}"
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""

    echo -e "${HEADER}📦 CONTAINERS${RESET}"
    echo -e "  ${CMD}dps${RESET}             ${DESC}List running containers${RESET}"
    echo -e "  ${CMD}dpsa${RESET}            ${DESC}List all containers (including stopped)${RESET}"
    echo -e "  ${CMD}dex <id> <cmd>${RESET}  ${DESC}Execute command in container${RESET}"
    echo -e "  ${CMD}dsh <id> bash${RESET}   ${DESC}Open bash shell in container${RESET}"
    echo ""

    echo -e "${HEADER}📝 LOGS${RESET}"
    echo -e "  ${CMD}dlogs <id>${RESET}      ${DESC}Show container logs${RESET}"
    echo -e "  ${CMD}dlogsf <id>${RESET}     ${DESC}Follow container logs${RESET}"
    echo -e "  ${CMD}dlogst <id>${RESET}     ${DESC}Tail last 100 lines and follow${RESET}"
    echo ""

    echo -e "${HEADER}🖼️  IMAGES${RESET}"
    echo -e "  ${CMD}di${RESET}              ${DESC}List images${RESET}"
    echo -e "  ${CMD}dimg${RESET}            ${DESC}List images (same as di)${RESET}"
    echo ""

    echo -e "${HEADER}🔧 DOCKER COMPOSE${RESET}"
    echo -e "  ${CMD}dc${RESET}              ${DESC}Docker compose${RESET}"
    echo -e "  ${CMD}dcu${RESET}             ${DESC}Compose up${RESET}"
    echo -e "  ${CMD}dcud${RESET}            ${DESC}Compose up detached${RESET}"
    echo -e "  ${CMD}dcd${RESET}             ${DESC}Compose down${RESET}"
    echo -e "  ${CMD}dcl${RESET}             ${DESC}Compose logs (follow)${RESET}"
    echo -e "  ${CMD}dcr${RESET}             ${DESC}Compose restart${RESET}"
    echo -e "  ${CMD}dce${RESET}             ${DESC}Compose exec${RESET}"
    echo ""

    echo -e "${HEADER}🧹 CLEANUP${RESET}"
    echo -e "  ${CMD}dprune${RESET}          ${DESC}Remove unused containers, networks, images${RESET}"
    echo -e "  ${CMD}dprune-volumes${RESET}  ${DESC}Remove everything including volumes${RESET}"
    echo -e "  ${CMD}dclean-containers${RESET} ${DESC}Remove all stopped containers${RESET}"
    echo -e "  ${CMD}dclean-images${RESET}   ${DESC}Remove all images${RESET}"
    echo ""

    echo -e "${HEADER}🎮 RUN${RESET}"
    echo -e "  ${CMD}dr${RESET}              ${DESC}Docker run${RESET}"
    echo -e "  ${CMD}drit${RESET}            ${DESC}Docker run interactive + remove on exit${RESET}"
    echo -e "  ${CMD}dgpu${RESET}            ${DESC}Docker run with GPU support${RESET}"
    echo ""

    echo -e "${HEADER}📊 OTHER${RESET}"
    echo -e "  ${CMD}dv${RESET}              ${DESC}List volumes${RESET}"
    echo -e "  ${CMD}dn${RESET}              ${DESC}List networks${RESET}"
    echo -e "  ${CMD}dins <id>${RESET}       ${DESC}Inspect container${RESET}"
    echo -e "  ${CMD}dinsp <id>${RESET}      ${DESC}Get container IP address${RESET}"
    echo ""

    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${DIM}💡 Tip: Most commands work with container ID or name${RESET}"
    echo -e "${DIM}💡 Tip: Use 'docker --help' for full documentation${RESET}"
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# Micro editor cheatsheet
micro-help() {
    local HEADER='\033[1;36m'
    local CMD='\033[1;32m'
    local DESC='\033[0;37m'
    local RESET='\033[0m'
    local DIM='\033[0;90m'
    local EXAMPLE='\033[0;33m'

    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${HEADER}                  MICRO EDITOR QUICK REFERENCE                     ${RESET}"
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""

    echo -e "${HEADER}🚀 GETTING STARTED${RESET}"
    echo -e "  ${CMD}micro file.txt${RESET}        ${DESC}Open or create file${RESET}"
    echo -e "  ${CMD}edit file.txt${RESET}         ${DESC}Same as above (alias)${RESET}"
    echo -e "  ${CMD}e file.txt${RESET}            ${DESC}Short alias${RESET}"
    echo ""

    echo -e "${HEADER}📝 BASIC EDITING${RESET}"
    echo -e "  ${CMD}Ctrl+S${RESET}               ${DESC}Save file${RESET}"
    echo -e "  ${CMD}Ctrl+Q${RESET}               ${DESC}Quit${RESET}"
    echo -e "  ${CMD}Ctrl+Z${RESET}               ${DESC}Undo${RESET}"
    echo -e "  ${CMD}Ctrl+Y${RESET}               ${DESC}Redo${RESET}"
    echo -e "  ${CMD}Ctrl+A${RESET}               ${DESC}Select all${RESET}"
    echo ""

    echo -e "${HEADER}✂️  COPY/PASTE${RESET}"
    echo -e "  ${CMD}Ctrl+C${RESET}               ${DESC}Copy${RESET}"
    echo -e "  ${CMD}Ctrl+X${RESET}               ${DESC}Cut${RESET}"
    echo -e "  ${CMD}Ctrl+V${RESET}               ${DESC}Paste${RESET}"
    echo -e "  ${CMD}Ctrl+K${RESET}               ${DESC}Cut line${RESET}"
    echo -e "  ${CMD}Ctrl+D${RESET}               ${DESC}Duplicate line${RESET}"
    echo ""

    echo -e "${HEADER}🔍 SEARCH & REPLACE${RESET}"
    echo -e "  ${CMD}Ctrl+F${RESET}               ${DESC}Find${RESET}"
    echo -e "  ${CMD}Ctrl+N${RESET}               ${DESC}Find next${RESET}"
    echo -e "  ${CMD}Ctrl+P${RESET}               ${DESC}Find previous${RESET}"
    echo -e "  ${CMD}Ctrl+H${RESET}               ${DESC}Find and replace${RESET}"
    echo ""

    echo -e "${HEADER}🖱️  MOUSE${RESET}"
    echo -e "  ${CMD}Click${RESET}                ${DESC}Place cursor${RESET}"
    echo -e "  ${CMD}Click + Drag${RESET}         ${DESC}Select text${RESET}"
    echo -e "  ${CMD}Double-click${RESET}         ${DESC}Select word${RESET}"
    echo -e "  ${CMD}Triple-click${RESET}         ${DESC}Select line${RESET}"
    echo -e "  ${CMD}Right-click${RESET}          ${DESC}Copy/paste menu${RESET}"
    echo -e "  ${CMD}Scroll wheel${RESET}         ${DESC}Scroll up/down${RESET}"
    echo ""

    echo -e "${HEADER}📋 NAVIGATION${RESET}"
    echo -e "  ${CMD}Ctrl+Home${RESET}            ${DESC}Go to start of file${RESET}"
    echo -e "  ${CMD}Ctrl+End${RESET}             ${DESC}Go to end of file${RESET}"
    echo -e "  ${CMD}Ctrl+Left/Right${RESET}      ${DESC}Jump by word${RESET}"
    echo -e "  ${CMD}Ctrl+G${RESET}               ${DESC}Go to line number${RESET}"
    echo ""

    echo -e "${HEADER}⚡ ADVANCED${RESET}"
    echo -e "  ${CMD}Ctrl+E${RESET}               ${DESC}Open command bar${RESET}"
    echo -e "  ${CMD}Ctrl+/${RESET}               ${DESC}Toggle line comment${RESET}"
    echo -e "  ${CMD}Tab${RESET}                  ${DESC}Indent${RESET}"
    echo -e "  ${CMD}Shift+Tab${RESET}            ${DESC}Unindent${RESET}"
    echo -e "  ${CMD}Ctrl+U${RESET}               ${DESC}Half page up${RESET}"
    echo -e "  ${CMD}Ctrl+D${RESET}               ${DESC}Half page down (also duplicates line)${RESET}"
    echo ""

    echo -e "${HEADER}🪟 SPLITS & TABS${RESET}"
    echo -e "  ${CMD}Ctrl+E → vsplit${RESET}      ${DESC}Split vertically${RESET}"
    echo -e "  ${CMD}Ctrl+E → hsplit${RESET}      ${DESC}Split horizontally${RESET}"
    echo -e "  ${CMD}Ctrl+W${RESET}               ${DESC}Switch between splits${RESET}"
    echo -e "  ${CMD}Ctrl+Q${RESET}               ${DESC}Close split${RESET}"
    echo ""

    echo -e "${HEADER}💡 USEFUL COMMANDS (Ctrl+E)${RESET}"
    echo -e "  ${EXAMPLE}Type after pressing Ctrl+E:${RESET}"
    echo -e "  ${CMD}help${RESET}                 ${DESC}Show help${RESET}"
    echo -e "  ${CMD}save${RESET}                 ${DESC}Save file${RESET}"
    echo -e "  ${CMD}quit${RESET}                 ${DESC}Quit${RESET}"
    echo -e "  ${CMD}set colorscheme${RESET}      ${DESC}Change theme${RESET}"
    echo -e "  ${CMD}plugin install${RESET}       ${DESC}Install plugins${RESET}"
    echo ""

    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${DIM}💡 Tip: Full mouse support! Just click and drag like a GUI editor${RESET}"
    echo -e "${DIM}💡 Tip: Standard keybindings work (Ctrl+C/V/S/F/Z/Y)${RESET}"
    echo -e "${DIM}💡 Tip: Press Ctrl+G for help menu anytime${RESET}"
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# Display all helper functions
helpers() {
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1;36m                    AVAILABLE HELPER FUNCTIONS                     \033[0m"
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    echo -e "\033[1;32malias-help\033[0m (or \033[1;32mah\033[0m)     Display all custom aliases"
    echo -e "\033[1;32mrg-help\033[0m                Ripgrep quick reference & examples"
    echo -e "\033[1;32mdocker-help\033[0m            Docker shortcuts reference"
    echo -e "\033[1;32mmicro-help\033[0m             Micro editor quick reference"
    echo -e "\033[1;32msysinfo\033[0m                Display system information"
    echo -e "\033[1;32mhelpers\033[0m                Display this help message"
    echo -e "\033[1;32mmkcd\033[0m <dir>            Create directory and cd into it"
    echo -e "\033[1;32mextract\033[0m <file>        Extract any archive format"
    echo -e "\033[1;32mv\033[0m [args]              Python with uv venv helper"
    echo -e "\033[1;32mrgreplace\033[0m <old> <new> Preview search and replace"
    echo ""
    echo -e "\033[0;90m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
}
