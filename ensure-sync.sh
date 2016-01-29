#! /bin/bash

# public ip: 104.162.236.239
# local ip (ArchBox): 192.168.1.2
# local ip (ArchPad): 192.168.1.9

# ls -1a -d -1 $PWD/{*,.*}

ssh -p 58002 george@192.168.1.2 "ls -1a -d -1 $DROPBOX/{*,.*} > $DROPBOX/hash/ArchBox_dirs"
ssh -p 58004 george@192.168.1.4 "ls -1a -d -1 $DROPBOX/{*,.*} > $DROPBOX/hash/george_dirs"

# Correct for strange non-sorting behavior in SSH
cat $DROPBOX/hash/ArchBox_dirs | sort -o $DROPBOX/hash/ArchBox_dirs
cat $DROPBOX/hash/george_dirs | sort -o $DROPBOX/hash/george_dirs

# delete first two lines of each file
sed -i -e 1,2d $DROPBOX/hash/ArchBox_dirs
sed -i -e 1,2d $DROPBOX/hash/george_dirs

function check_input_dir_file_for_hash_consistencies() {

	while read line
	do
		hashArchBox="$(ssh -p 58002 george@192.168.1.2 "find $line -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum" < /dev/null)"
		hashArchPad="$(ssh -p 58004 george@192.168.1.4 "find $line -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum" < /dev/null)"

		echo "$hashArchBox"
		echo "$hashArchPad"
		
		if [ "$hashArchBox" == "$hashArchPad" ]
		then
			echo "$line is synced"
			continue # safeguard against my own stupidity
		else
			echo "$line is not synced" # safeguard against my own stupidity
			# break
		fi
	done

# while read line
# do
# 	echo "$line"
# 	echo "$(find "$line" -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum)" 
# 	echo "$(ssh -p 58004 george@192.168.1.4 "find $line -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum" < /dev/null)"
# 	#hashArchBox=$(ssh -p 58002 george@192.168.1.2 find "$line" -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum) 
# done

}

DIFF=$(diff "$DROPBOX/hash/ArchBox_dirs" "$DROPBOX/hash/george_dirs")

if [ "$DIFF" == "" ] 
then
	cat $DROPBOX/hash/ArchBox_dirs | check_input_dir_file_for_hash_consistencies
else
	echo "ArchBox_dirs differs from george_dirs."
	cat $DROPBOX/hash/ArchBox_dirs | check_input_dir_file_for_hash_consistencies
	echo "ArchBox_dirs differs from george_dirs."
fi
