void frameHoriz()
{
  // This whole void function contains parts that make up the 
  // background and some non moving parts of the artificial horizon
  // the original idea is on this site: http://angela.homelinux.net:8001/code.html

  HorizonArea.beginDraw();

  FrHorX=-22;
  FrHorY=-22;  
  
  // This is the stationary ground that surrounds the artificial horizon
  HorizonArea.fill(183,113,28);
  HorizonArea.strokeWeight(1);
  HorizonArea.stroke(25);  
      
  HorizonArea.beginShape();
  HorizonArea.vertex(FrHorX+25,FrHorY+150);
  HorizonArea.vertex(FrHorX+49,FrHorY+150);
  HorizonArea.bezierVertex(FrHorX+49,FrHorY+180, FrHorX+70,FrHorY+250, FrHorX+150,FrHorY+245);
  HorizonArea.vertex(FrHorX+25,FrHorY+245);
  HorizonArea.endShape();

  HorizonArea.beginShape();
  HorizonArea.vertex(FrHorX+275,FrHorY+150);
  HorizonArea.vertex(FrHorX+250,FrHorY+150);
  HorizonArea.bezierVertex(FrHorX+251,FrHorY+180, FrHorX+230,FrHorY+250, FrHorX+150,FrHorY+245);
  HorizonArea.vertex(FrHorX+275,FrHorY+245);
  HorizonArea.endShape();

  // This is the stationary sky that surrounds the artificial horizon
  HorizonArea.fill(30,143,198);
  HorizonArea.beginShape();
  HorizonArea.vertex(FrHorX+25,FrHorY+150);
  HorizonArea.vertex(FrHorX+49,FrHorY+150);
  HorizonArea.bezierVertex(FrHorX+53, FrHorY+18, FrHorX+246, FrHorY+18, FrHorX+250, FrHorY+150);
  HorizonArea.vertex(FrHorX+275, FrHorY+150);
  HorizonArea.bezierVertex(FrHorX+265, FrHorY+-20, FrHorX+35, FrHorY+-20, FrHorX+25,FrHorY+150);
  HorizonArea.endShape();

  HorizonArea.fill(250);
  HorizonArea.noStroke();
  HorizonArea.triangle(FrHorX+150, FrHorY+50, FrHorX+140, FrHorY+30, FrHorX+160, FrHorY+30); // little white triangle
   
  // The little white lines separating the stationary ground and sky
  HorizonArea.stroke(250);
  HorizonArea.strokeWeight(4);
  HorizonArea.line(FrHorX+25, FrHorY+150, FrHorX+49, FrHorY+150);
  HorizonArea.line(FrHorX+251, FrHorY+150, FrHorX+275, FrHorY+150);
 
  // This is the black reverence marker for the wings
  HorizonArea.strokeWeight(4);
  HorizonArea.fill(25);
  HorizonArea.stroke(25);
  HorizonArea.line(FrHorX+150, FrHorY+150, FrHorX+150, FrHorY+200);
  HorizonArea.triangle(FrHorX+150, FrHorY+200, FrHorX+125, FrHorY+250, FrHorX+175, FrHorY+250);
  
  HorizonArea.noStroke();
  HorizonArea.beginShape();
  HorizonArea.vertex(FrHorX+60, FrHorY+245);
  HorizonArea.vertex(FrHorX+0, FrHorY+300);
  HorizonArea.vertex(FrHorX+300, FrHorY+300);
  HorizonArea.vertex(FrHorX+240, FrHorY+245);
  HorizonArea.endShape(CLOSE);
 
  HorizonArea.stroke(25);
  HorizonArea.beginShape(LINES);
  HorizonArea.vertex(FrHorX+90, FrHorY+150);
  HorizonArea.vertex(FrHorX+125, FrHorY+150);
  HorizonArea.vertex(FrHorX+125, FrHorY+150);
  HorizonArea.vertex(FrHorX+150, FrHorY+170);
  HorizonArea.vertex(FrHorX+150, FrHorY+170);
  HorizonArea.vertex(FrHorX+175, FrHorY+150);
  HorizonArea.vertex(FrHorX+175, FrHorY+150);
  HorizonArea.vertex(FrHorX+210, FrHorY+150);
  HorizonArea.endShape();

  // The black ring separating the moving and stationary parts 
  // of the horizon
  HorizonArea.ellipseMode(CENTER);
  HorizonArea.noFill();
  HorizonArea.stroke(25);
  HorizonArea.strokeWeight(3);
  HorizonArea.ellipse(FrHorX+150, FrHorY+150, 200, 200);

  // This is more frame surrounding the artificial horizon
  HorizonArea.fill(Gray);
  //HorizonArea.stroke(Gray);
  HorizonArea.noStroke();
  HorizonArea.beginShape();
  HorizonArea.vertex(FrHorX+150, FrHorY+22);
  HorizonArea.bezierVertex(FrHorX-16, FrHorY+22, FrHorX+-16, FrHorY+278, FrHorX+150, FrHorY+278);
  HorizonArea.vertex(FrHorX+150, FrHorY+278);
  HorizonArea.vertex(FrHorX+22, FrHorY+278);
  HorizonArea.vertex(FrHorX+22, FrHorY+22);
  HorizonArea.endShape();
 
  HorizonArea.fill(Gray);
  HorizonArea.beginShape();
  HorizonArea.vertex(FrHorX+150, FrHorY+22);
  HorizonArea.bezierVertex(FrHorX+316, FrHorY+22, FrHorX+316, FrHorY+278, FrHorX+150, FrHorY+278);
  HorizonArea.vertex(FrHorX+150, FrHorY+278);
  HorizonArea.vertex(FrHorX+278, FrHorY+278);
  HorizonArea.vertex(FrHorX+278, FrHorY+22);
  HorizonArea.endShape();
  
  // Small black ring separating the stationary ground 
  // from the background
  HorizonArea.ellipseMode(CENTER);
  HorizonArea.noFill();
  HorizonArea.stroke(25);
  HorizonArea.strokeWeight(6);
  HorizonArea.ellipse(FrHorX+150, FrHorY+150, 252, 252);
    
  HorizonArea.endDraw();
}


