alias aest_epoch='TZ=UTC-10 date -r'
alias aliasgrep='alias|grep'
alias brc='source ~/.bashrc'
alias cest_epoch='TZ=UTC-2 date -r'
alias ctagsrefresh='sh -c "ctags -R --c++-kinds=+p --fields=+iaS --extra=+q . ; cscope -Rbq" &'
alias ecagt_build='cd build/cross/build-am33cd/agf/ec_agent'
alias edt_epoch='TZ=America/New_York date -r'
alias pdt_epoch='TZ=America/Los_Angeles date -r'
alias fgrep='grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias findcurr='fd -a --no-ignore-vcs -g'
alias gitbranchgrep='git branch -r | grep -i'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -alh'
alias ls='ls -G'
alias lsa='ls -lah'
alias makej='make -j32'
alias psgrep='ps -ef|grep'
alias rd=rmdir
alias rgrep='rg -a --no-ignore -i'
alias run-help=man
alias rvm-restart='rvm_reload_flag=1 source '\''/Users/rajuaddala/.rvm/scripts/rvm'\'
alias terminaltask='while [ 1 -ne 1 ]; do sleep 1; echo no match; done;echo Task completed ; alarm;'
alias tgrep='find . -type f -print0 | xargs -0 -P `sysctl -n hw.activecpu` grep --color=always'
alias unusual='grep -r -i "wrong\|error\|abort\|fail\|segmentation"'
alias which-command=whence
alias workspace='cd ~/workspace'
alias zrc='source ~/.zshrc'
alias zrgrep='rg -z -a --no-ignore -i'
alias aliasrefresh='source ~/terminalfiles/myaliases.sh'

########## setup alises

alias logsession='script -F $HOME/terminal/$(date +"%Y-%m-%d_%H-%M-%S")_${SHELL##*/}_session.log'



