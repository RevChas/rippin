rippin
======

Scripts and file templates to help organize ripping TV show DVD sets into iTunes.

This project uses the HandBrakeCLI utility to rip a show from DVD to an m4v file suitable for importing into iTunes. I developed this all on Mac OS X 10.8.3, and it is designed with that platform in mind.

You can get HandBrake and HandBrakeCLI here:

http://handbrake.fr/downloads2.php

In order to rip and tag files, you need to install the homebrew package management system for Mac OS X or get the equivalent packages installed for Linux.

You can get brew from here:

https://github.com/mxcl/homebrew

Then install these packages:

atomicparsley
libdvdcss
libdvdnav
libdvdread

The .dat files contain the data about the shows and which DVD discs they are on which is used to build a script that actually does the ripping and tagging. Each show episode is on one line, and data fields are separated by one or more TAB characters.

Before you start, edit the rip-and-tag.awk script and make sure the values in the BEGIN block are OK:

```awk
workingdir = "$HOME/rips"
importdir = "$HOME/import"
hbc = "/Applications/HandBrakeCLI"
atomp = "/usr/local/bin/atomicparsley"
```

The script will put the initial rips into the workingdir directory, organized by show and season. Then the shows will be tagged and placed into the importdir directory.

Here's the workflow I use:

Copy the template.dat file to a new data file

I'll use the DVD Player application tht comes with Mac OS X, but you should find the equivalent information in your player of choice.

First, edit the Show and Season# fields to the name of the Show and the season. Then, edit the Art field to point to a JPEG or PNG image to tag the show with a logo or whatever.

Start up DVD Player with the first DVD

For each episode on the disc, start playing the episode

Edit the Volume name to match the DVD name

Use the menu option Go->Title to determine the DVD title number for this episode and update that field

Use the menu option Features->Audio to determine which audio tracks I want to rip. The audio track field is a comma-separated list of number for each audio track. You can include extra languages and commentary tracks into the show if they are there. The Audio menu lists them in order, starting with number 1.

Edit the Episode# field to the episode number. If you are ripping extras like interviews and gag reels, I use episode numbers starting with 101 so they are collected at the end of the season in iTunes.

For TV shows, the stik field should be 10. If you want to have the shows show up as something else, run "atomicparsley --stik-list" to show the string and number values for this field. My awk script assumes that this field will be a number. If you want to use a string for this field, you need to change the --stik syntax in rip-and-tag.awk

Finally, change the last field in the record to the episode title. This can have spaces in it.

Once you've done this for all the show episodes you want to rip, make sure that your DVD player has stopped playing the disc, not even at the DVD menu.

Build the rip script with the build-rip.sh script. This script takes 3 types of arguments:

-a The name of an alternate awk script, if you want to experiment. The default is to use rip-and-tag.awk
-i The name of a data file that is formatted like template.dat, you can have as many of these as you like, but you must have at least 1.
-o The name of the rip script. If this isn't given, it will default to the last data file with a .sh suffix

For example, if I wanted to build a rip script that has two seasons in different .dat files and have 1 output script with a different name:

./build-rip.sh -i season1.dat -i season2.dat -o show-rip.sh

Then run the show-rip.sh script and off it goes. You can have a rip run across multiple DVDs. The script will eject a disk automatically if you tell it to, and will wait for the next DVD before continuing to rip. I try to keep the rip scripts limited to 1 season at a time so that repetition in editing the .dat file doesn't lead to mistakes.

Once the rip script is done, you'll have all your tagged shows in the importdir directory. The easiest way to import them into iTunes is to start iTunes and drop a few shows at a time into the "Automatically Add to iTunes.localized" directory in your "iTunes Media" directory. iTunes will import files dropped in here into the Library, and remove them when it's done.

You should try setting up and ripping 1 disc at a time to get a hang of how things work. Handbrake is *very* verbose during the rip.

Notes and Warnings
==================

I haven't included support for including subtitles, and I'm not sure I ever will, but if someone figures out a good way to manage that, I'll see about including it in future versions.

I have found a few shows that do something funky with DVD extras. All of the extras will be included in one DVD title, sometimes in 1 chapter, sometimes in several. I haven't figured out how to get Handbrake to rip these properly, at best I get 1 of the extras. If anyone figures out how to sift these out into a rip, please let me know.

I have developed and refined these tools over the past few weeks while ripping a bunch of TV show DVDs to import into iTunes. I have considered working on a front-end tool to enter information into the .dat files, but I haven't had the inclination to spend that much development time on it. If you're interested in doing that, I'd be interested in including that in this repo in the future.


Copyright 2013 by Charles Herbig

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">rippin</span> by <span xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName">Charles Herbig</span> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/RevChas/rippin" rel="dct:source">https://github.com/RevChas/rippin</a>
