#!/usr/bin/env bash
clear

PROJECT_ID=$(yq '.project.name' .yade/yade.yml)

export YADE_PROJECT_ID=$PROJECT_ID
export YADE_PROJECT_HOME=${HOME}/projects/${YADE_PROJECT_ID}-yade
export YADE_PROJECT_SCRIPTS=${YADE_PROJECT_HOME}/scripts
export YADE_PROJECT_CONF=${YADE_PROJECT_HOME}/conf
export YADE_PROJECT_SRC=${YADE_PROJECT_HOME}/src
export YADE_PROJECT_DOC=${YADE_PROJECT_HOME}/doc
export YADE_PROJECT_SOFTWARE=${YADE_PROJECT_HOME}/software

cat ${YADE_PROJECT_HOME}/.yade/ascii-art.txt

echo ""

files=$(find "$YADE_PROJECT_HOME" -name ".env*" -type f)
if [[ -n "$files" ]]; then
  echo "Sourcing local env files:"
  for file in $files; do
    echo " |-> $file..."
    source $file
  done
fi

files=$(find "$YADE_PROJECT_SOFTWARE" -name "set-env-*.sh" -type f)
if [[ -n "$files" ]]; then
  echo "Sourcing software set-env files:"
  for file in $files; do
    echo " |-> $file..."
    source $file
  done
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  test -f ${YADE_PROJECT_HOME}/set-env-linux.sh && source ${YADE_PROJECT_HOME}/set-env-linux.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  test -f ${YADE_PROJECT_HOME}/set-env-darwin.sh && source ${YADE_PROJECT_HOME}/set-env-darwin.sh
fi

export PATH="${YADE_PROJECT_HOME}/bin:${YADE_PROJECT_HOME}/scripts:${HOME}/.local/bin:${PATH}"
