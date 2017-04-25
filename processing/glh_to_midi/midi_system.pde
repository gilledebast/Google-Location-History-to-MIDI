void toMidi(int channel, int pitch, int velocity, int delay) {
  MidiBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  delay(delay);
  MidiBus.sendNoteOff(channel, pitch, velocity); // Send a Midi noteOff
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}