#!/bin/bash

set -e

function usage {
    echo -e "Usage:\t $0"
    echo -e "  -d \t Web output directory."
    echo -e "  -r \t Root version, version that is served from the / of the website."
    echo -e "  -u \t URL to use for the release."
    echo -e "  -h \t Display this help message."
}

function hugo_build {
    local conf="$1"
    local url="$2"
    local dst="$3"

    #hugo_opts="--debug --verbose --config $conf"
    hugo_opts=" --config $conf"
    if [ ! -z "$url" ]; then
        echo -e "${GR}Using base url: $url ${NC}"
        hugo_opts="$hugo_opts --baseURL $url"
    fi

    if [ ! -z "$dst" ]; then
        echo -e "${GR}Output destination: $dst ${NC}"
        hugo_opts="$hugo_opts --destination $dst"
    fi

    echo -e "${GR}Building site from $conf file ${NC}"

    hugo $hugo_opts
}

while getopts ":hd:r:u:" opt; do
  case ${opt} in
    h )
      usage
      exit 0
      ;;
    c )
      CONF_FILE=$OPTARG
      ;;
    d )
      DESTINATION=$OPTARG
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

## Main

if [ -z $URL ]; then
    URL="http://localhost"
fi

# Set the stdout color
GR='\033[0;32m'
NC='\033[0m' # No Color

# run from the root of the repo
pushd . &> /dev/null
cd "$(dirname $0)/.."

for file in $(find ./config -type f -name 'v*.toml' -o -name "v*.yaml" | sort); do
   version=$(echo $file | sed 's:^.*config/::; s:.toml::')
   url="$URL"
   dst="$DESTINATION"
   if [ "$ROOT_VERSION" != "$version" ]; then
       url="$URL/$version"
       if [ ! -z "$dst" ]; then
           dst="$DESTINATION/$version"
       fi
   fi
   HUGO_ENV=production hugo_build "$file" "$url" "$dst"
done

popd &> /dev/null
