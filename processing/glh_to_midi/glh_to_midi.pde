import themidibus.*; //Import the library
MidiBus MidiBus; // The MidiBus

JSONArray GooglePositionHistory;
float latlong_to_midi;
int timestampMs;
int lastTimestampMs = 1489432985;

void setup() {
  
  size(400, 400);
  background(0);
  
  //MidiBus.list();
  
  /********BUS MIDI*************/
  MidiBus = new MidiBus(this, -1, "Bus 1");
  
  Position_to_midi();
}

void loop(){
  
}

void toMidi(int channel, int pitch, int velocity, int delay) {
  MidiBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  delay(delay);
  MidiBus.sendNoteOff(channel, pitch, velocity); // Send a Midi noteOff
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void Position_to_midi(){
  GooglePositionHistory = loadJSONArray("gph2.json");

  for (int i = 0; i < GooglePositionHistory.size(); i++) {
    
    JSONObject locations = GooglePositionHistory.getJSONObject(i); 

    //timestampMs = locations.getInt("timestampMs");
    
    int latitude = locations.getInt("latitudeE7");
    int longitude = locations.getInt("longitudeE7");
    
    int accuracy = locations.getInt("accuracy");
    
    latlong_to_midi = map(latlong_to_midi, 464948000, 464948150, 0, 127);
    
    //int midiDelay = (timestampMs - lastTimestampMs)/10000000;
    
    toMidi(2, int(latlong_to_midi), 127, accuracy*10);
    
    println(accuracy + ", " + timestampMs + " , " + latitude + ", " + longitude);
  }
  lastTimestampMs = timestampMs;
}