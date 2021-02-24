goWorkspace() {
  if workspaceExits $1 &>/dev/null; then

    local wrkPath=`workspaceExits $1 2>/dev/null`

    if [ ! -z "$2" ] && [ -d "$wrkPath/$2" ]; then
      wrkPath="$wrkPath/$2"
    elif [ -d "$wrkPath/core" ]; then
      wrkPath="$wrkPath/core"
      local listFiles=(`ls $wrkPath`)
      if [ ${#listFiles[@]} = 1 ]; then
        wrkPath="$wrkPath/${listFiles[0]}"
      fi
    fi



    echo "cd $wrkPath"

    return 0
  else
    return 1
  fi
}
