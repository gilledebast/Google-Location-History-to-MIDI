/* ----------------------------------------------------------------------------------------------------
 * Google Position History to Midi, 2017
 * Update: 03/07/17
 *
 * V1.01
 * Written by Bastien DIDIER
 *
 * ----------------------------------------------------------------------------------------------------
 */

import themidibus.*; //Import the library
MidiBus MidiBus; // The MidiBus

JSONArray GooglePositionHistory;
String position_history_file = "gph2.json";

int tempo = 300;

String     timestampMs = "1489432985771";
String lastTimestampMs = "1489432985771";

int note_min = 30;
int note_max = 70; //127

int latlong_min = 555555555;
int latlong_max = 444444444;

float latlong_to_midi;
float last_latlong_to_midi;

/*int day = 0;
int last_day = 1;*/

int process;
int last_process;
int last_latlong;
int count = 1;

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
  GooglePositionHistory = loadJSONArray(position_history_file);

  //for (int i = 0; i < GooglePositionHistory.size(); i++) {
  for (int i = GooglePositionHistory.size()-1; i > 0; i--) {
    
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
    
    //TODO le rendre dynamique à l'échelle d'une journée
    if(latlong_min > latlong){
      latlong_min = latlong;
    }
    if(latlong_max < latlong){
      latlong_max = latlong;
    }
    
    latlong_to_midi = map(latlong, latlong_min, latlong_max, note_min, note_max);

    /*********************************/
    
    if(processTimestamp(timestampMs, lastTimestampMs) > 50){ // ICI ca supprime les petites notes < en dessous de 10ms
      
      process = processTimestamp(timestampMs, lastTimestampMs);
      
      if(process != last_process){
        
        if(int(latlong_to_midi) != last_latlong){
        
          //     Channel, Pitch               , velocity      , delay             
          toMidi(      0, int(latlong_to_midi), accuracy*count, processTimestamp(timestampMs, lastTimestampMs)*count*1); //
          count++;
          
        } else {
          count = 1;
        }
      }
      
      last_process = process;
      last_latlong = int(latlong_to_midi);
    }
    
    //println(accuracy + ", " + timestampMs + " , " + latitude + ", " + longitude);

    /*********************************/
    
    lastTimestampMs = timestampMs;
  }
}