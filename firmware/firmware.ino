// config
const int potLo   = 0;
const int potHi   = 725;
const int minYear = 1909;
const int maxYear = 2016;

// inputs
const int yearSelector        = A2;
const int registerA_latchPin  = 2;
const int registerA_clockPin  = 3;
const int registerA_dataPin   = 4;
const int registerB_latchPin  = 5;
const int registerB_clockPin  = 6;
const int registerB_dataPin   = 7;

// set a default year and retain
int year      = minYear;
int lastYear  = 0;

// create an array that translates decimal numbers into
// an appropriate byte for sending to the shift register
int byteConversionTable[] = {
  0,128,64,192,32,160,96,224,16,144,
  8,136,72,200,40,168,104,232,24,152,
  4,132,68,196,36,164,100,228,20,148,
  12,140,76,204,44,172,108,236,28,156,
  2,130,66,194,34,162,98,226, 18,146,
  10,138,74,202,42,170,106,234,26,154,
  6,134,70,198,38,166,102,230,22,150,
  14,142,78,206,46,174,110,238,30,158,
  1,129,65,193,33,161,97,225,17,145,
  9,137,73,201,41,169,105,233,25,153
 };


// setpu the serial device and potentiometer
void setup() {
  pinMode(yearSelector,       INPUT);
  pinMode(registerA_latchPin, OUTPUT);
  pinMode(registerA_clockPin, OUTPUT);
  pinMode(registerA_dataPin,  OUTPUT);
  pinMode(registerB_latchPin, OUTPUT);
  pinMode(registerB_clockPin, OUTPUT);
  pinMode(registerB_dataPin,  OUTPUT);

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

  if(lastYear != year){
    // update the nixie tubes
    updateShiftRegister();

    // broadcast the string to connected devices
    String yearString = String(year);
    Serial.print(yearString);

    // update
    lastYear = year;
  }
  
  // don't flood
  delay(100);
}


void updateShiftRegister(){
  // get the first 2 digits and update the A shift register
  int century = year/100;
  byte centuryByte = byteConversionTable[century];
  digitalWrite(registerA_latchPin, LOW);
  shiftOut(registerA_dataPin, registerA_clockPin, LSBFIRST, centuryByte);
  digitalWrite(registerA_latchPin, HIGH);

  // get the second 2 digits and update the B shift register
  int years = year - century*100;
  byte yearByte = byteConversionTable[years];
  digitalWrite(registerB_latchPin, LOW);
  shiftOut(registerB_dataPin, registerB_clockPin, LSBFIRST, yearByte);
  digitalWrite(registerB_latchPin, HIGH);
}
