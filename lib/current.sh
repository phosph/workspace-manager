currentName() {
  wrkPath=`realpath $WORKSPACE_PATH`
  list=(`realpath --relative-to="$wrkPath" . | sed 's/\// /g'`)
  name=${list[0]}
  if [ "$name" = '.' ]; then
    echo _base_
  elif [ "$name" = '..' ]; then
    echo
    return 1
  else
    list=`$WORKSPACE_DIR/lib/list.sh $WORKSPACE_PATH 2>/dev/null`
    if [[ $list =~ (^|[[:space:]])"$name"($|[[:space:]]) ]]; then
      echo $name
      return 0
    else
      return 1
    fi
  fi

}

currentIn() {
  wrkPath=`realpath $WORKSPACE_PATH`
  list=(` realpath --relative-to="$wrkPath" . | sed 's/\// /g'`)
  name=${list[0]}

  if [ "$name" = '.' ] || [ "$name" = '..' ]; then
    return 1
  else
    list=`$WORKSPACE_DIR/lib/list.sh $WORKSPACE_PATH 2>/dev/null`
    if [[ $list =~ (^|[[:space:]])"$name"($|[[:space:]]) ]]; then
      realpath --relative-to="$wrkPath/$name" `pwd`
      return 0
    else
      return 1
    fi
  fi
}

current() {
  case $1 in
    --inner) currentIn ;;
    *) currentName ;;
  esac

  return $?
}
