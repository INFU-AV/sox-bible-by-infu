#!/usr/bin/env bash

howto() {
local RE=$(printf '\e[0;31m') # REd
local NC=$(printf '\e[0m'   ) # NoColor
local GR=$(printf '\e[1;32m') # GReen
local YW=$(printf '\e[5;33m') # YelloW
local LI=$(printf '\e[4m') # YelloW
local CA=$(printf '\e[1;36m') # CyAn
    cat >&2 <<EOM
- = ${YW}[${NC}Short Audio Image Visualizer${YW}]${NC} = - 
${GR}usage${NC}: *.wav
${RE}requires${NC}: sox; gnuplot
${CA}output${NC} is 800x600 "filename".png image
${YW}=====ARGUMENTS${NC}:
${GR}\$@${NC}: all audio files to convert
(${RE}don't${NC} feed it ${RE}too big${NC} audio files!)
${YW}=====${NC}INFU${YW}=====${NC}
EOM
}

# uncomment for verbose script
# set -x

# todo:
# make it bit more verbose
# enable verbose graph variant & fullscreen one
  
## No arguments, error out
if [[ "$#" -eq 0 ]] ; then
    howto
    exit 1
fi

main(){
printf "STARTING TO PLOT..\n"
local PlotQ=1
for OGname in "$@"; do
  local Base=${OGname%.wav}
  local Name=$(basename "$OGname" ".$ext")
  # Create audio plot on successful data extraction
  sox ${Base}.wav ${Base}.dat && gnuplot --persist <<-EOFMarker
### NOTE: Code below been glued together from various sites
###+ and gnuplot examples/docs. It works for me on Termux,
###+ though could definitely use some improvement
## filter out sox dat file comments
set datafile commentschars ";"
set term png medium size 800,600 crop
# set term png small size 640,480 # crop
set output "${Base}.png"
# set title "\"${Base}\" waveform" font "sans,14" tc rgb "#606060"
# set xlabel "Audio length: $Length samples"
# set label "\"${Name}\"" \
set size 4,3
# set xlabel "time (samples)"
# set format x ""
# set format y ""
# set ytics axis
# set key bottom
set yrange [-1.0:1.0]
set ytics -1.0,0.2,1
# set yrange [*:*]
set nokey
# set xrange [0:0.001]
set xrange [*:*]
set xtics 0,0.045,1.5
# Replace small stripes on axis with a horizontal gridlines
set tic scale 2
set tics in
set grid xtics lc rgb "#F00000"
# set mxtics 5
set grid ytics lc rgb "#202020"
# set mytics 10
set label "\"${Name}\"" \
    font "sans,35" \
    at screen 0.5 , 0.5 center tc rgb"#C0C0C0"
# stats "${Base}.dat"
plot "${Base}.dat" with lines lw 2
EOFMarker
  rm ${Base}.dat || printf "\n${Name} audio file could not be processed\n"
  printf "\r$PlotQ out of ${#@} done\r"
  ((PlotQ++))

done
printf "\n"
} ; main "$@"
exit # FINAL EXIT

indepthimage(){ # UNUSED
# requires ffmpeg, though pointlessly
ffmpeg -hide_banner -i ${Base}.png -vf scale=800:600 ${Base}R.png
rm ${Base}.png
sox ${Base}.wav -n remix - spectrogram -r -o ${Base}-S.png
ffmpeg -hide_banner -i ${Base}-S.png -vf scale=800:600 ${Base}S.png
rm ${Base}-S.png
convert ${Base}R.png ${Base}S.png -compose luminize -composite ${Base}Both.png
# requires imagemagick
}
# original source http://linuxwebdev.blogspot.com/2006/03/plot-wav-file-wav2png.html
# archive: https://web.archive.org/web/20180602082711/http://linuxwebdev.blogspot.com/2006/03/plot-wav-file-wav2png.html
# gnuplot settings:
# https://www.electricmonk.nl/log/2014/07/12/generating-good-looking-charts-with-gnuplot/

# maybe ibteresting?
# https://funprojects.blog/2022/05/15/charts-in-1-line-of-bash/
