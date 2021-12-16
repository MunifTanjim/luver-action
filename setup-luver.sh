#!/usr/bin/env bash

set -eo pipefail

export LUVER_DIR="${HOME}/.local/share/luver"
mkdir -p "${LUVER_DIR}"

if [[ -d "${LUVER_DIR}/self" ]]; then
  git -C "${LUVER_DIR}/self" pull --rebase --autostash
else
  git clone https://github.com/MunifTanjim/luver.git "${LUVER_DIR}/self"
fi

source "${LUVER_DIR}/self/luver.bash"

for env_variable in $(env | grep LUVER_); do
  echo "${env_variable}" >> ${GITHUB_ENV}
done

echo "${PATH}" | tr ':' '\n' | grep "${LUVER_SRC}" >> ${GITHUB_PATH}
echo "${PATH}" | tr ':' '\n' | grep "${LUVER_CURRENT_SRC}" >> ${GITHUB_PATH}

if test -n "${INPUT_LUA_VERSIONS}" ; then
  declare installed_lua_versions=" $(luver list lua | cut -d' ' -f1 | xargs) "
  for lua_version in ${INPUT_LUA_VERSIONS}; do
    if echo "${installed_lua_versions}" | grep " ${lua_version} "; then
      continue
    fi

    luver install lua "${lua_version}"
  done
fi

if test -n "${INPUT_LUAJIT_VERSIONS}" ; then
  for item in ${INPUT_LUAJIT_VERSIONS}; do
    declare lua_version="${item%:*}"
    declare luajit_version="${item#*:}"

    luver use "${lua_version}"

    declare current_luajit_version="$(luver current luajit)"
    if test -n "${current_luajit_version}"; then
      if test "${current_luajit_version}" == "${luajit_version}"; then
        continue
      fi

      luver uninstall luajit
    fi

    luver install luajit "${luajit_version}"
  done
fi

if test -n "${INPUT_LUAROCKS_VERSIONS}" ; then
  for item in ${INPUT_LUAROCKS_VERSIONS}; do
    declare lua_version="${item%:*}"
    declare luarocks_version="${item#*:}"

    luver use "${lua_version}"

    declare current_luarocks_version="$(luver current luarocks)"
    if test -n "${current_luarocks_version}"; then
      if test "${current_luarocks_version}" == "${luarocks_version}"; then
        continue
      fi

      luver uninstall luarocks
    fi

    luver install luarocks "${luarocks_version}"
  done
fi

if test -n "${INPUT_DEFAULT}" ; then
  luver alias "${INPUT_DEFAULT}" default
fi
