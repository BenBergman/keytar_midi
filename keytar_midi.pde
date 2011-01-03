#define COLS 6
#define ROWS 9
#define START_KEY 36

int column[COLS] = {14, 15, 16, 17, 18, 19};
int row[ROWS] = {2, 3, 4, 5, 6, 7, 8, 9, 10};

bool keys[COLS][ROWS];
bool changed[COLS][ROWS];

void setup() {
  Serial.begin(9600);
  //Serial.println("Loading...");
  
  for (byte i = 0; i < COLS; i++) {
    pinMode(column[i], OUTPUT);
    digitalWrite(column[i], HIGH);
  }
  for (byte i = 0; i < ROWS; i++) {
    pinMode(row[i], INPUT);
    digitalWrite(row[i], HIGH); //use built in pull up resistors
  }
  for (int i = 0; i < COLS; i++) {
    for (int j = 0; j < ROWS; j++) {
      keys[i][j] = true;
    }
  }

  //Serial.println("Running");
}

void loop() {
  // Scan through the key matrix
  for (int i = 0; i < COLS; i++) {
    digitalWrite(column[i], LOW);
    for (int j = 0; j < ROWS; j++) {
      // has key changed?
      bool key = digitalRead(row[j]);
      if (key != keys[i][j]) {
        //key has changed
        keys[i][j] = !keys[i][j];
        changed[i][j] = true;
      } else {
        changed[i][j] = false;
      }
    }
    digitalWrite(column[i], HIGH); //disable previous column before enabling next
  }

  // Display key changes
  // Note that the loop order is reversed to accommodate proper key order
  // - NOTE: might want to use this section to make a 1D key array
  int index = 0;
  for (int j = 0; j < ROWS; j++) {
    for (int i = 0; i < COLS; i++) {
      if (changed[i][j]) {
   //     Serial.print(index);
        if (keys[i][j]) {
    //      Serial.print(" is up\n");
          noteOn(0x90, START_KEY + index, 0x00);
        } else {
    //      Serial.print(" is down\n");
          noteOn(0x90, START_KEY + index, 0x45);
        }
      }
      index++;
    }
  }
}

//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are  less than 127:
void noteOn(int cmd, int pitch, int velocity) {
  Serial.print(cmd, BYTE);
  Serial.print(pitch, BYTE);
  Serial.print(velocity, BYTE);
}
