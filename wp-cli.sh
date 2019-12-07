#!/bin/bash

if [[ -n "$1" ]]; then
  # oneshot, just run a command
  docker-compose exec -T -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -u www-data wordpress wp "$@"
else
  # interactive shell
  docker-compose exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -u www-data wordpress bash
fi

