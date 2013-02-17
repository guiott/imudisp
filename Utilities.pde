

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
    
    text("FL" , Centre-125, height-225);
    text("FR" , Centre-25, height-225);
    text("RL" , Centre+75, height-225);
    text("RR" , Centre+175, height-225);
   
    text("SFL" , Centre-125, height-200);
    text("SFR" , Centre-25, height-200);
    text("SRL" , Centre+75, height-200);
    text("SRR" , Centre+175, height-200);
    
    text("CFL" , Centre-125, height-175);
    text("CFR" , Centre-25, height-175);
    text("CRL" , Centre+75, height-175);
    text("CRR" , Centre+175, height-175);
    
    textAlign(LEFT);
    text("Speed:", Centre-260, height-200);
    text("Curr.:", Centre-260, height-175);
    
    
    //-----------------Desired values
    fill(0, 255, 0);
    textAlign(LEFT);

    textFont(mono36);
    text("DES", 10, 300);
        
    textFont(mono24);
    text("Yaw:" + (int)YawDes, 10, 330);
    text("Vel:" + (int)VelDes, 10, 355);
    text(ArduRxErrorText, 10, 380);
    
    //-----------------GPS
    fill(255, 255, 0);
    
    textFont(mono36);
    textAlign(CENTER);
    text("GPS", width/2, 70);
    
    textFont(mono24);
    textAlign(RIGHT);
    if(Day<10)
    {
      text("0"+(int)Day + "-", Centre-160, 20);
    }
    else
    {
      text((int)Day + "-", Centre-160, 20);
    }
    
    if(Month<10)
    {
      text("0"+(int)Month + "-", Centre-120, 20);
    }
    else
    {
      text((int)Month + "-", Centre-120, 20);
    }
    
    text((int)Year, Centre-65, 20);
    
    if(Hours<10)
    {
      text("0"+(int)Hours + ":", Centre+40, 20);
    }
    else
    {
      text((int)Hours + ":", Centre+40, 20);
    }
      
    if(Minutes<10)
    {
      text("0"+(int)Minutes + ":", Centre+80, 20);
    }
    else
    {
      text((int)Minutes + ":", Centre+80, 20);
    }

    textAlign(LEFT);

    if(Seconds<10)
    {
      text("0"+(int)Seconds, Centre+80, 20);
    }
    else
    {
      text(""+(int)Seconds, Centre+80, 20);
    }
    
    textAlign(LEFT);
    text("Lat:" + (int)Lat_gps, 10, 75);
    text("Lon:" + (int)Lon_gps, 10, 100);
    text("Alt:" + (int)Alt_gps, 10, 125);
    text("Vel.:" + (int)Sog_gps, width-150, 75);
    text("Dir.:" + (int)Cog_gps, width-150, 100);
    text("Hdop:" + (int)Hdop, width-150, 125);
    text("Sat.:" + (int)Svs, width-150, 150);
  
  }
