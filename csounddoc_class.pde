// a class to make writing Csound Documents easier
class csdWriter {
  PrintWriter csd;
  String file_no_ext;
  String[] options = new String[1];
  int sample_rate = 44100;
  int samples_per_control = 10;
  int channels = 2;
  
  
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
    csd.println("<CsOptions>");
    for(int i = 0; i < options.length; i++){
      csd.println(options[i]);
    }
    csd.println("</CsOptions>");
  }
  
  // allows you to set a new option before writing them to the file
  void new_option(String new_opt){
    options = (String[])append(options,new_opt);
  }
    
  void start_orc(){
    csd.println("<CsInstruments>");
    csd.println(); //for readability
    csd.println("sr = " + sample_rate);
    csd.println("ksmps = " + samples_per_control);
    csd.println("nchnls = " + channels);
    csd.println("0dbfs = 1");
  }
  
  void end_orc(){
    csd.println("</CsInstruments>");
  }
  
  void set_channels(int nchans){
    channels = nchans;
    if(channels < 1){
      println("Number of channels can't be zero or less.");
      println("So, it will be set to mono.");
      channels = 1;
    }
  }
  
  void set_sample_rate(int srate){
    sample_rate = srate;
    if(sample_rate <= 0){
      println("Sample rate can't be zero or less. Resetting to default 44.1 kHz.");
      sample_rate = 44100;
    }
  }
  
  void start_simple_oscs(int len){
    csd.println();
    for(int i = 1; i <= len; i++){
      csd.println("ga" + i + " init 0");
    }
    csd.println();
  }
  
}