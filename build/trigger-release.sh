#!/bin/bash

set -e

URL="https://docs.ondat.io"
DEST_DIR="/tmp/docs-output"
ROOT_VERSION="v2.5" # Version that is served from the / of the website

function usage {
    echo -e "Usage:\t $0 [-u URL -r v2.4] -m \"Commit message for the release\""
    echo -e "  -m \t Message of the commit for the release."
    echo -e "  -r \t Root version that is served from the / of the website."
    echo -e "  -u \t Url of the site."
    echo -e "  -h \t Display this help message."
}

function generate_dest_dir {
    local dir="$1"
    if [ -d "$dir" ]; then
        rm -rf "$dir/*"
    else
        mkdir -p "$dir"
    fi
}

while getopts ":hm:u:r:" opt; do
  case ${opt} in
    h )
      usage
      exit 0
      ;;
    m )
      MSG=$OPTARG
      ;;
    r )
      ROOT_VERSION=$OPTARG
      ;;
    u )
      URL=$OPTARG
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z "$MSG" ]; then
    echo "Commit message not set"
    usage
    exit 1
fi

## Main
pushd . &> /dev/null
cd "$(dirname $0)"

generate_dest_dir $DEST_DIR

./_generate-site-output.sh -d $DEST_DIR -u $URL -r $ROOT_VERSION

GR='\033[0;32m'
NC='\033[0m' # No Color
echo -e "${GR}Docs generated successfully ${NC}"

./_release-docs.sh -d -s $DEST_DIR -m "$MSG"
