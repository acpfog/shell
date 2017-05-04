# ssh-agent stores a path to his socket in SSH_AUTH_SOCK variable
# SSH_AUTH_SOCK in a session in screen should be updated with a new path after each reattachment
# You can add fixssh() funtion in your .bash_profile and just run fixssh for SSH_AUTH_SOCK update
#
fixssh() {
    export SSH_AUTH_SOCK=$(find /tmp -maxdepth 2 -type s -name "agent*" -user $USER -printf '%T@ %p\n' 2>/dev/null |sort -n|tail -1|cut -d' ' -f2)
}
