#!/bin/bash
set -e

export GOOGLE_APPLICATION_CREDENTIALS='{{ restic_gcp_creds_path }}'
export RESTIC_PASSWORD='{{ restic_password }}'
export RESTIC_REPO='{{ restic_gcp_storage_path }}'

exec restic -r "$RESTIC_REPO" "$@"
