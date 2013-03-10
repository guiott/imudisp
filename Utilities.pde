

/*-----------------------------------------------------------------------------*/  
int RangeCheckInt(String Data, int Min, int Max)
{
    int IntNum = 0;
    if (Data.length() != 0)
    {
      IntNum = Integer.parseInt(Data);
      if (IntNum < Min) IntNum = Min;
      if (IntNum > Max) IntNum = Max;
    }
    return IntNum;
}

/*-----------------------------------------------------------------------------*/  
float RangeCheckFloat(String Data, float Min, float Max)
{
    float FloatNum = 0;
    if (Data.length() != 0)
    {
      FloatNum = Float.parseFloat(Data);
      if (FloatNum < Min) FloatNum = Min;
      if (FloatNum > Max) FloatNum = Max;
      TxFlag = true;
    }
    return FloatNum;
}

/*-----------------------------------------------------------------------------*/
int Int16toint32 (int Int16)
{
// data coming from micro are in 16 bit int, needs to be converted in 32 bit int
        if (Int16 > 32768)
        {
          Int16 -= 65536;  
        }
        
        return Int16;
}

/*-----------------------------------------------------------------------------*/
  void Bar(float Deg)
  {
    pushMatrix();
    rectMode(CENTER);
    strokeWeight(1);
    stroke(255,255,255);
    fill(255,255,0);
    translate(Xh, Yh);
    rotate(radians(Deg));
    rect(0,0,CircleH,5);
    popMatrix();
  }  
  
  /*-----------------------------------------------------------------------------*/
  void Box3D()
  {
    pushMatrix();
    translate(width/2, height/2-60,200);
    rotateX(PitchRad+PI/2);
    rotateZ(YawRad);
    rotateY(RollRad);
    fill(0,255,0);
    stroke(0);
    strokeWeight(5);
    box(200,350,20);
    popMatrix();
  }

  /*-----------------------------------------------------------------------------*/  
  void DispText(float Pitch, float Roll, float Yaw)
  {
    int Centre=width/2 + 30;

    //-----------------IMU
    fill(255, 0, 0);

    textFont(mono36);
    if(RS232Flag)
    {
      text("IMU", width/2, height-60);
    }
    else
    {
      text("- NO IMU-", width/2, height-60);
    }
    
    textFont(mono24);
    textAlign(CENTER);
    
    text("Pitch:" + (int)Pitch, width/2-130, height-20);
    text("Roll:" + (int)Roll, width/2+130, height-20);
    text("Yaw:" + (int)Yaw, width/2, height-20);
    
     //-----------------dsNav
    fill(0, 0, 255);

    textFont(mono36);
    textAlign(CENTER);
    text("dsNAV", width/2, height-260);
    
    textFont(mono24);
    
    text("FR" , Centre-125, height-225);
    text("FL" , Centre-25, height-225);
    text("RR" , Centre+75, height-225);
    text("RL" , Centre+175, height-225); 
   
    text(VelInt[0] , Centre-125, height-200);
    text(VelInt[1] , Centre-25, height-200);
    text(VelInt[2] , Centre+75, height-200);
    text(VelInt[3] , Centre+175, height-200);
    
    text(ADCValue[0] , Centre-125, height-175);
    text(ADCValue[1] , Centre-25, height-175);
    text(ADCValue[2] , Centre+75, height-175);
    text(ADCValue[3] , Centre+175, height-175);
    
    text(PosXmes , Centre-60, height-150);
    text(PosYmes , Centre-60, height-125);

    textAlign(LEFT);
    text("Speed:", Centre-260, height-200);
    text("Curr.:", Centre-260, height-175);
    text("Pos X:", Centre-260, height-150);
    text("Pos Y:", Centre-260, height-125);

    textFont(mono36);
    text("Slipp.", width-160, 300);
        
    textFont(mono24);
    text("Count:" + (int)stasis_err, width-160, 330);
    text("Alarm:" + (int)stasis_alarm, width-160, 355);
    
    textFont(mono12);
    text("" + RxErrorText, width-160, 380);
    text("" + Err, width-160, 395);
    
    
    //-----------------Desired values
    fill(0, 255, 0);
    textAlign(LEFT);

    textFont(mono36);
    text("DES", 10, 300);
        
    textFont(mono24);
    text("Yaw:" + (int)YawDes, 10, 330);
    
    if (CommWd > COMM_WD_TMO)
    {// too much time without new data from joystick. Vel value not valid
      fill(255, 0, 0);
    }
    else
    {
      fill(0, 255, 0);
    }
    text("Vel:" + (int)VelDes, 10, 355);
    
    textFont(mono12);
    text(ArduRxErrorText, 10, 380);
    
    //-----------------GPS
    fill(255, 255, 0);
    
    textFont(mono36);
    textAlign(CENTER);
    text("GPS", width/2, 100);
            
    textFont(mono24);
    textAlign(RIGHT);
    
    int DatePos = 210;
    
    text("UTC", DatePos, 20);
    
    if(Day<10)
    {
      text("0"+(int)Day + "-", DatePos-160, 20);
    }
    else
    {
      text((int)Day + "-", DatePos-160, 20);
    }
    
    if(Month<10)
    {
      text("0"+(int)Month + "-", DatePos-120, 20);
    }
    else
    {
      text((int)Month + "-", DatePos-120, 20);
    }
    
    text((int)Year, DatePos-65, 20);
    
    if(Hours<10)
    {
      text("0"+(int)Hours + ":", DatePos+60, 20);
    }
    else
    {
      text((int)Hours + ":", DatePos+60, 20);
    }
      
    if(Minutes<10)
    {
      text("0"+(int)Minutes + ":", DatePos+100, 20);
    }
    else
    {
      text((int)Minutes + ":", DatePos+100, 20);
    }

    textAlign(LEFT);

    if(Seconds<10000)
    {
      text("0"+(int)Seconds/1000, DatePos+100, 20);
    }
    else
    {
      text(""+(int)Seconds/1000, DatePos+100, 20);
    }
    
    textFont(mono36);
    textAlign(CENTER);

    int Mask = 0;
    for(int i = 0; i < 32; i++)
    {
      Mask = SatIdList_gps >> i;
      if((Mask & 1) == 1)
      {
          text("*", width-(15*i+20), 27);
      }
    }  

    textFont(mono12);
    for( i = 0; i < 32; i++)
    {
        text((i+1) % 10, width-(15*i+20), 30);
    }  
    
    textFont(mono24);    
    textAlign(LEFT);
    text("Lat:" + (float)Lat_gps/10000000, 10, 75);
    text("Lon:" + (float)Lon_gps/10000000, 10, 100);
    text("Alt:" + (float)Alt_gps/100, 10, 125);
    text("Vel.:" + (float)Sog_gps/100, width-160, 75);
    text("Dir.:" + (float)Cog_gps/100, width-160, 100);
    text("HDOP:" + (float)Hdop/5, width-160, 125);
    text("HEPE:" + (float)Hepe_gps/100, width-160, 150);
    text("Sat.:" + (int)Svs, width-160, 175);
  
  }

  /*-----------------------------------------------------------------------------*/  
  void DispLed(void)
  {  
  fill(255, 255, 255); 
  textFont(mono12);
  textAlign(CENTER);
  
  text("Send Vel", LedRedX+10, LedRedY-10);
  if(LedRedFlag == 1)
  {
    image(LedRedOn, LedRedX, LedRedY);
  }
  else
  {
    image(LedRedOff, LedRedX, LedRedY);
  }
  
  text("Vel OK", LedGreenX+10, LedGreenY-10);
  if(LedGreenFlag == 1)
  {
    image(LedGreenOn, LedGreenX, LedGreenY);
  }
  else
  {
    image(LedGreenOff, LedGreenX, LedGreenY);
  }

  text("RX", LedYellowX+10, LedYellowY-10);
  if(LedYellowFlag == 1)
  {
    image(LedYellowOn, LedYellowX, LedYellowY);
  }
  else
  {
    image(LedYellowOff, LedYellowX, LedYellowY);
  }
 }
