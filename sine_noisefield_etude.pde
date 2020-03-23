// various studies in how I can use a Perlin noise field to play with audio parameters

PrintWriter text;
float amp, pitch;

float dur = 20.0;

float root = 152.74; // Eb3 in A=432

float krate = 60.0 / root;

void setup(){
  text = createWriter("slowVibe.txt");
  slowVibe(dur,krate);
  text.close();
  text = createWriter("scaleDeg.txt");
  scaleDeg(root,dur,krate);
  text.close();
  text = createWriter("bothFuncs.txt");
  bothFuncs(root,dur,krate);
  text.close();
  println("Done.");
}

/********** functions to move through the noisefield and generate score ************/

// maps parameters to the amplitude and pitch drift 
void slowVibe(float dur, float krate){
  float xnoise = random(10);
  float ynoise = random(10);
  float znoise = random(10);
  text.println("i2 " + "0.0 " + dur);
  for(float secs = 0.000; secs <= dur; secs += krate){
    amp = noise(xnoise + 0.01,ynoise,znoise);
    pitch = map(noise(xnoise,ynoise + 0.01,znoise),0,1,-20,20);
    text.println("i1 " + secs + " " + krate + " " + amp + " " + (root + pitch));
    znoise += 0.01;
  }
}

// maps parameters to the note duration and scale degree
void scaleDeg(float root, float dur, float krate){
  float[] notes = new float[7];
  float xnoise = random(10);
  float ynoise = random(10);
  float znoise = random(10);

  
  notes[0] = root;
  notes[1] = root * (9.0/8.0);
  notes[2] = root * (5.0/4.0);
  notes[3] = root * (4.0/3.0);
  notes[4] = root * (3.0/2.0);
  notes[5] = root * (5.0/3.0);
  notes[6] = root * (15.0/8.0);
  
  float varispeed = krate;
  int degree = 0;
  amp = 0.5;
  
  text.println("i2 " + "0.0 " + dur);
  for(float secs = 0.000; secs <= dur; secs += varispeed){
    varispeed = map(noise(xnoise + 0.01,ynoise,znoise),0,1,krate*0.5,krate*4);
    degree = (int)map(noise(xnoise,ynoise + 0.01,znoise),0,1,0.0,6.9);
    text.println("i1 " + secs + " " + varispeed + " " + amp + " " + notes[degree]);
    znoise += 10;
  }
}

// does both functions with small edits
void bothFuncs(float root, float dur, float krate){
  float[] notes = new float[7];
  float xnoise = random(10);
  float ynoise = random(10);
  float znoise = random(10);

  
  notes[0] = root;
  notes[1] = root * (9.0/8.0);
  notes[2] = root * (5.0/4.0);
  notes[3] = root * (4.0/3.0);
  notes[4] = root * (3.0/2.0);
  notes[5] = root * (5.0/3.0);
  notes[6] = root * (15.0/8.0);
  
  float varispeed = krate;
  int degree = 0;
  float accel = 0.01;
  
  float semitone = (root * 2.0) - (notes[6]);
  
  text.println("i2 " + "0.0 " + dur);
  for(float secs = 0.000; secs <= dur; secs += varispeed){
    varispeed = map(noise(xnoise + 0.01,ynoise,znoise),0,1,krate*0.5,krate*4);
    degree = (int)map(noise(xnoise,ynoise + accel,znoise),0,1,0.0,6.9);
    amp = noise(xnoise - 0.01,ynoise,znoise);
    pitch = map(noise(xnoise,ynoise - 0.01,znoise),0,1,-semitone,semitone);
    text.println("i1 " + secs + " " + varispeed + " " + amp + " " + (notes[degree] + pitch));
    znoise += 0.01;
    accel += 10;
  }
}
