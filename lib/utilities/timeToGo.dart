// speed in km/h, distance in meters, time returned in minutes
int timeToGo (int speed, double distance){
  int time = ((distance/speed)*60/1000).round();
  if (time == 0){
    return 1;
  }
  else{
    return time;
  }
}