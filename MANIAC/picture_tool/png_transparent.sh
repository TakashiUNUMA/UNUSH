#!/bin/sh
#
# Make a Transparent PNG file
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/11/24
#

if test $# -lt 2
then
    echo "USAGE: ./png_transparent.sh [input] [output]"
    exit
fi

input=$1
output=$2

echo "Input file: ${input}"

echo "Now execute: convert -transparent white ${input} tmp.png"
convert -transparent white ${input} ${output}

echo "Output file: ${output}"
echo "Finish !"
