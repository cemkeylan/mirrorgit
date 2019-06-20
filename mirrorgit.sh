#!/bin/sh

## mirrorgit.sh, a simple shell script to mirror repositories
## Copyright (C) 2019 Cem Keylan <cem@ckyln.com>

##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 3 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program.  If not, see <https://www.gnu.org/licenses/>.

initialize() {\
	clear
	printf "███╗   ███╗██╗██████╗ ██████╗  ██████╗ ██████╗  ██████╗ ██╗████████╗ \n████╗ ████║██║██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔════╝ ██║╚══██╔══╝ \n██╔████╔██║██║██████╔╝██████╔╝██║   ██║██████╔╝██║  ███╗██║   ██║ \n██║╚██╔╝██║██║██╔══██╗██╔══██╗██║   ██║██╔══██╗██║   ██║██║   ██║ \n██║ ╚═╝ ██║██║██║  ██║██║  ██║╚██████╔╝██║  ██║╚██████╔╝██║   ██║ \n╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝   ╚═╝ \n"
	printf "\nHello, I see you don't have a configuration file on $HOME/.mirrorgitrc\n\nLet's set it up!\nYou need to enter your git username first\nUsername: "
	read username
	printf "Now, add the domain you will be mirroring from (eg. "https://git.example.com")\nURL: "
	read fromhost
	printf "You should now add the domain you will be mirroring to.\nIMPORTANT: You must have your ssh keys deployed on this git repository\nDo you understand? (y/n) "
	read answer
	case $answer in
		y*)
			printf "Mirror Host should not contain http (eg. \"github.com\")\nEnter host name: "
			read tohost
			printf "\
USERNAME=\"$username\"\n\n\
## Add only the host name\n\
FROMHOST=\"$fromhost\"\n\
## Mirrorhost should not contain https or http (eg. \"github.com\")\n\
MIRRORHOST=\"$tohost\"\n" > $HOME/.mirrorgitrc
			;;
		*)
				printf "Did you read the prompt carefully?\n" && exit 1
			;;
		esac			
	printf "Repos you will be mirroring (leave spaces between repos)\nRepos: "
	read repos
	printf "REPONAMES=\"${repos}\"\n" >> $HOME/.mirrorgitrc
}

[ -f $HOME/.mirrorgitrc ] || initialize
source $HOME/.mirrorgitrc

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

printf "\nDone\n"
cd $ORIGFOLD
