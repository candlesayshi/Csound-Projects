class csdWriter {
  PrintWriter csd;
  String file_no_ext;
  String[] options = new String[1];
  
  // automatically appends csd to the end of the filename
  csdWriter(String filename){
    String newcsd = filename + ".csd";
    file_no_ext = filename;
    csd = createWriter(newcsd);
    options[0] = "-o " + file_no_ext + ".wav -W";
  }
  
  // sets up
  void init_csd(){
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
  
  void new_option(String new_opt){
    options = (String[])append(options,new_opt);
  }
    
  
}