#!/bin/bash
#

# merge options
echo "* merging"
remote="origin"
branch="develop"
current_branch="master"
# If there is a remote version of this branch, rebase onto current_branch first
# If there's a remote (public) branch, we do not want to be rewriting histories
tracking=$(git branch -vv | egrep "^\*" | awk '{ print $4 '})
# part 1 merging
# echo "tracking=$tracking"
# if [[ ! "$tracking" =~ "$remote" ]]; then
#   echo "* Local-only branch, rebasing $branch onto $current_branch first..."
#   git checkout $branch
#   git rebase $current_branch || return 1
# else
#   echo "* This branch exists remotely, not rebasing"
# fi

# echo "* Merge $branch into $current_branch"
# git checkout $current_branch
# git merge $branch --no-edit || return 1

# echo "* erging Done"

echo "* Done"
# part 2 gulp
echo "* gulp starting"
gulp
echo "* merging"
# part 3 push

# Colors
color_error="$(tput sgr 0 1)$(tput setaf 1)"
color_reset="$(tput sgr0)"

# TODO DRY this b/w pull and push
branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/') || return $?
default_remote="origin"
remote=$(git config "branch.${branch}.remote" || echo "$default_remote")
remote_branch=$( (git config "branch.${branch}.merge" || echo "refs/heads/$branch") | cut -d/ -f3- )

# Push & save output
push=$(git push --set-upstream $* $remote $remote_branch 2>&1)
exit_code=$?

if [ $exit_code != 0 ]; then
  echo -e "${color_error}Ouch, push failed!${color_reset} code=$exit_code, output=$push"
  return $exit_code
elif echo $push | grep "Everything up-to-date" >/dev/null; then
  echo "git says everything is up-to-date!"
  return
fi

# Parse relevant commit refs and let user know what we did
# 1st-time push to new branch gets special treatment
if echo $push | grep "\[new branch\]" >/dev/null; then
  refs="master...$branch"
  echo "Pushed new branch '$branch' remotely"
else
  refs=$(echo $push | awk '{ print $3}' | sed 's/\.\./\.\.\./')
  echo $push
fi

# Parse output into a sexy GitHub compare URL!
remote_url=$(git remote show $remote -n | grep Push | awk '{ print $3 }')

if [[ "$remote_url" =~ "github.com" ]]; then

  if [[ ${remote_url:0:4} == "git@" ]]; then
    regEx='s/.*\:\(.*\)\.git/\1/'
    url='https://github.com/'
  else
    regEx='s/\(.*\)\.git/\1/'
  fi

  repo_name=$(echo $remote_url | sed $regEx)
  github_url="$url$repo_name/compare/$refs"

  copied="Compare URL copied to clipboard!"
  which pbcopy >& /dev/null && echo $github_url | pbcopy && echo $copied
  which xclip >& /dev/null && echo $github_url | xclip -selection clipboard && echo $copied

  echo $github_url
  echo
fi
return