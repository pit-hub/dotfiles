#!/usr/bin/env bash

set -e

# Setup git user.name & user.email
GH_USER_INFO=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user)
GH_USER_ID=$(echo "${GH_USER_INFO}" | jq -r .id)
GH_USER=$(echo "${GH_USER_INFO}" | jq -r .login)
GH_PRIVATE_EMAIL="${GH_USER_ID}+${GH_USER}@users.noreply.github.com"
echo "Git User:  $GH_USER, User Email: $GH_PRIVATE_EMAIL"

GIT_CONFIG_SCOPE=--global
if [[ "`git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null && echo 0 || echo 1`" == 0 ]]
  then
    unset GIT_CONFIG_SCOPE
  fi

git config $GIT_CONFIG_SCOPE user.name "$GH_USER"
git config $GIT_CONFIG_SCOPE user.email "$GH_PRIVATE_EMAIL"
