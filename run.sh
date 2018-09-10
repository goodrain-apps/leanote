#!/bin/sh
SCRIPTPATH=$(cd "$(dirname "$0")"; pwd)


# update secret key
hash=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-64};echo;)
sed -i "s/app.secret=.*$/app.secret=$hash #/" /usr/local/leanote/conf/app.conf

# set link
path="$SCRIPTPATH/src/github.com/leanote"
if [ ! -d "$path" ]; then
	mkdir -p "$path"
fi
rm -rf $SCRIPTPATH/src/github.com/leanote/leanote # 先删除
ln -s ../../../../ $SCRIPTPATH/src/github.com/leanote/leanote

[ -f "/usr/local/leanote/init/init_ok" ] || (
	for ((i=1;i<=60;i++ )); do
    sleep 3
	
    curl 127.0.0.1:27017 >/deb/null 2>&1
	[ "$?" -eq 0 ] && (
		mongorestore -h 127.0.0.1 -d leanote --dir /usr/local/leanote/mongodb_backup/leanote_install_data
		if [ "$?" -eq 0 ];then
		echo "ok" > /usr/local/leanote/init/init_ok
		else
			exit 1
		fi
	) && break
  	done
)

# set GOPATH
export GOPATH=$SCRIPTPATH
script="$SCRIPTPATH/leanote-linux-amd64"
chmod 777 $script
$script -importPath github.com/leanote/leanote