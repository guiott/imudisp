void movingHorizon(float Pitch, float Roll)
{
  // This is the function containing everything that has to
  // do with the moving parts of the artificial horizon
  // the original idea is on this site: http://angela.homelinux.net:8001/code.html

  HorizonArea.beginDraw();
  HorizonArea.pushMatrix();

  if(Pitch > 180)
  {
    Pitch=180;
  } 
  else if(Pitch < -180)
  {
    Pitch=-180;
  }
  
  if(Roll > 90)
  {
    Roll=90;
  } 
  else if(Roll < -90)
  {
    Roll=-90;
  }
  
  Roll=-Roll;
  
  float PitchY = CenterY-Pitch;

  //sky
  HorizonArea.rectMode(CENTER);

  HorizonArea.fill(30,143,198);
  HorizonArea.noStroke();
  HorizonArea.rect(CenterX, CenterY, HA_WIDTH, HA_HEIGHT); 

  HorizonArea.translate(CenterX, PitchY);
  HorizonArea.rotate(radians(Roll));

  //ground
  HorizonArea.fill(183,113,28);
  HorizonArea.noStroke();
  HorizonArea.translate(0,SizeY/2);
  HorizonArea.rect(0, 0, SizeX, SizeY);
  
  // white line
  HorizonArea.noStroke();
  HorizonArea.fill(255);
  HorizonArea.translate(0,-SizeY/2);
  HorizonArea.rect(0, 0, SizeX, 4);

  HorizonArea.popMatrix();

  // non tilting lines
  strokeWeight(3);
  
  for(int i=-6; i <=6; i++)
  {
    Bar(i, CenterX, (int)PitchY);
  }
 
  HorizonArea.endDraw();
}


void Bar(int Num, int CenterX, int CenterY)
{
    int Gap = 13;  // space between lines
    int Height=2;  // line tickness
    int Diff = 10;  // bar resizing
    int Long = 50; // longest bar
    int Shift = 20;
    
    HorizonArea.rectMode(CENTER);
    HorizonArea.noStroke();
    HorizonArea.fill(255);
    if((Num % 2) == 0)
    {
      Shift = Long+abs(Num)*Diff;
    }
    HorizonArea.rect(CenterX, CenterY-Num*Gap, Shift, Height);
}

