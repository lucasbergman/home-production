#!/bin/sh
set -e

# The key we output has to begin with STABLE_ to force all stamped builds to
# be re-run when the value changes. See also stackoverflow.com/a/47630130.
echo                                                                \
  STABLE_BUILD_SCM_HEAD                                             \
  $(TZ=etc/UTC                                                      \
      git show -s --format=%cd-%h --date='format:%Y%m%dT%H%M' HEAD)
