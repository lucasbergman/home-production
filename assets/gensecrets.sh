#!/bin/bash

set -e

dir=$(dirname "$0")
cd "$dir"

if [[ -z "$BW_SESSION" ]]; then
    echo "fatal: no BitWarden session found; do" >&2
    echo '  export BW_SESSION=$(bw unlock --raw)' >&2
    exit 44
fi

var_LINODE_TOKEN=$(bw get item d7a7c841-604a-44df-bac4-ace500f56349 | \
                       jq -r '.fields[] | select(.name == "token") | .value')

outfile=$(mktemp --tmpdir=.)
trap "rm --force -- '$outfile'" EXIT

terraform fmt - <<EOF >"$outfile"
linode_token = "$var_LINODE_TOKEN"
EOF

if ! cmp --quiet "$outfile" private.auto.tfvars; then
    mv "$outfile" private.auto.tfvars
fi
