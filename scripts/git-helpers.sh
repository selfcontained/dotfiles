#!/bin/bash

function git-search-replace {
	for i in `git grep -il $1`
	do
		echo $i;
		sed -i "s/$1/$2/g" $i
	done
}

function git-pick() {
        R=$1
        TO=$2
        cd ~/git
        if [ "$TO" ]; then
                git co $TO;
        fi
        ORIGINAL=`git log -1 $R --pretty=format:'%B' | sed 'N;$!P;$!D;$d'`
        GITOUTPUT=`git log -1 $R | tail -n1`; GITOUTPUT=${GITOUTPUT##*/};
        MESSAGE="cherry-pick of ${GITOUTPUT%% *}"
        git cherry-pick $R --no-commit
        git ci -m"$MESSAGE - $ORIGINAL"
}
