// a class to make writing Csound Documents easier
class csdWriter {
  PrintWriter csd;
  String file_no_ext;
  String[] options = new String[1];
  int sample_rate = 44100;
  int samples_per_control = 10;
  int channels = 2;
  
  // for error checking
  boolean options_written = false;
  boolean global_params_written = false;
  boolean orc_written = false;
  boolean inst_in_progress = false;
  boolean score_written = false;
  
  
  // automatically appends csd to the end of the filename
  csdWriter(String filename){
    String newcsd = filename + ".csd";
    file_no_ext = filename;
    csd = createWriter(newcsd);
    options[0] = "-o " + file_no_ext + ".wav -W";
    csd.println("<CsoundSynthesizer>");
  }
  
  // make sure you have all the options you want before writing them to the csd
  void write_options(){
    if(options_written){
      println("Nope. Options have already been written to the file");
    } else {
      csd.println("<CsOptions>");
      for(int i = 0; i < options.length; i++){
        csd.println(options[i]);
      }
      csd.println("</CsOptions>");
      options_written = true;
    }
  }
  
  // allows you to set a new option before writing them to the file
  void new_option(String new_opt){
    if(options_written){
      println("No new options can be added. Options have already been written to the file.");
    } else {
      options = (String[])append(options,new_opt);
    }
  }
    
  void start_orc(){
    if(global_params_written){
      println("The orchestra header has already been written to the file.");
    } else {
      csd.println("<CsInstruments>");
      csd.println(); //for readability
      csd.println("sr = " + sample_rate);
      csd.println("ksmps = " + samples_per_control);
      csd.println("nchnls = " + channels);
      csd.println("0dbfs = 1");
      csd.println();
      global_params_written = true;
    }
  }
  
  void end_orc(){
    csd.println("</CsInstruments>");
    orc_written = true;
  }
  
  void set_channels(int nchans){
    if(global_params_written){
      println("Global parameters have already been written to the file and can no longer be changed.");
    } else {
      channels = nchans;
      if(channels < 1){
        println("Number of channels can't be zero or less.");
        println("So, it will be set to mono.");
        channels = 1;
      }
    }
  }
  
  void set_sample_rate(int srate){
    if(global_params_written){
      println("Global parameters have already been written to the file and can no longer be changed.");
    } else {
      sample_rate = srate;
      if(sample_rate <= 0){
        println("Sample rate can't be zero or less. Resetting to default 44.1 kHz.");
        sample_rate = 44100;
      }
    }
  }
  
  void set_ksmps(int ksmps){
    if(global_params_written){
      println("Global parameters have already been written to the file and can no longer be changed.");
    } else {
      samples_per_control = ksmps;
      if(samples_per_control <= 0){
        println("Samples per control period can't be zero or less. Resetting to default 10.");
        samples_per_control = 10;
      }
    }
  }
  
  // function for a personal project, but adds a set of global parameters
  void simple_oscs_ga(int len){
    csd.println();
    for(int i = 1; i <= len; i++){
      csd.println("ga" + i + " init 0");
    }
    csd.println();
  }
  
  // start a new instrument
  void new_instr(int inst){
    if(orc_written){
      println("Orchestra has already been written. Cannot add new instruments.");
    } else {
      csd.println("instr " + inst);
      csd.println();
      inst_in_progress = true;
    }
  }
  
  // close instument
  void end_instr(){
    if(inst_in_progress){
      csd.println("endin");
      csd.println();
      inst_in_progress = false;
    } else {
      println("An instrument is not currently being constructed.");
    }
  }
  
  // test oscil
  void simple_oscil_for_test(){
    if(inst_in_progress){
      csd.println("a1  oscil  " + "p4, " + "p5");
      csd.println("  out  a1");
      csd.println();
    } else {
      println("You have to start an instrument first.");
    }
  }
  
  // start the score section
  void start_score(){
    if(orc_written){
      csd.println("<CsScore>");
    } else {
      println("Orchestra has not been written yet.");
    }
  }
  // end the score section
  void end_score(){
    csd.println("</CsScore>");
    score_written = true;
  }
  
  // writes a score statement
  void write_score_statement(String[] params){
    for(int i = 0; i < params.length; i++){
      csd.print(params[i] + " ");
    }
    csd.println();
  }
  
  // end and finish the file
  void end_writer(){
    if(score_written){
      csd.println("</CsoundSynthesizer");
      csd.flush();
      csd.close();
    } else {
      println("Score not completed.");
    }
  }
  
}