# csdwriter_class

A class made for Processing to make it easier for me to write Csound documents from sketches. Many functions are and will likely be very specific to what I use it for, I'll note it as *specific* if it was made for a single or narrow purpose I needed at a time.

Of course, to write a workable .csd the functions have to by triggered in a specific order. Some functions will make sure that it's in the correct section, but not all of them do. So, keep that in mind for now.

### Ideas

- make a new class for Instruments themselves and make a function that can call an instrument to insert it into a score (perhaps by loading it from a text file?)

- maybe refine the score statement function to get the instrument number, trigger time, and duration separately rather than hold everything in the parameter array (alternately, a function to fill that array)

**csdWriter(String filename)** - the constructor: the filename is just the preferred name of the file that you would like.
	The .csd extension is added automatically.
	
**write_options()** - writes the options (command-line flags) to the file. Will error out if options have already been written.
	Use new_option() to add an option before writing them to the file.
	
**new_option(String new_opt)** - adds a new option to the option list to be written to the file. Will error out if options have already been written.

**start_orc()** - starts the orchestra section of the file and writes the global parameters. Set global parameters manually before this,
	using set_channels() and set_sample_rate() if you want them to be different than the defaults.
	
**end_orc()** - writes the closing tag for the orchestra section
	
**set_channels(int nchans)** - set the number of output channels (default: 2 (stereo)) Must be used before start_orc()

**set_sample_rate(int srate)** - set the sample rate (default: 44.1 kHz) Must be used before start_orc()

**set_ksmps(int ksmps)** - set the number of samples per control period (Control rate is calculated from this and sample rate together.)
	(default: 10)

**simple_oscs_ga(int len)** - (*specific*) Creates a number of global audio outputs.

**new_instr(int inst)** - starts a section for inserting a new instrument

**end_instr()** - ends an instrument section

**simple_oscil_for_test()** - (*specific*) writes a simple oscillator in an instrument section. It will check to make sure it's in an instrument section.

**start_score()** - starts the score section of the file

**end_score()** - closes the score section

**write_score_statement(String[] params)** - takes an array of strings and writes them one after another in the score section

**end_writer()** - adds the closing tag to the .csd and finalizes the file