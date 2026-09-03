#!/bin/env bash
#
# Author: Phil Wyett (kathenas) - philip.wyett@kathenas.org
#
# Website: https://kathenas.org
#
# Buy me a coffee: https://www.buymeacoffee.com/kathenasorg
#
# License: GPLv3 - See https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Copyright is asserted by the author.

# Define some colours for text output.
red_text='\033[0;31m'
yellow_text='\033[0;33m'
green_text='\033[32m'
end_colour_text='\033[0m'

# If script run with 'sh', inform to execute directly or invoke with 'bash'.
if ! [ "$BASH_VERSION" ]
then
    printf "\n%b=== WARNING ===%b\n" "${yellow_text}" "${end_colour_text}"
    printf "\nPlease do not use %bsh%b to run this script %b%s%b. Run directly \
e.g. %b./%s%b if the script is set executable or use %bbash %s%b instead \
of %bsh %s%b.\n\n" 1>&2 "${yellow_text}" "${end_colour_text}" "${yellow_text}" \
"$0" "${end_colour_text}" "${green_text}" "$0" "${end_colour_text}" \
"${green_text}" "$0" "${end_colour_text}" "${yellow_text}" "$0" \
"${end_colour_text}"
    exit 1
fi

# Check we have 'ffmpeg' installed and available for use.
if ! [ -x "$(command -v ffmpeg)" ]
then
    printf "\n%b=== CRITICAL ===%b\n" "${red_text}" "${end_colour_text}"
    printf "\n'ffmpeg' could not be found.\n"
    printf "\nPlease check you have 'ffmpeg' installed on your system.\n"
    printf "\nUnable to continue, exiting program.\n\n"
    exit
fi

# Notify user that the conversion task is starting.
printf "\n%b>>> Conversion task is running. <<<%b\n\n" "${yellow_text}" \
"${end_colour_text}"

# Default (auto) number of threads for 'ffmpeg' is 0.
#
# Kathenas default is 4 and works well for background conversion on a modern
# Intel Ultra CPU. Change if you wish to the number you require.
set_threads=4

# Set CRF value.
set_crf=26

# Convert 'mkv' or 'mp4' file to a libx265 '.mkv' file with our custom settings.
for in_filename in *.[mM][pPkK][4vV]
do
    ffmpeg -i "$in_filename" -threads "$set_threads" -c:v libx265 \
        -crf "$set_crf" -c:a copy "converted_${in_filename%.*}.mkv"
    # Remove original input file.
    rm -f "$in_filename"
    # Rename converted file back to original filename.
    mv -f "converted_${in_filename%.*}.mkv" "${in_filename%.*}.mkv"
done

# Notify user that the task has completed.
printf "\n%b>>> Conversion task is complete. <<<%b\n" "${green_text}" \
"${end_colour_text}"

# Shameless plug to support poor Free/Open Source developers like myself who
# make content available to people for free with no strings attached.
printf "\nPlease consider supporting Free/Open Source developers like myself \
who provide content for free. Voluntary donations can be made at \
%bhttps://www.buymeacoffee.com/kathenasorg%b\n\n" "${green_text}" \
"${end_colour_text}"
