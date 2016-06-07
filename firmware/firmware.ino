// config
const int potLo   = 5;
const int potHi   = 714;
const int minYear = 1909;
const int maxYear = 2016;

// inputs
const int yearSelector = 2;


// set a default year
int year = minYear;



void setup() {
  pinMode(yearSelector, OUTPUT);
  Serial.begin(9600);
}



void loop() {
  // retrieve the potentiometer value
  int potValue = 0;
  potValue = analogRead(yearSelector);

  // map the potentiometer values to the year values 
  year = map(potValue, potLo, potHi, minYear, maxYear);
  if(year < 1909) year = 1909;
  if(year > 2016) year = 2016;

  // broadcast the string to connected devices
  String yearString = String(year);
  Serial.println(yearString);

  // don't flood
  delay(100);
}
