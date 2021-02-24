if [[ $WORKSPACE_PATH == '' ]]; then
  echo "\$WORKSPACE_PATH is not set"
  exit 1
fi
workspace $@
