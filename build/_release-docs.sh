#!/bin/bash

set -e

RELEASE_REPO="git@github.com:ondat/ondat.github.io.git"

function usage {
    echo -e "Usage:\t $0 -m \"Commit message\""
    echo -e "  -d \t Dry run."
    echo -e "  -m \t Message of the commit for the release."
    echo -e "  -r \t Production repository that hosts the docs."
    echo -e "  -s \t Source directory where the site output is compiled"
    echo -e "  -h \t Display this help message."
}

function pull_repo {
    local repo="$1"
    local repo_dir="$2"

    if [ -d "$repo_dir" ]; then
        cd "$repo_dir"
        git pull origin master
        cd -
    else
        git clone $repo $repo_dir
    fi
}

function commit_changes {
    local repo_dir="$1"

    cd $repo_dir
    git add .
    git commit -m "$MSG"
    cd -
}

function push_changes {
    local repo_dir="$1"

    cd $repo_dir
    git push origin master
    cd -
}

while getopts ":hdm:r:s:" opt; do
  case ${opt} in
    h )
      usage
      exit 0
      ;;
    d )
      DRYRUN=1
      ;;
    m )
      MSG="$OPTARG"
      ;;
    r )
      REPOSITORY="$OPTARG"
      ;;
    s )
      SOURCE_DIR=$OPTARG
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
    echo "Commit message missing"
    help
    exit 1
fi

## Main
if [ -z "$SOURCE_DIR" ]; then
    SOURCE_DIR="../sites/stable/public"
fi

if [ -z "$REPOSITORY" ]; then
    REPOSITORY="$RELEASE_REPO"
fi

# Set stdout colors
GR='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

pushd . &> /dev/null
cd "$(dirname $0)"

# Repo dir: /tmp/repository_name, where $REPOSITORY is the URL
repo_dir="/tmp/$(echo $REPOSITORY | rev | cut -d'/' -f1 | rev)"
pull_repo $REPOSITORY $repo_dir

echo -e "${GR}Syncing docs to the git repository ${NC}"
rsync -az "$SOURCE_DIR/" "$repo_dir/"

echo -e "${GR}Commiting changes ${NC}"
commit_changes $repo_dir

if [ ! -z $DRYRUN ]; then
    echo -e "${RED}Dry run enabled "
    echo -e "  No git push to be executed"
    echo -e "  Output can be found in $repo_dir ${NC}"
    echo -e "${GR}  You can run the final step:\n    (cd $repo_dir && git push origin master)${NC}"
    popd &> /dev/null
    exit 0
fi

echo -e "${GR}Pushing changes to the remote repository ${NC}"
push_changes $repo_dir

popd &> /dev/null
