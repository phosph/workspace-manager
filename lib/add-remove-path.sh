#!/usr/bin/env bash

setWorkspaceScripts() {
  case $1 in
    add)
      local wrkPath
      local wrkPathParsed

      wrkPath=`workspace-exits $2 2>/dev/null`
      wrkPathParsed=`realpath $wrkPath`

      if [ -d "${wrkPathParsed}/scripts" ]; then
        echo "export ${PATH}:${wrkPathParsed}/scripts"
        return 0
      else
        return 1
      fi
    ;;
    remove)
      local wrkPath
      local wrkPathParsed
      local newPATH

      wrkPath="`workspace-exits $2 2>/dev/null`/scripts"
      wrkPathParsed=`realpath $wrkPath`
      newPATH=`echo ":${PATH}:" | sed -e "s|:${wrkPathParsed}:|:|g" -e 's|^:||' -e 's|:$||'`

      echo "export $newPATH"
      return 0
    ;;
    *) return 1 ;;
  esac

}
