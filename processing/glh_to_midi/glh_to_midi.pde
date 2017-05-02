/* ----------------------------------------------------------------------------------------------------
 * Google Position History to Midi, 2017
 * Update: 02/05/17
 *
 * V0.1
 * Written by Bastien DIDIER
 *
 * ----------------------------------------------------------------------------------------------------
 */

import themidibus.*; //Import the library
MidiBus MidiBus; // The MidiBus

JSONArray GooglePositionHistory;

int tempo = 100;

String     timestampMs = "1489432985771";
String lastTimestampMs = "1489432985771";

int latlong_min = 555555555;
int latlong_max = 444444444;

void setup() {
  size(400, 400);
  background(0);
  
  /********BUS MIDI*************/
  //MidiBus.list();
  MidiBus = new MidiBus(this, -1, "Bus 1");
  
  //TODO Init GUI
  
  Position_to_midi();
}

void loop(){
  //TODO Update GUI when .json is loaded
}

void Position_to_midi(){
  GooglePositionHistory = loadJSONArray("gph2.json");

  for (int i = 0; i < GooglePositionHistory.size(); i++) {
    
    JSONObject locations = GooglePositionHistory.getJSONObject(i); 

    timestampMs = locations.getString("timestampMs");
    
    int latitude = locations.getInt("latitudeE7");
    int longitude = locations.getInt("longitudeE7");
    
    int accuracy = locations.getInt("accuracy");
    
    /*********************************/

    int latlong = latitude - longitude;
    
    if(latlong < 0){
      latlong = -latlong;
    }
    
    /*********************************/
    
    if(latlong_min > latlong){
      latlong_min = latlong;
    }
    if(latlong_max < latlong){
      latlong_max = latlong;
    }
    
    float latlong_to_midi = map(latlong, latlong_min, latlong_max, 0, 127);

    /*********************************/
    
    //     Channel, Pitch               , velocity   , delay             
    toMidi(      2, int(latlong_to_midi), accuracy*10, processTimestamp(timestampMs, lastTimestampMs));
    
    //println(accuracy + ", " + timestampMs + " , " + latitude + ", " + longitude);
  }
  lastTimestampMs = timestampMs;
}