#! /bin/bash

SSH1=$1
DIR1=$2
SSH2=$3
DIR2=$4

> "./not-synced"
> "./ls1"
> "./ls2"
> "./ls3"

LS1="./ls1"
LS2="./ls2"

if [ "$SSH1" = "local" ]; then
  #ls -1a -d -1 $DIR1/{*,.*} > $LS1
  ls -1a -d -1 $(realpath $DIR1)/{*,.*} > $LS1
else
  $SSH1 "ls -1a -d -1 $(realpath $DIR1)/{*,.*}" > $LS1
fi

if [ "$SSH2" = "local" ]; then
  #ls -1a -d -1 $DIR2/{*,.*} > $LS1
  ls -1a -d -1 $DIR2/{*,.*} > $LS1
else
  $SSH2 "ls -1a -d -1 $DIR2/{*,.*}" > $LS2
fi

# Correct for strange non-sorting behavior in SSH
cat $LS1 | sort -o $LS1
cat $LS2 | sort -o $LS2

# Delete first two lines of each file (i.e., ignore the '.' and '..' symlinks)
sed -i -e 1,2d $LS1
sed -i -e 1,2d $LS2

awk '{
		print
		getline line < second
		if ($0 != line) print line
}' second=$LS2 $LS1 > './ls3'

function check_input_dir_file_for_hash_consistencies() {

	while read line
	do

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
			continue
		else
			echo "$line is not synced" # safeguard against my own stupidity
			echo "$line" >> "./not-synced" # safeguard against my own stupidity
		fi
	done

}

LS3='./ls3'
cat $LS3 | check_input_dir_file_for_hash_consistencies
