//import java.util.Date;
import java.text.SimpleDateFormat;

//TODO calculer les milisecondes entre chaque captation de Google

void convert_UTC_to_INT(String timestampMs){
  String timestamp = timestamp_to_UTC(timestampMs); 
  String[] m = match(timestamp, "^(\\d{4})(\\d{2})(\\d{2}):(\\d{2}):(\\d{2}):(\\d{2})\\.(\\d{3})$");
    
  int year = int(m[1]);
  int month = int(m[2]);
  int day = int(m[3]);
    
  int hours = int(m[4]);
  int minutes = int(m[5]);
  int seconds = int(m[6]);
  int millisecs = int (m[7]);
    
  println("date:"+day+"/"+month+"/"+year+" heure:"+hours+" minutes:"+minutes+" seconds:"+seconds+" millisecs:"+millisecs);
}

String timestamp_to_UTC(String timestampMs) {
  long timestamp = Long.parseLong(timestampMs);
  try {
    String date = new SimpleDateFormat("yyyyMMdd:HH:mm:ss.SSS").format(timestamp); 
    return date;
  }
  catch (Exception e) {
    return "Unknow Date Format";
  } 
}