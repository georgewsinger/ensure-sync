# ensure-sync

Ensure-sync is a CLI utility which allows you to verify whether or not two folders over a SSH network are synced. 

For example, services like Dropbox purport to keep folders in sync, but sometimes they lie (especially over poor internet connections :) This program can help you verify whether such folders are in sync and, if not, help you pinpoint where the mismatch is at.

# Installation

    $ npm install -g ensure-sync

# Instructions

First, launch the program:

    $ ensure-sync

Next, you will be prompted to enter 4 pieces of information: (i) your target SSH address (e.g., user@192.168.1.1), (ii) your target SSH port (e.g., 22), (iii) your source folder (e.g., a folder on your local machine), and (iv) your target folder (e.g., a folder on the SSH machine). Note that for (iii) and (iv) you **must** use full paths (unfortunately, this program can't handle environment variables or `~`).

After inputing this information, sit back and wait while hash values are computed for each folder and file (depending upon how large your folders are, this can end up taking several seconds).

# Interpreting the Output

The output of this command will look something like the following:

		b36ea4e02d9d387930ef8acceb7ccdc78e4082ae  -
		b36ea4e02d9d387930ef8acceb7ccdc78e4082ae  -
		/home/user/dir1 is synced
		52b2cd71188d96c4f99f20d21d5fa59b9ded8af5  -
		3d41429acfaceb6ea504c4ebbd6afda04d3d0bc6  -
		/home/user/dir2 is not synced

Those big strings are just hash sha1 values computed from your folders and files. Indeed, all this program does is compute sha1 hashes for each of your system's files, and compares them to infer whether or not they are in sync.

# Requirements

- A unix system.
- npm + nodejs
