/* ////////////////////////////////////////////////////////////////////////////
** File:      IMUDisp.pde              */
 String VerCon = new String ("IMUDisp   0.9.5 - 02-2013"); //---
/* Author:    Guido Ottaviani-->guido@guiott.com<--
** Description: UDB4 IMU control board remote display for testing
** the original idea for the gauge graphic is on this site: 
** http://angela.homelinux.net:8001/code.html

-------------------------------------------------------------------------------
** Compatible with UDB4 board
-------------------------------------------------------------------------------
Copyright 2013 Guido Ottaviani
guido@guiott.com

    IMUDisp is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IMUDisp is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with ImuConsole.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------    
/////////////////////////////////////////////////////////////////////////////*/
import processing.serial.*;

PFont letters;
PFont mono24;
PFont mono48;
PFont mono36;

// UDB4 IMU parameters
int Lat_gps;
int Lon_gps;
int Alt_gps;
int Sog_gps;
int Cog_gps;
int Week_no;
int Tow;
int Hdop;
int Svs;
int[] Rmat = new int[9]; 
int Cpu_load;

int Year;
int Month;
int Day;
int Hours;
int Minutes;
float Seconds;
Float Sec = new Float(0);

String[] SerialList = new String[0];  // declare an empty string for serial ports list 
Serial RS232Port;
Serial ArduinoPort;

int RS232ComPort = 99;
int RS232Bps;
// it will be set false after RS232 configuration to start real communication
boolean RS232Flag = false;
String RxErrorText = new String ("--RX OK--");
char RxErrorExpected;
char RxErrorFound;
int RxErrorDispTime = 0;
int[] RxBuff = new int[256];
int Err = 0;
int HeadLen = 4;    // RX-TX header length
byte[] TxBuff = new byte[144];  // Transmission buffer
int TxHeadLen = 4;             // TX header lenght
int[] TxIntValue = new int[256]; // int value buffer
int TxPeriod = 500;
int TxTimer;
boolean BlinkFlag;
boolean TxFlag = false;

int[] RxBuffA = new int[256];

boolean ArduinoFlag = false;
String ArduRxErrorText = new String ("-");

int i = 0;

 float PitchRad=0;  
 float PitchDeg=0;         
 float RollRad=0;
 float RollDeg=0;
 float YawRad=0;
 float YawDeg=0;

 int CircleH = 150;
 int Xh;
 int Yh;
 
 int Gray=150;

 // Compass gauge parameters
 int CmHorX; // X Starting point for compass frame 
 int CmHorY; // Y Starting point for compass frame
 
 // Artificial Horizon gauge parameters
 PGraphics HorizonArea;
 int HA_X, HA_Y;
 int HA_WIDTH = 256, HA_HEIGHT = 256;
 int FrHorX; // X Starting point for artificial horizon frame 
 int FrHorY; // Y Starting point for artificial horizon frame
 int CenterX = HA_WIDTH / 2;
 int CenterY = HA_HEIGHT / 2;
 int SizeX = 600;
 int SizeY = 300;
 
 int YawDes; 
 int VelDes;
 
 float PosXmes;  // current X position coordinate
 Float PosX = new Float(0);

 float PosYmes;  // current Y position coordinate
 Float PosY = new Float(0);

 int[] VelInt = new int[4];  // speed in mm/s as an integer for all the wheels
 int[] ADCValue = new int[4];// 64 sample average ADC also for slave
 int stasis_err;   // number of times imu and wheels very different
 int stasis_alarm; // signal too many stasis errors
    
 int FrameCount = 0;

/*/////////////////////////////////////////////////////////////////////////////*/
void setup()
{
 size(1024 , 768, P3D);
 frameRate(10);

 // Compass gauge parameters
 CmHorX = width-280;    // X Starting point
 CmHorY = height-280;   // Y Starting point
 
 // Artificial Horizon gauge parameters
 FrHorX = 5;          // X Starting point change this to relocate the gauge
 FrHorY = height-280;   // Y Starting point
 HA_X=FrHorX;  
 HA_Y=FrHorY+20;
 
 // Create a new graphical context
 HorizonArea = createGraphics(HA_WIDTH, HA_HEIGHT, P2D);
 HorizonArea.beginDraw();
 HorizonArea.background(0,0);
 HorizonArea.endDraw();
 
 Xh=-width/2+CircleH/2;
 Yh=height/2-CircleH/2;

 // Load the font that will be used for the N,E,S,W markings
 letters = loadFont("SansSerif-24.vlw");
 mono24 = loadFont("AndaleMono-24.vlw");
 mono48 = loadFont("AndaleMono-48.vlw");
 mono36 = loadFont("AndaleMono-36.vlw");

 
i=0;
println("--------  valid COMM ports are:");

while(i< Serial.list().length)
{
  SerialList = (append(SerialList, Serial.list()[i]));
  print(i);
  print("  ");
  println(Serial.list()[i]);
  i++;
}
   
//********************* Try init Arduino ********************* 
ArduinoPort = new Serial(this, "/dev/tty.usbserial-A700ejZq", 57600);
 try
 { 
      ArduinoPort.write(0);
      ArduinoFlag = true;          // turn ON Arduino sending
  }
  catch(Exception e)    // not a valid COM port
  {
      println("Arduino not ready");
      ArduinoFlag = false;          // turn OFF Arduino sending
      ArduRxErrorText= "-NO Joy-";
  } 

//*********************** Try init RS232 ********************** 
RS232Port = new Serial(this, "/dev/tty.usbserial-A20e27AC", 57600);
 try
 { 
      RS232Port.write(0);
      RS232Flag = true;          // turn ON IMU sending
  }
  catch(Exception e)    // not a valid COM port
  {
      println("IMU not ready");
      RS232Flag = false;         // turn OFF IMU sending
  }  
}
  
/*/////////////////////////////////////////////////////////////////////////////*/

  
void draw() 
{  
  smooth(8); // not for Processing 1.5
  
  background(Gray);
  
  // Update display
  image(HorizonArea, HA_X, HA_Y);
  
  if(ArduinoFlag)
  {  
    TxArduinoCmd('d');  // ask data
    if(RxArduinoData('d', 12))
    {
      YawDes = (Int16toint32(((RxBuffA[8] << 8) + (RxBuffA[9]))))*180/511-180;   
      VelDes = (511-(Int16toint32(((RxBuffA[4] << 8) + (RxBuffA[5])))))*1200/511;
      ArduRxErrorText= "-RX OK-";
    }
  }

  // communication procedure with UDB4 board using protocol described here:
  // http://www.guiott.com/Rino/CommandDescr/Protocol.htm
  
  if(RS232Flag)
  {
    FrameCount++;
    if((FrameCount % 3) == 0) // every 3 cycle (0.3 seconds) ask for current and speed details
    {
      TxData(0, 'b', 0, 3);  // ask for time parameters
      if (RxData('b', 10))
      {// two bytes -> int16
         // four bytes -> int32
         
        // current X position coordinate
        PosXmes = PosX.intBitsToFloat((RxBuff[HeadLen] << 24) + (RxBuff[HeadLen+1] << 16) + (RxBuff[HeadLen+2] << 8) + (RxBuff[HeadLen+3])); // MSB first
        // current Y position coordinate
        PosYmes = PosY.intBitsToFloat((RxBuff[HeadLen+4] << 24) + (RxBuff[HeadLen+5] << 16) + (RxBuff[HeadLen+6] << 8) + (RxBuff[HeadLen+7])); // MSB first
        VelInt[0] = Int16toint32(((RxBuff[HeadLen+8] << 8) + (RxBuff[HeadLen+9])));
        VelInt[1] = Int16toint32(((RxBuff[HeadLen+10] << 8) + (RxBuff[HeadLen+11])));
        VelInt[2] = Int16toint32(((RxBuff[HeadLen+12] << 8) + (RxBuff[HeadLen+13])));
        VelInt[3] = Int16toint32(((RxBuff[HeadLen+14] << 8) + (RxBuff[HeadLen+15])));
        ADCValue[0] = Int16toint32(((RxBuff[HeadLen+16] << 8) + (RxBuff[HeadLen+17])));
        ADCValue[1] = Int16toint32(((RxBuff[HeadLen+18] << 8) + (RxBuff[HeadLen+19])));
        ADCValue[2] = Int16toint32(((RxBuff[HeadLen+20] << 8) + (RxBuff[HeadLen+21])));
        ADCValue[3] = Int16toint32(((RxBuff[HeadLen+22] << 8) + (RxBuff[HeadLen+23])));      
        stasis_err  = Int16toint32(RxBuff[HeadLen+24]); // number of times imu and wheels very different
        stasis_alarm= Int16toint32(RxBuff[HeadLen+25]); // signal too many stasis errors    
      }     
    }
    
    if((FrameCount % 10) == 0)// every 10 cycle (1 second) ask for GPS time
    {// every 3 * 10 = 30 seconds ask both
      TxData(0, 'T', 0, 3);  // ask for time parameters
      if (RxData('T', 10))
      {// two bytes -> int16
         // four bytes -> int32
        Year = Int16toint32(((RxBuff[HeadLen] << 8) + (RxBuff[HeadLen+1])));
        Month = Int16toint32(RxBuff[HeadLen+2]);
        Day = Int16toint32(RxBuff[HeadLen+3]);
        Minutes = Int16toint32(RxBuff[HeadLen+4]);
        Hours = Int16toint32(RxBuff[HeadLen+5]);
        Seconds = Sec.intBitsToFloat((RxBuff[HeadLen+6] << 24) + (RxBuff[HeadLen+7] << 16) + (RxBuff[HeadLen+8] << 8) + (RxBuff[HeadLen+9])); // MSB first
      }   
    }
  
    TxData(0, 'K', 0, 3);  // ask for all parameters every 0.1 seconds
    if (RxData('K',43))
    {// two bytes -> int16
     // four bytes -> int32
     
     Lat_gps=(RxBuff[HeadLen] << 24) + (RxBuff[HeadLen+1] << 16) + (RxBuff[HeadLen+2] << 8) + (RxBuff[HeadLen+3]); // MSB first
     Lon_gps=(RxBuff[HeadLen+4] << 24) + (RxBuff[HeadLen+5] << 16) + (RxBuff[HeadLen+6] << 8) + (RxBuff[HeadLen+7]);
     Alt_gps=(RxBuff[HeadLen+8] << 24) + (RxBuff[HeadLen+9] << 16) + (RxBuff[HeadLen+10] << 8) + (RxBuff[HeadLen+11]); 
     Sog_gps=Int16toint32(((RxBuff[HeadLen+12] << 8) + (RxBuff[HeadLen+13])));
     Cog_gps=Int16toint32(((RxBuff[HeadLen+14] << 8) + (RxBuff[HeadLen+15])));
     Week_no=Int16toint32(((RxBuff[HeadLen+16] << 8) + (RxBuff[HeadLen+17])));
     Tow=(RxBuff[HeadLen+18] << 32) + (RxBuff[HeadLen+19] << 16) + (RxBuff[HeadLen+20] << 8) + (RxBuff[HeadLen+21]); 
     Hdop=RxBuff[HeadLen+22];
     Svs=RxBuff[HeadLen+23];
     Rmat[0]=Int16toint32(((RxBuff[HeadLen+24] << 8) + (RxBuff[HeadLen+25])));
     Rmat[1]=Int16toint32(((RxBuff[HeadLen+26] << 8) + (RxBuff[HeadLen+27])));
     Rmat[2]=Int16toint32(((RxBuff[HeadLen+28] << 8) + (RxBuff[HeadLen+29])));
     Rmat[3]=Int16toint32(((RxBuff[HeadLen+30] << 8) + (RxBuff[HeadLen+31])));
     Rmat[4]=Int16toint32(((RxBuff[HeadLen+32] << 8) + (RxBuff[HeadLen+33])));
     Rmat[5]=Int16toint32(((RxBuff[HeadLen+34] << 8) + (RxBuff[HeadLen+35])));
     Rmat[6]=Int16toint32(((RxBuff[HeadLen+36] << 8) + (RxBuff[HeadLen+37])));
     Rmat[7]=Int16toint32(((RxBuff[HeadLen+38] << 8) + (RxBuff[HeadLen+39])));
     Rmat[8]=Int16toint32(((RxBuff[HeadLen+40] << 8) + (RxBuff[HeadLen+41])));
     Cpu_load=RxBuff[HeadLen+42];
    
    
        /*
         print("Lat: ");
         print(Lat_gps);
         print("  Long: ");
         print(Lon_gps);
         print("  Alt: ");
         print(Alt_gps);
         print("  Speed: ");
         print(Sog_gps);  
         print("  Dir: ");
         print(Cog_gps);
         print("  Week: ");
         print(Week_no);  
         print("  Time of week: ");
         print(Tow);   
         print("  HDOP: ");
         print(Hdop);  
         print("  Satellites: ");
         print(Svs);  
         print("  Rmat 0: ");
         print(Rmat[0]);  
         print("  Rmat 1: ");
         print(Rmat[1]);   
         print("  Rmat 2: ");
         print(Rmat[2]);            
         print("  Rmat 3: ");
         print(Rmat[3]);                 
         print("  Rmat 4: ");
         print(Rmat[4]);             
         print("  Rmat 5: ");
         print(Rmat[5]);  
         print("  Rmat 6: ");
         print(Rmat[6]);   
         print("  Rmat 7: ");
         print(Rmat[7]);            
         print("  Rmat 8: ");
         println(Rmat[8]);                   
        */ 
   
        PitchRad = asin(Rmat[7] / 16384.0); // RAD
        PitchDeg = PitchRad / (2*PI) * 360;
        RollRad = asin(Rmat[6] / 16385.0);
        RollDeg = RollRad / (2*PI) * 360;
        // Allow for inverted flight
        if (Rmat[8] < 0)
        {
          RollDeg = 180 - RollDeg;
          RollRad = PI - RollRad;
        }
        
        // Calcuate our heading from Rmat readings.
        YawRad = atan2(- Rmat[1] , Rmat[4]);
        YawDeg = (YawRad / (2 * PI)) * 360;
    }
  } 
  /*
  // just for debug. Simulation of navigation values with the mouse movement 
  float newX = map(mouseX, 0, 300, -150, 150);
  PitchDeg = height% 360-mouseY+180;
  PitchRad=radians(PitchDeg);
  RollDeg = newX % 360;
  RollRad=radians(RollDeg);
  float CompassX = map(mouseX, 0,300, -180,180);
  YawDeg = CompassX % 360;
  YawRad=radians(YawDeg);
  // println("Pitch = " + PitchDeg + "  Roll = " + RollDeg + "  Yaw = " + YawDeg);
  // just for debug. Comment out the above lines for real job
  */

  movingHorizon(PitchDeg, RollDeg);
  frameHoriz();
  compass(YawDeg);
  DispText(PitchDeg, RollDeg,YawDeg);
  Box3D();
}
