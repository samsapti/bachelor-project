#!/usr/bin/env sh

BASE_CMD="ansible-playbook playbook.yml -i inventory --ask-vault-pass"

if [ -z "$(ansible-galaxy collection list community.general 2>/dev/null)" ]; then
    ansible-galaxy collection install community.general
fi

case $1 in
    root)
        $BASE_CMD -u root ;;
    user)
        $BASE_CMD --ask-become-pass -u mpc-player ;;
    *)
        exit 1 ;;
esac
