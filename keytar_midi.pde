#define COLS 6
#define ROWS 9

int column[COLS] = {14, 15, 16, 17, 18, 19};
int row[ROWS] = {2, 3, 4, 5, 6, 7, 8, 9, 10};

bool keys[ROWS*COLS];

void setup() {
  Serial.begin(9600);
  Serial.println("Loading...");
  
  for (byte i = 0; i < COLS; i++) {
    pinMode(column[i], OUTPUT);
    digitalWrite(column[i], HIGH);
  }
  for (byte i = 0; i < ROWS; i++) {
    pinMode(row[i], INPUT);
    digitalWrite(row[i], HIGH); //use built in pull up resistors
  }
  for (int i = 0; i < ROWS*COLS; i++) {
    keys[i] = false;
  }

  Serial.println("Running");
}

bool pressed = false;
void loop() {
  /*
  for (byte i = 0; i < ROWS; i++) {
    //turn off last row
    digitalWrite(row[(i-1)%ROWS], LOW);
    
    //set next row high
    digitalWrite(row[i], HIGH);
    
    //check for key presses
    // note: may need pull down resistors
    
  }
  */

  // Scan through the key matrix
  for (int i = 0; i < COLS; i++) {
    digitalWrite(column[i], LOW);
    for (int j = 0; j < ROWS; j++) {
      // has key changed?
      bool key = digitalRead(row[j]);
      int index = (i*ROWS) + j; // the current key index
      if (key != keys[index]) {
        //key has changed
        keys[index] = !keys[index];
        Serial.print(index);
        if (key) {
          Serial.print(" is up\n");
        } else {
          Serial.print(" is down\n");
        }
      }
    }
    digitalWrite(column[i], HIGH); //disable previous column before enabling next
  }


  /*
  pinMode(column[1], OUTPUT);
  pinMode(row[1], INPUT);
  digitalWrite(row[1], HIGH);

  digitalWrite(column[1], LOW);
  bool key = digitalRead(row[1]);
  if (key != pressed) {
    pressed = key;
    Serial.println(pressed);

  }
  */

}
