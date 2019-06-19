#!/bin/sh
# Cem Keylan (2019)

##### IMPORTANT ######
## You must have an ssh key on the mirror repository in order to be able
## to push your mirrors
SSH="NO"
## After you are sure you have ssh keys on the repo, remove or 
## comment this line
######################

case $SSH in
	NO) printf "Please configure the script and read the comments\n" && exit 1 ;;
esac

USERNAME=""

## Add only the host name (eg. "https://github.com" )
FROMHOST=""
## Mirrorhost should not contain https or http (eg. "github.com")
MIRRORHOST=""

## Add the names of your repositories 
## with only a space (eg. "repo1 repo2 repo3")
REPONAMES=""

[ -z $USERNAME ] && printf "You must add your username to the script before you can use it\n" && exit 1
[ -z $FROMHOST ] && printf "You must add your own git repo address beforeyou can use the script\n" && exit 1
[ -z $MIRRORHOST ] && printf "You must add the git repo address you will be mirroring to before you can use this script\n" && exit 1
[ -z "$REPONAMES" ] && printf "You must add repositories before you can use this script\n" && exit 1

case $MIRRORHOST in
	https://*) MIRRORHOST=$(echo $MIRRORHOST | cut -c 9-) ;;
	http://*) MIRRORHOST=$(echo $MIRRORHOST | cut -c 8-) ;;
esac

ORIGFOLD=$PWD
TEMPFOLD=$(mktemp -d /tmp/gitmirror-XXXXXX)

cd $TEMPFOLD
for i in $REPONAMES
do
	git clone --mirror $FROMHOST/$USERNAME/$i || exit 1
	cd "$i".git
	git push --mirror git@$MIRRORHOST:$USERNAME/$i || exit 1
	cd $TEMPFOLD 
done

printf "Done\n"
cd $ORIGFOLD
