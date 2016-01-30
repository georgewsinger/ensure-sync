#! /bin/bash

SSH1=$1
DIR1=$2
SSH2=$3
DIR2=$4

##SSH1=""
#SSH1="ssh -p 58002 george@192.168.1.2"

##SSH2=""
#SSH2="ssh -p 58005 george@192.168.1.5"
#DIR1="/home/george/Dropbox"
#DIR2="/home/george/Dropbox"

LS1="./ls1"
LS2="./ls2"

echo "Gathering list of files to compare (this may take a few seconds)."

# ls -1a -d -1 $PWD/{*,.*}
###"$SSH1" "ls -1a -d -1 $DROPBOX/{*,.*} > $DROPBOX/hash/ArchBox_dirs"

#$SSH1 "ls -1a -d -1 $DIR1/{*,.*}" > $LS1
#$SSH2 "ls -1a -d -1 $DIR2/{*,.*}" > $LS2
if [ "$SSH1" = "local" ]; then
  ls -1a -d -1 $DIR1/{*,.*} > $LS1
else
  $SSH1 "ls -1a -d -1 $DIR1/{*,.*}" > $LS1
fi

if [ "$SSH2" = "local" ]; then
  ls -1a -d -1 $DIR2/{*,.*} > $LS1
else
  $SSH2 "ls -1a -d -1 $DIR2/{*,.*}" > $LS2
fi

# Correct for strange non-sorting behavior in SSH
cat $LS1 | sort -o $LS1
cat $LS2 | sort -o $LS2

# Delete first two lines of each file (noise)
sed -i -e 1,2d $LS1
sed -i -e 1,2d $LS2

function check_input_dir_file_for_hash_consistencies() {

	while read line
	do
		#hashThroughSSH1="$($SSH1 "find \"$line\" -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum" < /dev/null)"
		#hashThroughSSH2="$($SSH2 "find \"$line\" -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum" < /dev/null)"

    if [ "$SSH1" = "local" ]; then
      hashThroughSSH1=$(find "$line" -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum)
    else
      hashThroughSSH1="$($SSH1 "find \"$line\" -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum" < /dev/null)"
    fi

    if [ "$SSH2" = "local" ]; then
      hashThroughSSH2=$(find "$line" -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum)
    else
      hashThroughSSH2="$($SSH2 "find \"$line\" -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum" < /dev/null)"
    fi

		echo "$hashThroughSSH1"
		echo "$hashThroughSSH2"
		
		if [ "$hashThroughSSH1" == "$hashThroughSSH2" ]
		then
			echo "$line is synced"
			continue # safeguard against my own stupidity
		else
			echo "$line is not synced" # safeguard against my own stupidity
      echo "$line" > "./not-synced"
			# break
		fi
	done

}

DIFF=$(diff "$LS1" "$LS2")
LS3=$(cat $LS1 $LS2 | sort | uniq)

if [ "$DIFF" == "" ] 
then
	cat $LS3 | check_input_dir_file_for_hash_consistencies
else
	# echo "LS1 differs from LS2."
	cat $LS3 | check_input_dir_file_for_hash_consistencies
	#echo "LS1 differs from LS2."
fi
