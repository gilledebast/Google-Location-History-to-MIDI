import themidibus.*; //Import the library
MidiBus MidiBus; // The MidiBus

JSONArray GooglePositionHistory;

float latlong_to_midi;

String     timestampMs = "1489432985771";
String lastTimestampMs = "1489432985771";

//long timestamp = 1489432985771L;

void setup() {
  size(400, 400);
  background(0);
  
  /********BUS MIDI*************/
  //MidiBus.list();
  MidiBus = new MidiBus(this, -1, "Bus 1");

  Position_to_midi();
}

void loop(){
}

void Position_to_midi(){
  GooglePositionHistory = loadJSONArray("gph2.json");

  for (int i = 0; i < GooglePositionHistory.size(); i++) {
    
    JSONObject locations = GooglePositionHistory.getJSONObject(i); 

    timestampMs = locations.getString("timestampMs");
    
    int latitude = locations.getInt("latitudeE7");
    int longitude = locations.getInt("longitudeE7");
    
    int accuracy = locations.getInt("accuracy");
    
    //latlong_to_midi =
    latlong_to_midi = map(latlong_to_midi, 464948000, 464948150, 0, 127);
    
    toMidi(2, int(latlong_to_midi), accuracy*10, processTimestamp(timestampMs, lastTimestampMs));
    
    //println(accuracy + ", " + timestampMs + " , " + latitude + ", " + longitude);
  }
  lastTimestampMs = timestampMs;
}