Mover[] movers;
csdWriter csd;

// music source settings
int octaves = int(random(4,9));
float root = random(120.0,240.0);
float song_length = random(180.0,390.0);

float[] notes = getScale(0,0,0);
/* 
arguments (int) : tuning, degrees, quality
tuning: 0 = 12TET, 1 = 5-limit, 2 = Pythagorean
degrees: 0 = pentatonic, 1 = diatonic
quality: 0 = major, 1 = minor
*/

boolean reflect = false; // will cause movers to bounce off the edges of the display
boolean make_vid = false; // saves an image of every frame for the sources to make a video
boolean fade = false; // controls the transparency transition of the movers

float hue_root = random(360), bg_root; // for coloring the tone movers

void setup(){
  //size(1280,1024);
  fullScreen();
  colorMode(HSB,360,100,100);
  if(hue_root > 180){
    bg_root = hue_root - 180;
  } else {
    bg_root = hue_root + 180;
  }
  background(bg_root,23,17);
  frameRate(30);
  
  // set the number of octaves
  while(root * octaves * notes[notes.length - 1] > 10000.0) octaves--;
  
  // setting up the objects
  movers = new Mover[octaves * notes.length];
  for(int i = 0; i < notes.length; i++){
    for(int j = 0; j < octaves; j++){
      float mass = sqrt(root) / (notes[i] * (j + 1));
      float margin = mass * 8.0;
      movers[i*octaves+j] = new Mover(mass,random(margin,width-margin),random(margin,height-margin),root * (notes[i] * (j+1)));
    }
  }
  
  // setting up the Csound document
  csd = new csdWriter("gravity-etude");
  csd.set_channels(1);
  csd.set_ksmps(1470);
  //csd.new_option("-3"); // for 24-bit out
  csd.write_options();
  csd.start_orc();
  
  // make the instruments
  csd.simple_oscs_gk(movers.length);
  
  for(int i = 1; i <= movers.length; i++){
    csd.new_instr(i);
    csd.grav_instr(i,movers[i-1].freq);
    csd.end_instr();
  }
  
  // instrument which controls the others
  csd.new_instr(movers.length + 1);
  csd.control_inst(movers.length);
  csd.end_instr();
  
  // cut the orchestra section
  csd.end_orc();
  
  csd.start_score();
  csd.GEN10(8192);
  csd.add_oscs_to_score(movers.length,song_length);
}

void draw(){
  //background(#2e4340);
  for(int i = 0; i < movers.length; i++){
    for(int j = 0; j < movers.length; j++){
      if(i != j){
        PVector force = movers[j].gravity(movers[i]);
        movers[i].applyForce(force);
      }
    }
    movers[i].update();
    movers[i].display();
  }
  
  // write the score statement
  String[] score_line = new String[movers.length + 3];
  score_line[0] = "i" + (movers.length + 1);
  score_line[1] = nf(frameCount/30.0);
  score_line[2] = nf(1/30.0);
  
  for(int i = 0; i < movers.length; i++){
    float get = movers[i].gravpull();
    float grav = map(get,0.00001,0.01,0.0,1.0);
    score_line[i + 3] = nf(grav / movers.length,1,8);
    println(i + " - " + nf(get,1,8) + " Converted: " + nf(grav,1,8) + " Mass: " + nf(movers[i].mass,1,5) + " Freq: " + movers[i].freq);
  }
  
  // write that score statement
  csd.write_score_statement(score_line);
  
  if(make_vid) saveFrame("frames/####.png");
  
  if(frameCount/30.0 > song_length){
    end_it_all();
  }
}

void keyPressed(){
  if(key == ESC){
    csd.end_score();
    csd.end_writer();
    exit();
  }
  if(key == ENTER){
    saveFrame("frames/screen-####.png");
  }
  if(key == 'f'){
    fade = !fade;
  }
}

void end_it_all(){
  csd.end_score();
  csd.end_writer();
  exit();
}

/********************** scale function **********************/
float[] getScale(int tuning, int degrees, int quality){
  
  float[] scale = new float[0];
  float[] ratios = new float[12];
  
  if(tuning < 0 || tuning > 2){
    println("Error on tuning switch.");
    exit();
  }
  if(degrees < 0 || degrees > 1){
    println("Error on degrees switch");
    exit();
  }
  if(quality < 0 || quality > 1){
    println("Error on quality switch");
    exit();
  }
  
  if(tuning == 0){
    // 12-tone equal temperament
    for(int i = 0; i < ratios.length; i++){
      ratios[i] = pow(2.0,float(i)/12.0);
    }
  } else if (tuning == 1){
    // 5-limit tuning
    float[] temp = {(1.0),(16.0/15.0),(9.0/8.0),(6.0/5.0),(5.0/4.0),(4.0/3.0),(64.0/45.0),(3.0/2.0),(8.0/5.0),(5.0/3.0),(9.0/5.0),(15.0/8.0)};
    ratios = temp;
  } else if  (tuning == 2){
    // Pythagorean Tuning
    float[] temp = {(1.0),(256.0/243.0),(9.0/8.0),(32.0/27.0),(81.0/64.0),(4.0/3.0),(1024.0/729.0),(3.0/2.0),(128.0/81.0),(27.0/16.0),(16.0/9.0),(243.0/128.0)};
    ratios = temp;
  }
  
  if(degrees == 0){
    // pentatonic
    scale = new float[5];
    if(quality == 0){
      // major
      scale[0] = ratios[0];
      scale[1] = ratios[2];
      scale[2] = ratios[4];
      scale[3] = ratios[7];
      scale[4] = ratios[9];
    } else if (quality == 1){
      // minor
      scale[0] = ratios[0];
      scale[1] = ratios[3];
      scale[2] = ratios[5];
      scale[3] = ratios[7];
      scale[4] = ratios[10];
    }
  } else if (degrees == 1){
    // diatonic
    scale = new float[7];
    if(quality == 0){
      // major
      scale[0] = ratios[0];
      scale[1] = ratios[2];
      scale[2] = ratios[4];
      scale[3] = ratios[5];
      scale[4] = ratios[7];
      scale[5] = ratios[9];
      scale[6] = ratios[11];
    } else if (quality == 1){
      // minor
      scale[0] = ratios[0];
      scale[1] = ratios[2];
      scale[2] = ratios[3];
      scale[3] = ratios[5];
      scale[4] = ratios[7];
      scale[5] = ratios[8];
      scale[6] = ratios[10];
    }
  }
  return scale;
}


/*********************** CLASSES ****************************/

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  float mass, size, radius, G;
  float hue, sat, bri;
  float fillalph, linealph, falst, lalst;
  
  float gravVal, freq;
  
  Mover(float m,float x,float y,float f){
    location = new PVector(x,y);
    velocity = PVector.random2D();
    velocity.mult(0);
    acceleration = new PVector(0,0);
    mass = m;
    G = 0.4;
    size = mass * 16;
    radius = size/2.0;
    topspeed = width/2.0;
    gravVal = 0.0;
    freq = f;
    low = (G * mass * 6.0) / sq(1.6);
    high = (G * mass * 0.2) / sq(width/2.0);
    
    // color
    hue = hue_root;
    sat = random(70,94);
    bri = random(50,99);
    
    // alpha values
    falst = random(150,220);
    lalst = random(220,225);
    fillalph = falst;
    linealph = lalst;
    
  }
  
  void applyForce(PVector force){
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }
  
  void update(){
    val = acceleration.mag();
    low = low < val ? low : val;
    high = high > val ? high : val;
    velocity.add(acceleration);
    location.add(velocity);
    velocity.limit(topspeed);
    if(reflect) reflectEdges();
    acceleration.mult(0);
  }
  
  PVector gravity(Mover m){
    PVector force = PVector.sub(location,m.location);
    float distance = force.mag();
    distance = constrain(distance,radius + m.radius,width / 2.0);
    force.normalize();
    float strength = (G * mass * m.mass) / (distance * distance);
    force.mult(strength);
    m.gravVal += force.mag();
    return force;
  }
  
  void display(){
    fill(hue,sat,bri,fillalph);
    stroke(hue,sat,bri/2.0,linealph);
    ellipse(location.x,location.y,size,size);
    if(fade){
      fillalph -= 0.5;
      linealph -= 0.25;
    } else {
      if(fillalph < falst){
        fillalph += 0.25;
      }
      if(linealph < lalst){
        linealph += 0.5;
      }
    }
  }
  
  void reflectEdges(){
    if(location.x < (0 + radius) || location.x > (width - radius)){
      velocity.x *= -1;
    }
    if(location.y < (0 + radius) || location.y > (height - radius)){
      velocity.y *= -1;
    }
  }
  
  float gravpull(){
    float temp = gravVal;
    gravVal = 0.0;
    return temp;
  }
  
}

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
      csd.println("</CsoundSynthesizer>");
      csd.flush();
      csd.close();
    } else {
      println("Score not completed.");
    }
  }
  
   /*********************** functions for a personal project **************************/
  void simple_oscs_gk(int len){
    csd.println();
    csd.println(";global controls for the oscillators' amplitudes");
    for(int i = 1; i <= len; i++){
      csd.println("gk" + i + " init 0");
    }
    csd.println();
  }
  void grav_instr(int num, float freq){
    if(inst_in_progress){
      csd.println("k1 oscil 0.1, " + (freq/1000.0));
      csd.println("a1 oscil " + "gk" + num +", " + freq);
      csd.println("a2 distort a1, (0.1 + k1), 1");
      csd.println("a3 exciter (a2+a1)/2.0, " + (freq/2.0) + ", " + (freq*2.0) + ", 8.0, 5.0 * k1");
      csd.println("a4 flanger a3, a1 * 2.0, k1 * 0.1");
      csd.println("a5 butterlp a1/2.0 + a4/8.0, " + (freq * (3.0/2.0)));
      csd.println("a6 nreverb a5, " + (freq/1000.0) + ", 0.1 + k1");
      csd.println("  out (a6 + a1) / 2.0");
      csd.println();
    } else {
      println("You have to start an instrument first.");
    }
  }
  void GEN10(int table){
    //csd.println("f1 0 " + table + " 10 1");
    csd.println(";function table for waveshaping distortion");
    csd.println("f1 0 " + table + " 10 1 0 0.3 0 0.2");
  }
  void simple_drone_oscs(int num, float freq){
    if(inst_in_progress){
      csd.println("a" + num + " oscil " + "gk" + num +", " + freq);
      csd.println("  out a" + num);
      csd.println();
    } else {
      println("You have to start an instrument first.");
    }
  }
  void control_inst(int num){
    csd.println(";a single instrument that can route the incoming control values to the oscs");
    for(int i = 1; i <= num; i++){
      csd.println("gk" + i + " = " + "p" + (i + 3));
    }
    csd.println();
  }
  void add_oscs_to_score(int num, float len){
    csd.println();
    csd.println(";oscillators play over the whole piece and parameters are adjusted by the other score statements");
    for(int i = 1; i <= num; i++){
      csd.println("i" + i + " " + "0 " + len);
    }
    csd.println();
  }
  
}