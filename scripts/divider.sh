#!/usr/bin/env bash

howto() {
local RE=$(printf '\e[0;31m') # REd
local NC=$(printf '\e[0m'   ) # NoColor
local GR=$(printf '\e[1;32m') # GReen
local YW=$(printf '\e[5;33m') # YelloW
local CA=$(printf '\e[1;36m') # CyAn
    cat >&2 <<EOM
- = ${YW}[${NC}Audio Divider/Splitter${YW}]${NC} = - 
 ${RE}-["Chop samples in even slices!️"]-${NC}
${GR}usage${NC}: {Number} *.wav
${RE}requires${NC}: sox
${CA}output${NC} files will have slice number at the end!
(script will halt on any error!)
${YW}=====  ARGUMENTS${NC}:
${GR}\$1${NC}: - Number of parts we want to receive
${GR}\$@${NC}: - "*.wav" audio files to divide
${YW}=====${NC} INFU ${YW}=====${NC}
EOM
}

## No arguments, error out
if [[ "$#" -eq 0 ]] ; then
    howto
    exit 1
fi

trblshtng() { ## troubleshooting stats
printf -- "\n ===== ===== ====="
printf -- "\nFile    = $name"
printf -- "\nDiffer. = $Difference"
printf -- "\nDivider = $Divider"
printf -- "\nDivid+1 = $((Divider+=1))"
printf -- "\nDivSamp = $SliceDuration"
printf -- "\nF. Rate = $SamplesTotal"
printf -- "\n ===== ===== ====="
} # ; trblshtng

Division() { # main program
# check if $1 is a number
if [[ "$1" -gt 0 ]]; then
  local Divider="$1"
    shift
else
    printf "\nIncorrext Divider number!"
    printf "\nDisplaying help file.."
    howto
    exit 2
fi
# check if other arguments are present
if [[ -z $1 ]] ; then
    printf "No audio to divide!\n"
    printf "Displaying built-in help...\n\n"
    howto
    exit 2
fi

# file processing loop
for file in "$@"; do
## STEP 1: analyzing audio
  local SamplesTotal="$(soxi -s "$file")"
  local ext="${file##*.}"
  if [[ $ext != "wav" ]]; then
    printf -- "operating only on wav files!"
    printf -- "\n(everything else brings inaccuracies)"
    exit 2
    fi
  local name=$(basename "$file" ".$ext")
  # considering length as amount of samples in audio,
  # SliceLength = (TotalAudioLength / SliceQuanity)
  local SliceDuration=$(( SamplesTotal / Divider ))

  printf -- "Processing ${name}.${ext} ..."
## STEP 2: main slicing command!
  sox -V1 "$name".$ext "$name"%1n.wav trim 0s ${SliceDuration}s : newfile : restart || exit 3
 
  printf -- " DONE! ${Divider} slices produced\n"
## STEP 3: Check for && delete excess audio
# Sometimes audio we divided will not add up to original TotalAudioLength
# (SliceLength * SliceQuanity) != TotalAudioLength
# most of the time it's totally safe to delete it
  local Difference=$(($SamplesTotal - $SliceDuration * $Divider))
  if (( Difference != 0 )); then
    rm "$name"$((Divider +1)).wav && printf -- "(Deleted excess dull "$name"$((Divider +1)).wav file)"
    # rm "$name"$((Divider+=1)).wav && printf -- "(Deleted excess dull "$name"${Divider}.wav file)"
    # : $((Divider-=1))
    fi
  printf -- "\n"
  done
} ; Division $@

exit # FINAL

## so you don't loose hours like I did:
## having any effect before trim made multiple outputs broken
### This command works:
# sox "$ogname" "$name"%1.wav trim 0 "$Div4"s : newfile : restart
### Command below DOESNT WORK:
# sox "$ogname" output%1.wav norm trim 0 "$Div4"s : newfile : restart

## previously: no point using "bc" since sample
## is already the smallest thing out there
# local SliceDuration=$(echo "$SamplesTotal/$Divider" | bc -l)
# printf -v SliceDuration "%6.0f" "$SliceDuration"
