function grails_chpwd() {
  if [[ $CURRENT_GRAILS_PATH == "" ]]; then
    CURRENT_GRAILS_PATH=$DEFAULT_GRAILS_PATH
  fi
  dir=$(pwd)
  while [ "${dir}" != "" ]; do
    cfg="${dir}/.grailsinfo"
    if [ -f ${cfg} ]; then
      new_grails_path="${dir}/$(cat ${cfg})"
      set_grails $new_grails_path
      break
    else
      dir=${dir%/*}
    fi
  done
  if [ ! -f ${cfg} ]; then
    set_grails $DEFAULT_GRAILS_PATH
  fi
}
function set_grails() {
  if [[ $CURRENT_GRAILS_PATH != $1 && $CURRENT_GRAILS_PATH != "" ]]; then
    CURRENT_GRAILS_PATH=$1
    GRAILS_HOME=$1
    if [[ $PATH_OLD != "" && $PATH_OLD != $PATH ]]; then
      PATH=$PATH_OLD
    fi
    PATH_OLD=$PATH
    PATH=$CURRENT_GRAILS_PATH/bin:$PATH
    [[ "$CURRENT_GRAILS_PATH" -regex-match "/([a-zA-Z0-9.-]+)$" ]]
    CURRENT_GRAILS_VERSION=$match
    echo "$fg_bold[green]Now using Grails $CURRENT_GRAILS_VERSION$reset_color"
  fi
}

function local_zsh_config() {
  if [[ -r $PWD/.zsh_config && "$PWD" == $PROJECTS* ]]; then
    echo "Executing local zsh config..."
    source $PWD/.zsh_config
  fi
}

chpwd_functions=( ${chpwd_functions[@]} grails_chpwd )
