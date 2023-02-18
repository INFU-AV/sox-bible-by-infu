#!/usr/bin/env bash
howto() {
local RE=$(printf '\e[0;31m') # REd
local NC=$(printf '\e[0m'   ) # NoColor
local GR=$(printf '\e[1;32m') # GReen
local YW=$(printf '\e[5;33m') # YelloW
local CA=$(printf '\e[1;36m') # CyAn
    cat >&2 <<EOM
- = ${YW}[${NC}INFU sox-only WAVETABLE GENERATOR${YW}]${NC} = - 
${GR}usage${NC}: INTERACTIVE
${RE}requires${NC}: sox
   ( NO ARGS )
created audio waveforms will be ${CA}output${NC} into folder you're in right now
BUT ${RE}beware${NC}: each action generates easily 100s of waves!
${YW}=====TIPS AND TRICKS${NC}:
-Consider using audio visualiser to inspect the waves
  (for example, my "wav2png.sh" does the job perfectly!)
-"sox WaveYouWantToPlayback.wav repeat 40" = best way to pre-listen those short audio waves!
-When making wavetables, try ${RE}breaking the rules${NC}: in my own wavetable I placed
trimmed & sped-up drumbreak ${CA}(+2 octaves and no quality loss!? consider 3 for space efficiency)${NC},
which sounds extremely high quality (as I cannot make snare/hihat sounds so easily with wavetables)
and such expand my audio tool set when music making! ${GR}Think out of the box!${NC}
${YW}=====${NC}INFU${YW}=====${NC}
EOM
}
# leave on Errors, Unknown variables and failed pipes
set -eo pipefail

# Helpful word-splitting argument-handling
# NOT IN THIS SCRIPT APPARENTLY!!!!
##### IFS=$'\n\t'

# uncomment for verbose script
# set -x
InitializeVariables(){
## Arrays
Combines=(mix amod fmod)
Waves=(sine square triangle sawtooth trapezium exp) 
## those are different each period
Irregulars=(pluck noise tpdfnoise pinknoise brownnoise)
AllWaves=(sine square triangle sawtooth trapezium exp pluck whitenoise tpdfnoise pinknoise brownnoise)

## Selected objects
# sWaves=($Waves)
# sCombi=($Combines)
# ## Count arrays
# WavesQ=${#sWaves[*]}
# CombiQ=${#sCombi[*]}
## Randomise selection from arrays:
# echo -n ${sWaves[$((RANDOM%WavesQ))]}
# echo -n "${sCombi[$((RANDOM%CombiQ))]}"

samplerate="44100"
# samplerate="48000"
variables="-b 16 -D -c 1 -r ${samplerate} -G"
syn11khz="synth 558s" # Explained at the bottom:
# syn11khz="synth 1115s" # ^
syn="synth 0.5"
freq="172" # for 44.1k
# freq="188" # for 48k
# freq="1"
end="${freq}.4" # before I had some other commands here but they upset waveforms
}

BasicWaveforms(){
InitializeVariables
echo -n "Rendering basic waveforms + some variations:"
for W in ${Waves[@]}; do
#1st ordinary waveform chopped from the middle, as it's cleanest there
# actually not true
    sox -n $variables ${W}-1.wav $syn $W $end speed 1 pitch 1 upsample rate -h $samplerate trim 0 256s
# take waveform from mid-cycle 
   sox -n $variables ${W}-2.wav $syn $W $end speed 1 pitch 1 upsample rate -h $samplerate trim 126s =382s
   sox -n $variables ${W}-3.wav $syn $W $end speed 1 pitch 1 upsample rate -h $samplerate overdrive 18 reverse trim 0s =256s
   # sox -n $variables ${W}-4.wav $syn $W $end speed 1 pitch 1 upsample rate -h $samplerate trim 128s =384s downsample 12
   # sox $variables -v -1 ${W}-1.wav ${W}-4.wav norm reverse downsample 12 trim 0s =256s
   # rm ${W}-Raw.wav
done
printf "\nDone!\n"
}

NoiseWaves(){
InitializeVariables
echo -n "slightly different procedure for noises:"
for N in ${Irregulars[@]}; do
# Generate correctly set up audio we need
   sox -n $variables ${N}-Raw.wav $syn $N $end speed 0.2
   # sox -n $variables ${N}-1.wav $syn $N $end speed 1 pitch 1 upsample rate -h $samplerate trim 0 256s

# All those 3 waveforms here are unique
   sox -n $variables ${N}-1.wav $syn $N $end speed 1 pitch 1 upsample rate -h $samplerate trim 0s 256s
   sox -n $variables ${N}-2.wav $syn $N $end speed 1 pitch 1 upsample rate -h $samplerate trim 128s 348s
   sox -n $variables ${N}-3.wav $syn $N $end speed 1 pitch 1 upsample rate -h $samplerate trim 256s 512s
   sox ${N}-Raw.wav ${N}-1o.wav norm trim  0s  =256s
   sox ${N}-Raw.wav ${N}-2o.wav norm trim 128s =384s
   sox ${N}-Raw.wav ${N}-3o.wav norm trim 256s =512s
   # for C in {1,2,3}; do
   # sox ${N}-${C}.wav ${N}-${C}o.wav overdrive 18 norm
   # sox -D -v -1 ${N}-${C}.wav ${N}-${C}d.wav norm reverse downsample 12
   # done
   rm ${N}-Raw.wav
done
}

MixPowerPermutatingRenders(){
InitializeVariables
for a in ./*.wav ; do
    arrayFile+=("$a")
    # echo ${arrayFile[*]}
done
# we need second same array, reversed for most varied combos
for (( index = -1; index > -${#arrayFile[*]} -1; index-- )); do
    arrayFileReversed+=("${arr[*]:$index:1}")
done
echo ""
echo ${arrayFile[@]}
echo ""
echo ${arrayReversed[@]}
echo ""
  for Render in ${arrayFile[@]}; do
    for (( index = 0; index < ${#arrayFileReversed[*]}; index++ )); do
        printf "Permutation ${Permutation} in progress\r" # "/ $PermSum\r"
sox --combine mix-power $Render $Render2 ${Render}MixPow${Render2}.wav trim 0s 256s
            ((Permutation++))
    done
arrayFileReversed=( "${arrayFileReversed[@]/$Render}" )
  done
printf "\nDone!\n"
}

WavePermutaring(){
InitializeVariables
for a in ./*.wav ; do
    arrayFile+=("$a")
    # echo ${arrayFile[*]}
done
# command cp ../*.wav .
Permutation="1"
AllWavesAlt=(sine square triangle sawtooth trapezium exp pluck whitenoise tpdfnoise pinknoise brownnoise)
# creating ideal wavecycle for sox to use parameters from
sox -n $variables TEMP.wav $syn sine $end speed 1 pitch 1 upsample rate -h $samplerate trim 0 256s

# exit
printf "\n===== ===== =====\n"
printf "\n===== ===== =====\n"
printf "Permutation ${Permutation} in progress\r" # "/ $PermSum\r"
# Permutate Renders with every waveform, every mod type
for Wavecycle in ${AllWaves[@]}; do
  for (( index = 0 ; index < ${#Combines[*]}; index++ )); do
    for Render in ${AllWavesAlt[@]}; do
        printf "Permutation ${Permutation} in progress\r" # "/ $PermSum\r"
    sox TEMP.wav ${Render}-${Wavecycle}${Combines[$index]}.wav $syn ${Render} $end $syn $Wavecycle ${Combines[$index]} $end trim 0s 256s
            ((Permutation++))
    done
AllWavesAlt=( "${AllWavesAlt[@]/$Wavecycle}" )
  done
done
printf "\nDone!\n"
rm TEMP.wav

}
ArrangeWavetable(){

sox $(ls ./*.wav | sort -R | head -n 256) "$1".wav
printf "\nYou got $(($(soxi -s "$1".wav) / 256)) /256 wavecycles used!\n"
}

##### main functions get activated here
##probably still gotta refactor this but also I want to move on
printf "\n===== ===== =====\n"
printf "\e[4mWAVETABLE MAKER\e[m\n\n"
# printf "\e[4m"
PS3="Choose number of action to perform: "
# printf "\e[m\n\n"

select opt in BasicWaveforms NoiseWaves WavePermutaring ArrangeWavetable MixPowerPermutatingRenders Help Exit; do

  case $opt in
    BasicWaveforms)
# generates plenty basic waveforms & variations
        BasicWaveforms
      ;;
    NoiseWaves)
# generates noise waveforms (differently than basic ones)
        NoiseWaves
      ;;
    WavePermutaring)
# synthesizing lots of waveforms with each other (took care to remove dups!)
        WavePermutaring
      ;;
    ArrangeWavetable)
# pics up to 256 random waveforms and puts together wavetable (that may not be best way to do that ^^;)
      read -p "Enter wavetable name: " TheWav
        ArrangeWavetable $TheWav
      ;;
    MixPowerPermutatingRenders)
# mixes up renders in your folder with each other!
        MixPowerPermutatingRenders
      ;;
    Help | help)
    howto
    exit
      ;;
    quit | q | Exit | exit)
      break
      ;;
    *) 
      printf "${REPLY} : Invalid option, try again!\n"
      ;;
  esac
done

printf "\n===== ENJOY! =====\n\n"


exit # FINAL


##### THEORY
#     syn11khz="synth 1115s"
# sox has a bug regarding processing things at lower samplerates than 48k
# which is why instead of 256s I use 1115s
# correct way would be to synthesize entire second of audio
# and later trim it down to what we need

# at first I tried to generate longer audio and cut from there,
#+but this caused trimmed waves to be either sightly off or 
#+wrong pitch due to samplerate (due to lack od 2nd trim parameter)
````
example: sox synth 1 second sine
         sox trim to smol wave = wave wonky
````
# When I tried to synthesize initially waveforms, I was encountering various issues, later noticed they were associated with "trim" parameter position
````
   sox -n $variables ${W}-Alright.wav $syn $W $end speed 1 pitch 1 upsample rate -h $samplerate trim 0 256s
   sox -n $variables ${W}-ReallyBad.wav $syn $W $end speed 1 channels upsample trim 0 256s rate $samplerate
   sox -n $variables ${W}-NotGood.wav $syn $W $end trim 0 256s
````
   # sox $variables ${W}-Raw.wav ${W}-r${samplerate}-f${freq}.wav norm trim 0 0 =256s speed 1 channels upsample rate -h $samplerate #256s =512s
   # sox $variables ${W}-Raw.wav ${W}-1.wav norm trim 256s =512s
    # dirtier version would be "trim 0 =256s"
# take waveform from mid-cycle
   # sox $variables ${W}-Raw.wav ${W}-2.wav norm trim 128s =384s
   # sox $variables ${W}-Raw.wav ${W}-3.wav overdrive 18 norm trim 256s =512s norm
   # sox $variables -v -1 ${W}-1.wav ${W}-4.wav norm reverse downsample 12 trim 0s =256s
   # rm ${W}-Raw.wav
