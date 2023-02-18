*maybe "sox-bible is bit of overstatement, but oh well..."*
# SOX BIBLE by INFU
Here you will find:
- many links to various fantastic `sox` resources (each one was also archived by "archive.org" in case some links fail!)
- Plenty commands or small scripts I assembled
- Focus on Wavetable Synthesis!

(It might not be comprehensive `sox` place-to-go, but surely you'll find it resourceful!)

`sox` is a robust command line audio studio for pretty much any kind of job - Think of it like "Text-based Audacity"!  
Easily convert your audio from one format to another - no problem!  
If you need extra precision, you have dozens of parameters to tweak!  
While not as user-friendly or intuitive like apps with graphic interface, `sox` can make up for it with it's speed and precision..
if you know how to achieve it ^^;  

Funny enough, `sox` a reason why I got into terminal/programming stuff at all!

To get most out of it, we need not only to learn `sox`, but also some scripting language, like Python, Bash, or Windows Batch!  
Programmer or not, if you're using terminal then some Bash knowledge will do you so good!  

in this article I'll stick to Bash (that's available in pretty much every Linux system, and on Windows available through "Git for Windows" / "WSL"!)

There aren't many examples online that take full advantage of all features...  
Heck - some `sox` effects feel barely talked about even by manual itself!*\**  
I got some links with `sox` guides and resources below, each containing various commands and tricks!  

One example of neglected powerful features IMO is "__synth__"!  

`sox` has built-in synthesizer, and while took me some time to understand it well, it was worth it as it's pretty cool!  
You can generate up to 10 waveforms, mix them together in couple ways, slap some effects on them, which got me thinking...  
__I can create my own wavetable!__
if you don't know what it is, let me try explain it without nerding out about whole *"Art and History of Wavetables" XD  

Wavetable is set of various tiny audio waveforms, grouped together as one small audio file:  
It's like a soundfont, with plenty instruments of varied timbre each, just with total limit of 2 seconds, taking no more than half a megabyte.. 
Wavetables can turn your basic Sampler into fully featured Synthesizer!  
I created a bunch of various helpful scripts to make those wavetables, some involve `sox` in some way, some others include other tools.  
Enjoy!

*\** *(Those who noticed how commands from the official documentation fail for no reason are victims or encoding issue - I've seen post about it on reddit but I lost it)*

# SOX LINKS

## Basics  
[15 Awesome Examples to Manipulate Audio Files Using Sound eXchange (SoX)](https://thegeekstuff.com/2009/05/sound-exchange-sox-15-examples-to-manipulate-audio-files/ )  
[Convert audio files with this versatile Linux command | Opensource.com](https://opensource.com/article/20/2/linux-sox)  
[03 – Using the command line to process audio – sound design media](https://digital.eca.ed.ac.uk/sounddesignmedia/2018/10/01/03-using-the-commandline-to-process-audio/)  
[sox cheat sheet · GitHub](https://gist.github.com/ideoforms/d64143e2bad16b18de6e97b91de494fd)  
[Quality sox articles](https://programmersought.com/tag/sox/)  
[https://wiki.linuxquestions.org/wiki/Sox](https://wiki.linuxquestions.org/wiki/Sox)  
[explainshell.com - sox flag explanation](https://explainshell.com/explain/1/sox)  
[Audio Analysis, Synthesis, Manipulation](http://notes.tomcarlson.com/sox)  
[Using sox (Multiple basics)](http://billposer.org/Linguistics/Computation/SoxTutorial.html)  
## Basics: youtube videos  
[Easy Audio Processing with SoX! - YouTube](https://youtube.com/watch?v=cpeqs1BJHT4)  
[Using the SOX audio manipulation command to process audio files - YouTube](https://youtube.com/watch?v=Ne-zMNmps-E)  
[Sound Effects Batch Sort and Rename Script using SoX - YouTube](https://youtube.com/watch?v=J9YFdtp73MA)  
## Particular  
[Generating (and Saving) Tones with SoX – Montessori Muddle](https://montessorimuddle.org/2012/04/19/generating-and-saving-tones-with-sox/)  
[Bash Script For An Oscilloscope&#x2026; « Bash recipes « ActiveState Code](https://code.activestate.com/recipes/578570-bash-script-for-an-oscilloscope/)  
[HOWTO: SoX audio tool as a signal generator | Audio Science Review (ASR) Forum](https://audiosciencereview.com/forum/index.php?threads/howto-sox-audio-tool-as-a-signal-generator.4242/)  
[sox – We Saw a Chicken …](https://scruss.com/blog/tag/sox/)  
[SOX audio examples - www.ReeltoReel.nl Wiki](https://www.reeltoreel.nl/wiki/index.php/SOX_audio_examples)  
[Sox in phonetic research - Phonlab](https://linguistics.berkeley.edu/plab/guestwiki/index.php?title=Sox_in_phonetic_research)  
[command line - Generate white noise to calm a baby - Ask Ubuntu](https://askubuntu.com/questions/789465/generate-white-noise-to-calm-a-baby/789472#789472)  
[CMU Sphinx - Speech Recognition · GitHub](https://gist.github.com/vunb/7132619#file-sox-noise-removal)  
## Scripts using SOX  
[ChaosCode/all2wav16bit.sh at main · INFU-AV/ChaosCode · GitHub](https://github.com/INFU-AV/ChaosCode/blob/main/scripts/all2wav16bit.sh)  
[sox-tricks/README.md at master · madskjeldgaard/sox-tricks · GitHub](https://github.com/madskjeldgaard/sox-tricks/blob/master/README.md)  
[GitHub - coderofsalvation/soxmasterhouse: automatically mastering of audio using sox/ladspa/vst](https://github.com/coderofsalvation/soxmasterhouse)  
[GitHub - jaimesBooth/SoXBatchBASH: BASH script to batch convert audio files down to 44.1 kHz, 16 bit using SoX's very high quality sample rate converter.](https://github.com/jaimesBooth/SoXBatchBASH)  
[GitHub - JakeWorrell/Glitch-Cutter: A little php script that uses SOX to randomly grab small bits of audio files and put them into new files. Perfect for making a bit of a racket in something like Renoise](https://github.com/JakeWorrell/Glitch-Cutter)  
[multi-core workouts: Plot a wav file - wav2png](http://linuxwebdev.blogspot.com/2006/03/plot-wav-file-wav2png.html)  
[GitHub - jobbautista9/SoxMusicGen: Easy music generation with SoX and Perl 5](https://github.com/jobbautista9/SoxMusicGen)  
[CMU Sphinx - Speech Recognition · GitHub](https://gist.github.com/vunb/7132619#file-sox-noise-removal)  
## Songmaking  
["synth.sh", official sox song example](https://sourceforge.net/p/sox/code/ci/master/tree/scripts/synth.sh)  
[GitHub - enkiv2/clisynth: A set of shell functions for simplifying music composition with sox](https://github.com/enkiv2/clisynth)  
## Unconventional  
[GUI GitHub - prof-spock/SoX-Plugins: Reimplementation of the SoX Command-Line Audio Processor as DAW Plugins](https://github.com/prof-spock/SoX-Plugins)  
[memcpy.io | Audio editing images](https://memcpy.io/audio-editing-images.html)  
[Sockbend](https://rose.systems/sockbend/)  
[GitHub - Roachbones/sockbend: Python scripts for databending images by editing them as audio data using SoX.](https://github.com/Roachbones/sockbend)  
