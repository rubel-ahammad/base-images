#!/usr/bin/env bash

pro_attach_config_log_file() {
  if [[ ! -d "${DIR}/.local/log" ]]; then
    mkdir -p "${DIR}/.local/log"
  fi
  echo "${DIR}/.local/log/pro-attach-config.log"
}

setup_pro_attach_config() {
  attach_config_dir="${HOME}/.local"
  attach_config_file="${attach_config_dir}/pro-attach-config.yaml"
  attach_config_template="${DIR}/files/pro-attach-config.yaml"

  mkdir -p "${attach_config_dir}"
  cp "${attach_config_template}" "${attach_config_file}"
  sed -i '' -e "s/PRO_TOKEN/${1}/g" "${attach_config_file}"
}
