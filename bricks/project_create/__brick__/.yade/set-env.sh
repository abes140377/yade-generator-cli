#!/usr/bin/env bash
clear

export YADE_PROJECT_ID={{projectName.lowerCase()}}
export YADE_PROJECT_HOME=${HOME}/projects/${YADE_PROJECT_ID}-yade
export YADE_PROJECT_CONF=${YADE_PROJECT_HOME}/conf
export YADE_PROJECT_SRC=${YADE_PROJECT_HOME}/src
export YADE_PROJECT_DOC=${YADE_PROJECT_HOME}/doc
export YADE_PROJECT_SOFTWARE=${YADE_PROJECT_HOME}/software

cat ${YADE_PROJECT_HOME}/.yade/ascii-art.txt

# Aktiviert die nullglob-Option
shopt -s nullglob

echo ""
echo "Sourcing local env files:"
if compgen -G "${YADE_PROJECT_HOME}/.env*" > /dev/null; then
  for f in ${YADE_PROJECT_HOME}/.env* ; do
    echo " |-> $f..."
    . $f
  done
else
  echo "No .env* files found."
fi

if [ -d "$YADE_PROJECT_SOFTWARE" ]; then
  echo "Sourcing software set-env files:"
  for f in ${YADE_PROJECT_SOFTWARE}/set-env-*.sh ; do
    echo " |-> $f..."
    . $f
  done
fi

# echo "Sourcing set-env-* files:"
# for f in ${YADE_PROJECT_HOME}/set-env-*.sh ; do
#   echo " |-> $f..."
#   . $f
# done

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  test -f ${YADE_PROJECT_HOME}/set-env-linux.sh && source ${YADE_PROJECT_HOME}/set-env-linux.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  test -f ${YADE_PROJECT_HOME}/set-env-darwin.sh && source ${YADE_PROJECT_HOME}/set-env-darwin.sh
fi

export PATH="${YADE_PROJECT_HOME}/bin:${HOME}/.local/bin:${PATH}"
