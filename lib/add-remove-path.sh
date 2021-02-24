workspace_path=$2
workspace=$3

add() {
  wrkPath="`realpath $workspace_path`/workspace"
  if [ -d "${wrkPath}/script" ]; then
    echo "${PATH}:${wrkPath}/script"
    return 0
  else
    return 1
  fi
}
remove() {
  wrkPath="`realpath $workspace_path`/workspace"
  echo ":${PATH}:" | sed -e "s|:${wrkPath}:|:|g" -e 's|^:||' -e 's|:$||'
  return 0
}

case $1 in
  add) add ;;
  remove) remove ;;
  *) exit 1
esac

exit $?
