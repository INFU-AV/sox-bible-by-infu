# sox in use:
Here's plenty cool commands I've put together while making wavetables or whatnot:
Some commands might've been made with less knowledge I got now, don't mind the mess!
Cooler/noteworthy commands probably got assembled into their own scripts!

## Get rid of spaces in filenames (saves you fighing whitespace demons!)
```bash
for f in *\ *; do mv "$f" "${f// /_}"; done
```

## sort files sort them by samplerate:
```bash
for i in *.wav; do printf "$i\t"; soxi -r "$i" ; done | sort -k2nr > samplerates.txt
```

## same but channels
```bash
for i in *.wav; do printf "$i\t"; soxi -c "$i" ; done | sort -k2nr > channels.txt
```

## Look for samples in current folder that are not 16bit
```bash
soxi -b * | grep -v 16
```

## Convert all audio from here into folder:
```bash
# for each file do conversion to 2 channels 16 bit 44.1KHz, output same name in "out" folder, normalize
for i in *.*; do sox -V1 "$i" -c 2 -b 16 -r 44100 "out/$i" channels upsample rate -h 44100 norm ; done
```

```bash
# un-one-lined:
for i in *.*
  do sox -V1 "$i" -c 2 -b 16 -r 44100 "out/$i" channels upsample rate -h 44100 norm
  done
 ```

## Same as above but keeps the channel count as original
```bash
for i in *.*; do sox -V1 "$i" -b 16 -r 44100 "out1/$i" upsample rate -h 44100 norm ; done
```

## Combine all wav files together && make total spectrogram
```bash
sox $(command ls *.wav) total.wav && sox total.wav -n spectrogram -o total.png
```

## sort by statistic 
```bash
shopt -s nocaseglob
##sample rate:
#### cond=r
#### con1=22050
#### con2=44100
### channels:
cond=c
con1=1
con2=2
mkdir "$con1"
mkdir "$con2"
for i in *.wav; do
case $(soxi -$cond "$i") in
    $con1)
        mv -- "$i" "$cont1"/ 
      ;;
    $con2)
        mv -- "$i" "$cont2"/
      ;;
    *)
        echo "3rd unexpected parameter:"
        printf "$i\t$(soxi -$cond "$i")"
        exit 1
      ;;
    esac
done
#mv "$i" 1channel/
    # convert every file here to mono 22kHz
for i in *.*; do sox -V1 "$i" -c 1 -b 16 -r 22050 "out/$i" channels upsample rate -h 22050 norm ; done
```
## monowave into separate waveforms
```bash
sox monowave.wav monowave%3n.wav trim 0 256s : newfile : restart
```
## create inbetween wave across all files
```bash
monoarray=( ) ; for a in ./*.wav ; do monoarray+=("$a") ; done # echo ${monoarray[0]} ; echo ${monoarray[255]}
for (( Index = 0; Index < ${#monoarray[*]}; Index++ )); do
sox --combine mix ${monoarray[$Index]} ${monoarray[$((Index +1))]} ${monoarray[$Index]%%.wav}half.wav
done
```
## combine waves in pairs,
```bash
monoarray=( ) ; for a in ./*.wav ; do monoarray+=("$a") ; done # echo ${monoarray[0]} ; echo ${monoarray[255]}
for (( Index = 0; Index < ${#monoarray[*]}; Index++ )); do
sox --combine concatenate ${monoarray[$Index]} ${monoarray[$((Index +1))]} ${monoarray[$Index]%%.wav}double.wav
done
```
## Extend single cycle waveforms so you can properly listen to them
```bash
for f in *.wav; do play ${f%%.*}.wav repeat 50; done
```
## Same as above, but creates longer audio files
```bash
for f in *.wav; do sox ${f%%.*}.wav ${f%%.*}L.wav repeat 50; done
sox monowave*L.wav MonoLong.wav
```

## Calculate BPM of 1st argument of script:
```bash
### save as script, then after script name include audio file
## #probably you need to download "bc"
BPMcalc() {
echo  "BPM formula for perfect 4beat sample:"
echo "(BeatsPerSecond * 60 seconds) = BPM"
echo "(4 beats / Duration) = BPS"
echo "(Length in seconds up to 2 decimal places) = Duration"
echo "For accuracy, we gonna calculate duration nerdier.."
echo "(TotalSamples / SampleRate) = Duration"
samples="$(soxi -s "$1")"
srate="$(soxi -r "$1")"
sec=$(echo "$samples/$srate" | bc -l)
printf "$samples / $srate = "
printf "%6.2f" "$sec"
printf "s\n"
echo "(4 beats / Duration) = BPS"
bps=$(echo "(4 / $sec)" | bc -l)
printf "4 beats in sample / "
printf "%6.2f" "$sec"
printf " = "
printf "%6.2f" "$bps"
printf "\n"
echo "(BeatsPerSecond * 60 seconds) = BPM"
bpm=$(echo "($bps * 60)" | bc -l)
printf "%4.2f" "$bps"
printf " * 60 = "
printf "%3.2f" "$bpm"
printf "\n"
}
done
```
## One super rad effect/synth
```bash
    sox -n mega.wav synth 15 square 150.4 synth sine amod 150 synth saw mix 150 reverse synth triangle fmod 149.6 synth square fmod 75 norm phaser 1 1 0.8 0.99 0.1 -s overdrive 20 15 speed 0.5 echo 1 0.8 400 0.4 230 0.7 600 0.2 800 0.1 vol 0.8
```

## Slap some effects on audio
```bash
PPP(){ # $1 as audio input
local Setup="-b 16 -r 44100"
local Com="compand 0.3,1 6:-70,-60,-20 -5 -90 0.2"
local extra="contrast 50"
local chor="chorus 0.9 0.5 25 0.7 0.1 10 -t chorus 0.3 0.9 22 0.4 0.25 3 -t"
sox "$1" $Setup 1normalized.wav norm 
sox "$1" $Setup 2compressed.wav $extra $Com
sox "$1" $Setup 3overdriven.wav overdrive 10
sox "$1" $Setup 4overdrCompr.wav overdrive 10 $Com
sox "$1" $Setup 5ContrastChorusNorm.wav $extra $chor norm 
sox "$1" $Setup 6ContrastChorusCompr.wav $extra $chor $Com
sox "$1" $Setup 7ContrastChorusOverd.wav $extra $chor overdrive 10
sox "$1" $Setup 7ContrastChorusOverdCompr.wav $extra $chor overdrive 10
sox "$1" $Setup 8a.wav bass +2 $Com overdrive 15 $extra $chor $Com
sox "$1" $Setup 8b.wav bass +2 $extra $chor overdrive 15 $Com
sox "$1" $Setup 8c.wav bass +2 overdrive 15 $extra $chor $Com
# printf -v "extra" 
} # PPP "$1"
```

## play random sequence of files
```bash
i=0
while [[ $i -lt "$2" ]]; do
play $(find . -type f | shuf -n 5) 
((i++))
done
# $1 $2
LENGTH=${#ARRAY[@]} RANDOM=${a[RANDOM%$LENGTH]}
```
## sox live nokia keyboard, plus few synthesized sounds I made
```bash
soxkeys(){
# https://gist.github.com/skratchdot/c912fe317192eb8b1c3c6d54d7ff71ae
echo "Hit a key!"

local PlaySound="play -n synth 0.2"
local Row1='697'
local Row2='770'
local Row3='852'
local Row4='941'
local Col1='1209'
local Col2='1336'
local Col3='1477'
local Col4='1633'

while true; do
read -r -s -t 5 -n1 keypress || exit
# echo; echo "Keypress was "\"$keypress\""."
  case "$keypress" in
  1) # Keypad 1 Signal
$PlaySound sin $Row1 sin $Col1 remix - >&/dev/null ;;
  2) # Keypad 2 Signal
$PlaySound sin $Row1 sin $Col2 remix - >&/dev/null ;;
  3) # Keypad 3 Signal
$PlaySound sin $Row1 sin $Col3 remix - >&/dev/null ;;
  q) # Keypad 4 Signal
$PlaySound sin $Row2 sin $Col1 remix - >&/dev/null ;;
  w) # Keypad 5 Signal
$PlaySound sin $Row2 sin $Col2 remix - >&/dev/null ;;
  e) # Keypad 6 Signal
$PlaySound sin $Row2 sin $Col3 remix - >&/dev/null ;;
  a) # Keypad 7 Signal
$PlaySound sin $Row3 sin $Col1 remix - >&/dev/null ;;
  s) # Keypad 8 Signal
$PlaySound sin $Row3 sin $Col2 remix - >&/dev/null ;;
  d) # Keypad 9 Signal
$PlaySound sin $Row3 sin $Col3 remix - >&/dev/null ;;
  z) # Keypad * Signal
$PlaySound sin $Row4 sin $Col1 remix - >&/dev/null ;;
  x) # Keypad 0 Signal
$PlaySound sin $Row4 sin $Col2 remix - >&/dev/null ;;
  c) # Keypad # Signal
$PlaySound sin $Row4 sin $Col3 remix - >&/dev/null ;;
  4) # Keypad A Signal
$PlaySound sin $Row1 sin $Col4 remix - >&/dev/null ;;
  r) # Keypad B Signal
$PlaySound sin $Row2 sin $Col4 remix - >&/dev/null ;;
  f) # Keypad C Signal
$PlaySound sin $Row3 sin $Col4 remix - >&/dev/null ;;
  v) # Keypad D Signal
$PlaySound sin $Row4 sin $Col4 remix - >&/dev/null ;;
  !) # Keypad 1 Signal with swirl!
$PlaySound sin $Row1-$((Row1 + Row1 / 10)) sin $Col1-$((Col1 + Col1 / 10 )) remix - >&/dev/null ;;
  @) # Keypad 2 Signal with swirl!
$PlaySound sin $Row1-$((Row1 + Row1 / 10)) sin $Col2-$((Col2 + Col2 / 10)) remix - >&/dev/null ;;
 \#) # Keypad 3 Signal with swirl!
$PlaySound sin $Row1-$((Row1 + Row1 / 10)) sin $Col3-$((Col3 + Col3 / 10)) remix - >&/dev/null ;;
  Q) # Keypad 4 Signal with swirl!
$PlaySound sin $Row2-$((Row2 + Row2 / 10)) sin $Col1-$((Col1 + Col1 / 10)) remix - >&/dev/null ;;
  W) # Keypad 5 Signal with swirl!
$PlaySound sin $Row2-$((Row2 + Row2 / 10)) sin $Col2-$((Col2 + Col2 / 10)) remix - >&/dev/null ;;
  E) # Keypad 6 Signal with swirl!
$PlaySound sin $Row2-$((Row2 + Row2 / 10)) sin $Col3-$((Col3 + Col3 / 10)) remix - >&/dev/null ;;
  A) # Keypad 7 Signal with DOWN swirl!
$PlaySound sin $Row3-$((Row3 - Row3 / 10)) sin $Col1-$((Col1 - Col1 / 10)) remix - >&/dev/null ;;
  S) # Keypad 8 Signal with DOWN swirl!
$PlaySound sin $Row3-$((Row3 - Row3 / 10)) sin $Col2-$((Col2 - Col2 / 10)) remix - >&/dev/null ;;
  D) # Keypad 9 Signal with swirl!
$PlaySound sin $Row3-$((Row3 + Row3 / 10)) sin $Col3-$((Col3 + Col3 / 10)) remix - >&/dev/null ;;
  Z) # Keypad * Signal with TWISTED swirl!
$PlaySound sin $Row4-$((Row4 + Row4 / 10)) sin $Col1-$((Col1 - Col1 / 10)) remix - >&/dev/null ;;
  X) # Keypad 0 Signal with TWISTED swirl!
$PlaySound sin $Row4:$((Row4 - Row4 / 10)) sin $Col2:$((Col2 + Col2 / 10)) remix - >&/dev/null ;;
  C) # Keypad # Signal with swirl!
$PlaySound sin $Row4-$((Row4 + Row4 / 10)) sin $Col3-$((Col3 + Col3 / 10)) remix - >&/dev/null ;;
  $) # Keypad A Signal with swirl!
$PlaySound sin $Row1-$((Row1 + Row1 / 10)) sin $Col4-$((Col4 + Col4 / 10)) remix - >&/dev/null ;;
  R) # Keypad B Signal with swirl!
$PlaySound sin $Row2-$((Row2 + Row2 / 10)) sin $Col4-$((Col4 + Col4 / 10)) remix - >&/dev/null ;;
  F) # Keypad C Signal with swirl!
$PlaySound sin $Row3-$((Row3 + Row3 / 10)) sin $Col4-$((Col4 + Col4 / 10)) remix - >&/dev/null ;;
  V) # Keypad D Signal with swirl!
$PlaySound sin $Row4-$((Row4 + Row4 / 10)) sin $Col4-$((Col4 + Col4 / 10)) remix - >&/dev/null ;;

  5) # Dial Tone
play -n synth 1.2 sin 350 sin 440 remix 1-2 >&/dev/null ;;
  b) # Busy Dial
# play -n synth sine 480 sine 620 remix 1-2 fade 0 0.5 delay 0.5 repeat 5 >&/dev/null
# original command took time to start, so I rewrote it
play -n synth 0.5 sin 480 sin 620 remix 1-2 >&/dev/null
sleep "0.42"
play -n synth 0.5 sin 480 sin 620 remix 1-2 >&/dev/null
sleep "0.42"
# notice sin now is sine, and duration is done as fade
play -n synth sine 480 sine 620 remix 1-2 fade 0 0.5 >&/dev/null
sleep "0.42"
play -n synth sine 480 sine 620 remix 1-2 fade 0 0.5 >&/dev/null
sleep "0.42" ;;
  t) # Reorder
play -n synth sin 480 sin 620 remix 1-2 fade 0 0.25 delay 0.25 repeat 5 >&/dev/null ;;
  g)
play -n synth sine 440 sine 480 remix 1-2 fade 0 2 >&/dev/null
sleep "3.92"
play -n synth sine 440 sine 480 remix 1-2 fade 0 2 >&/dev/null
sleep "3.92"
# play -n synth sine 440 sine 480 remix 1-2 fade 0 2 delay 4 repeat 5
  ;;
  h) play -n synth sine 440 fade 0 0.3 delay 10 repeat 5 >&/dev/null ;;
  p) # Kick
play -n \
synth 0.25 sine 200-20 \
overdrive +15 \
fade p 0 0.25 0.25 \
overdrive +15 \
synth 0.15 sine 250-10 \
gain -h overdrive +5 remix - >&/dev/null
      ;;
  K) # Bass
play -b 4 -r 44k -n \
synth sawtooth 35.3 \
overdrive +9 \
synth sawtooth mix 35.1 \
overdrive +9 \
synth sine fmod 68 \
overdrive +9 \
synth sawtooth  mix 70.1 \
overdrive +9 \
synth 3 sine amod 424 \
fade h 0 3 2 \
overdrive +5 \
gain -h remix - &
      ;;
  k) # Bass
play -n \
synth sawtooth 35.0 \
overdrive +9 \
synth sawtooth mix 35.3 \
overdrive +9 \
synth sine fmod 68 \
overdrive +9 \
synth sawtooth  mix 70.2 \
overdrive +9 \
synth 3 sine amod 419 \
fade h 0 3 2 \
overdrive +5 \
gain -h remix - &
      ;;
  o) # Hi-hat
play -n \
synth whitenoise 500 fade 0 0.08 0.08 \
gain -h >&/dev/null
      ;;
  P) # Snare
play -n \
synth 0.2 brownnoise mix 200 \
synth whitenoise 500 fade 0 0.7 0.7 \
gain -h overdrive +5 10 >&/dev/null
      ;;
  *)
      exit
      ;;
  esac
done
} ; soxkeys
```
## sox parody quality script
```bash
#!/usr/bin/env bash

## No arguments, error out
if [[ "$#" -eq 0 ]] ; then
echo "Choose 1 sox-compatible file to MAKE IT SHIT!"
echo " 💩 "
echo " watch out on spaces, and beware that"
echo "this script will make huge mess from where you use it!!"
echo " (try using it in new folder or something lol)"
exit $((RANDOM % 11))
fi

main(){
#values we gonna be using:
local ogfile="$1"
local i="1"
local ii="2"
# initial high quality/size cmd
sox $ogfile -C 320 -r 48000 File"$i".mp3 spectrogram -o File"$i".png || ohshit

ohshit() { #shit handler
echo "Something shat itself - ABORTING!"
exit $((RANDOM % 111))
}

# now we take stairs to hell
for (( index = 0 ; index < 10 ; index++ )); do
# 💩
  echo "Shitenizing in progress.."
  sox -V0 File"$i".mp3 -C 32 File"$ii".mp3
  sox -V0 File"$ii".mp3 -n spectrogram -o File"$ii".png
  echo "Level of Shit $i achieved!"
  echo "IT'S NOT CRAP ENOUGH!"
  let "i++"
  let "ii++"
done

# here's nice file combining all audio together + free souvenir!
sox $(command ls ./File{1,2,3,4,5,6,7,8,9}.mp3) total.mp3 ; sox total.mp3 -n spectrogram -o total.png

} ; main "$1"
```
## Random synthesizing
```bash
# first attempts of wavetable making! ;3
synthesize() {

failure() {
echo "SOX command failed, exiting"
exit 5
}

## setting variables
ogname="$1"
location="${1%/*.*}"
ext="${1##*.}"
name=$(basename "$1" ".$ext")
dur=4

# dur=$((256 * 32))s
# pitch values
# echo "$a / ( $b - 34 )" | bc -l

p_3="0.2"
# half + 2 detunes:

p_1h=$(( p_1 / 2 ))
p_1d="$p_1.09"
p_1D="$p_1.25"
p_2=50
p_2h=$(( p_2 / 2 ))
## Arrays
Combines="create
mix
amod
fmod"
Waves="sine
square
triangle
sawtooth
trapezium
exp
pluck"
## excluded noise because it's not as fun (thats a lie)
# noise
# tpdfmoise
# pinknoise
# brownnoise

## Selected objects
sWaves=($Waves)
sCombi=($Combines)
## Count arrays
WavesQ=${#sWaves[*]}
CombiQ=${#sCombi[*]}
## Randomise selection from arrays:
echo -n ${sWaves[$((RANDOM%WavesQ))]}
echo
echo -n "${sCombi[$((RANDOM%CombiQ))]}"
echo
sox -n -V2 -b 16 "$ogname" \
synth $dur sine $p_1 \
synth $dur ${sWaves[$((RANDOM%WavesQ))]} $p_1D \
synth $((dur / 2 )) ${sWaves[$((RANDOM%WavesQ))]} ${sCombi[$((RANDOM%CombiQ))]} $p_1h \
synth $dur ${sWaves[$((RANDOM%WavesQ))]} ${sCombi[$((RANDOM%CombiQ))]} $p_1d \
synth $dur trapezium fmod $p_1h fade 0 2 norm -2
} ; synthesize || failure
```

-----------------

... I do hope I didn't dissapoint any of you with the wavetable generator script -
After countless bugs/quirks I encountered I realized how wavetable generating using "sox"  
is a wild idea on it's own, not gonna mention how Bash is not ideal way to put it all together either,
but hey, at the end of the day you can generate some nice results!  

This process made me realize how best wavetables can be generated when using our own waveforms, or squeezing in long samples:  
first of all I know what part of wavetable does what!
Unfortunately that whole sox repository is pretty much all I want to generate - I discovered other, less cumbersome ways for wavetable creation like:  
https://www.youtube.com/playlist?list=PL9KNk-UUudH2Wa3dQdKIkFcM02mWVVaIG  
https://www.hermannseib.com/waveterm/  
https://www.kimurataro.com/blog/basics-of-creating-wavetables-in-octave-vol1  
and many others!  

-----------------

```bash
# BUGGY
sox -n -b 4 -r 22050 lol.wav synth 1000s
sox lol.wav new.wav trim 0 1s; soxi new.wav
sox -n -b 8 -r 44100 not1000.wav synth 1000s ; soxi not1000.wav
```
