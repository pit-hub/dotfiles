#!/usr/bin/env bash

find ./ -type f -executable -name "*.sh" -exec git add --chmod=+x -- '{}' \;
