#!/usr/bin/env bash

set -e

mkdir "$HOME/.wrk-config"
touch "$HOME/.wrk-config/env"

echo 'source "$HOME/.wrk-config/env"' >> "$HOME/.bashrc"


cat > "$HOME/.wrk-config/env" << EFO
#!/usr/bin/env bash

# shellcheck disable=SC1090
source <(workspace.sh init)

EOF
