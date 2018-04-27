#!/usr/bin/env bash

########################################################################
# Source Protection
########################################################################

if [[ -n "${BASH_SOURCE+1}" ]] && [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "This script should not be sourced!"
  return 1
fi

########################################################################
# Main
########################################################################

# ADD ALL MAIN FUNCTIONALITY HERE
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function __main() {
  echo "Script launched at the following location:"
  echo "  File: ${__file:-}"
  echo "  Dir : ${__dir:-}"
  if (( "${__is_windows}" )); then
    echo Running on: $(
      # example of how to call complicated Windows command
      cmd.exe /C "for /F \"tokens=2 delims==\" %a in ('wmic.exe os get Caption /value \
        ^| findstr.exe .') do @echo.%a"
    )
  else
    echo "Not running on Windows."
  fi

} # <<<<< end __main

########################################################################
# Error Handler
########################################################################

# ADD ALL ERROR HANDLING HERE
# >>>>>>>>>>>>>>>>>>>>>>>>>>>
function __on_error() {

  echo "Script Failed!" >&2

} # <<<<< end __on_error

########################################################################
# Strict Mode
########################################################################
set -o nounset
set -o errexit
set -o errtrace
set -o pipefail

__default_ifs="${IFS}"
__safer_ifs=$'\n\t'
IFS="${__safer_ifs}"

########################################################################
# Teardown
########################################################################

# Exit with error.
function __exit_error() {
  exit 1
}

# Error handler wrapper.
function __error_trap() {
  __on_error
  __exit_error
}

# Set error handling function.
trap __error_trap INT TERM EXIT

# Exit without error.
function __exit_success() {
  trap - INT TERM EXIT
  exit
}

########################################################################
# Globals
########################################################################

# script location info; not set if cannot be determined, e.g from`cat script.sh | bash`
if [[ -n "${BASH_SOURCE+1}" ]]; then
  __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  __file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
fi

# Windows detection
if grep -E 'Microsoft|MINGW' /proc/version >/dev/null 2>&1; then
  __is_windows=1
else
  __is_windows=0
fi

########################################################################
# Run
########################################################################

__main "${@}"
__exit_success
