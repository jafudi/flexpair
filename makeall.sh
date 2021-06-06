#!/usr/bin/env bash

./environments/makedirs.sh

brew install pre-commit gawk terraform-docs tflint coreutils

DIR=~/.git-template
git config --global init.templateDir ${DIR}
pre-commit init-templatedir -t pre-commit ${DIR}

pre-commit run -a
