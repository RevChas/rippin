# Copyright 2013 by Charles Herbig
# See copyright notice in the README.md file

BEGIN {
	FS = "\t+"
	workingdir = "$HOME/rips"
	importdir = "$HOME/import"
	hbc = "/Applications/HandBrakeCLI"
	atomp = "/usr/local/bin/atomicparsley"
	# Don't change lastseasondir, it gets updated as the script progresses
	lastseasondir = ""
	}

# Skip blank lines and comments
/^$/ { next }
/^#/ { next }

# Eject the volume used in the last rip.
/^_eject/ {
	printf "hdiutil eject \"/Volumes/%s\" \n", lastvol
	printf "echo Done ripping %s | growlnotify -n ripper -s %s rip finished \n\n", lastvol, lastvol
	next
	}

# Change the working directory for output
/^_workingdir/ {
	workingdir = $2 
	next
	}

# Volname   track   audiotracks showname    stik    epnum   season  image   title
# 1       	2       3           4           5       6       7       8       9

/^[A-Za-z0-9]/ {
	lastvol = $1 
	lastseason = $7
	newfile = $4 "_S" $7 "-E" $6 ".m4v"
	seasondir = workingdir "/" $4 "_S" $7

	if ( lastseasondir != seasondir ) {
		printf "mkdir -p \"%s\" \n", seasondir
		lastseasondir = seasondir
	}

	printf "waitvol \"/Volumes/%s\" \n", $1
	printf "%s -e x264 --preset \'Normal\' -a %s -i \"/Volumes/%s/VIDEO_TS\" -t %s -o \"%s/%s\" \n", hbc, $3, $1, $2, seasondir, newfile
	printf "%s \"%s/%s\" --stik value=%s --TVShowName \"%s\" --TVSeasonNum %s --artwork %s --TVEpisodeNum %s --title \"%s\" -o \"%s/%s\" \n\n", atomp, seasondir, newfile, $5, $4, $7, $8, $6, $9, importdir, newfile
		}

END {printf "hdiutil eject \"/Volumes/%s\" \necho Done ripping %s \n\n", lastvol, seasondir }

