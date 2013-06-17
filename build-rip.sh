#!/bin/sh

# Copyright 2013 by Charles Herbig
# See copyright notice in the README.md file

awkscript=rip-and-tag.awk

while getopts a:i:o: myopt  ; do
	case $myopt in 
		a)
			awkscript=$OPTARG
			;;
		i)
			if [ -z $input ] ; then
				input=$OPTARG
			else
				input=${input}:$OPTARG
			fi
			lastfile=$OPTARG
			;;
		o)
			output=$OPTARG
			;;
		?)
			echo "Exiting" >&2
			exit 1
			;;
		esac
done

shift $(($OPTIND - 1))
for inopt in $* ; do
	if [ -z $input ] ; then
		input=$inopt
	else
		input=${input}:$inopt
	fi
	lastfile=$inopt
done

if [ -z $input ] ; then
	echo No input files to process
	echo Exiting
	exit 1
fi

if [ ! $output ] ; then
	output=`basename ${lastfile} .dat`.sh
fi

rm -f $output
echo "#!/bin/sh" >> $output
echo "" >> $output

echo 'waitvol () {' >> $output
echo '	# How long to wait between checks for a new disc' >> $output
echo '	waittime=60' >> $output
echo '	if [ -d $1 ] ; then' >> $output
echo '		return 0' >> $output
echo '	fi' >> $output
echo '' >> $output
echo '	echo Volume $1 not available | growlnotify -n ripper -s Waiting for volume $1' >> $output
echo '	while [ ! -d $1 ] ; do' >> $output
echo '		date' >> $output
echo '		echo Still waiting for $1' >> $output
echo '		sleep $waittime' >> $output
echo '	done' >> $output
echo '}' >> $output
echo '' >> $output


for infile in `echo $input | tr ':' ' '` ; do
	echo \# Input file $infile >> $output
	awk -f $awkscript $infile >> $output
	echo "" >> $output
done

chmod u+x $output

