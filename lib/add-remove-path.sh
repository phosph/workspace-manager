setWorkspaceScripts() {
  case $1 in
    add)
      local wrkPath=`workspaceExits $2 2>/dev/null`
      local wrkPathParsed=`realpath $wrkPath`
      if [ -d "${wrkPathParsed}/scripts" ]; then
        echo "export ${PATH}:${wrkPathParsed}/scripts"
        return 0
      else
        return 1
      fi
    ;;
    remove)
      local wrkPath="`workspaceExits $2 2>/dev/null`/scripts"
      local wrkPathParsed=`realpath $wrkPath`
      local newPATH=`echo ":${PATH}:" | sed -e "s|:${wrkPathParsed}:|:|g" -e 's|^:||' -e 's|:$||'`
      echo "export $newPATH"
      return 0
    ;;
    *) return 1 ;;
  esac

}
