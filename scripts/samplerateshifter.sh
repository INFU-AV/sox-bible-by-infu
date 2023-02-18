#!/usr/bin/env bash

howto() {
local RE=$(printf '\e[0;31m') # REd
local NC=$(printf '\e[0m'   ) # NoColor
local GR=$(printf '\e[1;32m') # GReen
local YW=$(printf '\e[5;33m') # YelloW
local CA=$(printf '\e[1;36m') # CyAn
    cat >&2 <<EOM
- = ${YW}[${NC}Sample Rate Pitch Shifter${YW}]${NC} = - 
    ${RE}-["Best quality available!️"]-${NC}
${GR}usage${NC}: {SampleRate1} {Samplerate2} *.wav
${RE}requires${NC}: sox
${CA}output${NC} will have "out" at beginning of name!
${YW}=====ARGUMENTS${NC}:
${GR}\$1${NC}: "shifted" sample rate for pitch-shifting
${GR}\$2${NC}: the actual sample rate we want our audio to have
${CA}(sox accepts eithee full samplerate or shortened one ending with "k")${NC}
${GR}\$@${NC}: wav files to convert
${YW}=====FORMULA FOR PITCHING UP/DOWN${NC}:
CurrentSampleRate ${CA}*${NC} 1.0595${YW}^3${NC}  =  ${YW}3${NC}semis ${CA}higher${NC}
CurrentSampleRate ${RE}/${NC} 1.0595${YW}^12${NC} = ${YW}12${NC}semis ${RE}lower${NC}
${YW}=====EXAMPLES${NC}:
 ${GR}1${NC} octave higher: 88.2k  44100  YourAudio.wav
${GR}3${NC} octaves higher: 353.24k 44.1k YourAudio.wav
go ${RE}down${NC} ${RE}1${NC} octave: 22040  44.1k  YourAudio.wav
${YW}=====${NC}INFU${YW}=====${NC}
EOM
}

SoxRate(){ # usage: "48k" "22k" *

# Set variables first:
if [[ -n "$1" ]]; then
local Rate1="$1"
shift
else printf "\nNo samplerate specified!\n\n"
howto
 fi
if [[ -n "$1" ]]; then
local Rate2="$1"
shift
else printf "\nNo second samplerate specified!\n\n" ; howto ; fi

erroroopsie(){
printf "sox command has failed! "
printf "did you put in correct arguments?\n"
exit 2
}
# Main program loop
for file in "$@" ; do
    # play -b 16 -r "$Rate1" "$file" rate "$Rate2" norm
    sox -b 16 -r "$Rate1" "$file" out"$file" rate "$Rate2" norm || erroroopsie
done
} ; SoxRate "$@"
