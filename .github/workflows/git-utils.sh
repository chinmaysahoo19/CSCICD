#!/bin/bash
set -ex

function configure_pk() {
  ls  -altr
  echo "$GIT_SSH_PK" | base64 -d >~/id_rsa &&
  mkdir -p ~/.ssh && cp ~/id_rsa known_hosts ~/.ssh/ && chmod -R 700 ~/.ssh && chmod -R 400 ~/.ssh/*
}

function git_configure() {
  configure_pk
  #git config --global --add safe.directory "${master_PROJECT_DIR}" &&
    git config --global user.name "$GITHUB_ACTOR"
    #git config --global user.email "$GITLAB_USER_EMAIL" &&
    #git remote set-url origin git@"$master_SERVER_HOST":"$master_PROJECT_PATH".git
}


function validate_version() {
  env
  pwd
  git pull
  ls -altr
  git remote -v
  git branch
  git tag
  git describe --abbrev=0 --tags
  GIT_TAG=$(git describe --abbrev=0 --tags)
  PACKAGE_VERSION=v$(jq -r '.version' package.json)
  if [[ "${GIT_TAG}" != "${PACKAGE_VERSION}" ]]; then
    echo -e "\e[31mVersion does not match latest tag. Please change version in version.json to '${GIT_VERSION}'\e[39m"
    exit 1
  fi
}

function version-push() {
  env
  git checkout master
  git reset --hard origin/master
  BASE_DIR=$PWD
  yarn version --"$INCREMENT_TYPE" --no-git-tag-version --no-commit-hooks
  version=$(jq -r '.version' package.json)
  cd $BASE_DIR
  #echo "version=$version" > version.sh
  git add package.json
  git commit -m "$BUMP_VERSION_MESSAGE $version"
  git tag -d v$version || true
  git remote -v
  git config --list
  git tag v$version
  git push origin v$version
  git push origin master
}
function clone_gitlab_repo() {
    configure_pk
    rm -rf /tmp/lib && mkdir /tmp/lib
    git clone git@gitlab.com:samnasbo/gamehub/gitlab.git /tmp/lib
    cd /tmp/lib
    git checkout "${BRANCH_NAME}"
    git pull origin "${BRANCH_NAME}"
    cd -
}

case $1 in
configure_pk)
  configure_pk
  ;;
version-push)
  git_configure && validate_version && version-push
  ;;
validate_version)
  validate_version
  ;;
git_configure)
  git_configure
  ;;
clone_gitlab_repo)
  clone_gitlab_repo
  ;;
*)
  echo "Invalid Parameter"
  ;;
esac
