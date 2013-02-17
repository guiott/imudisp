void compass(float Yaw)
{
  // This whole void function contains the stuff needed to make the
  // compass and all of its moving bits and pieces
  // the original idea is on this site: http://angela.homelinux.net:8001/code.html

  pushMatrix();
 
  // compass background
  ellipseMode(CENTER);
  fill(50);
  stroke(10);
  strokeWeight(10);
  ellipse(CmHorX+150, CmHorY+150, 248, 248);
 
  // This section draws the dashed lines and the dots on the compass,
  // and rotates them around the "origin".
  translate(CmHorX+150, CmHorY+150);

  rotate(radians(Yaw));
  
  noStroke();
  fill(250);
  int radius = 100;
  for( int degC = 5; degC < 360; degC += 10) //Compass dots
  {
    float angleC = radians(degC);
    float xC = 0 + (cos(angleC)* radius);
    float yC = 0 + (sin(angleC)* radius);
    ellipse(xC, yC, 3, 3);
  }
    
  for( int degL = 10; degL < 370; degL += 10) //Compass lines
  {
    float angleL = radians(degL);
    float x = 0 + (cos(angleL)* 120);
    float y = 0 + (sin(angleL)* 120);
    float x0 = 0 + (cos(angleL)* 95);
    float y0 = 0 + (sin(angleL)* 95);
    stroke(250);
    strokeWeight(3);
    line(x0, y0, x, y);
  }
  
  textAlign(CENTER);
  
  // Draw the letters
  fill(250);
  textFont(letters);
  text("S", 1, -73);
  rotate(radians(90));
  text("W", 0, -73);
  rotate(radians(90));
  text("N", 0, -73);
  rotate(radians(90));
  text("E", 0, -73);
  rotate(radians(90));
  
  // Draw the little orange airplane in the middle of the compass face
  rotate(radians(-Yaw)); //make it stationary
  stroke(234,144,7);
  strokeWeight(5);
  beginShape(LINES);
  vertex(0, -70); vertex(0, -55);
  vertex(0, -55); vertex(-10, -35);
  vertex(-10, -35); vertex(-50, 0);
  vertex(-50, 0); vertex(-50, 13);
  vertex(-50, 13); vertex(-8, 0);
  vertex(-8, 0); vertex(-5, 35);
  vertex(-5, 35); vertex(-23, 50);
  vertex(-23, 50); vertex(-23, 60);
  vertex(-23, 60); vertex(-2, 55);
  vertex(-2, 55); vertex(0, 65);
  vertex(0, -55); vertex(10, -35);
  vertex(10, -35); vertex(50, 0);
  vertex(50, 0); vertex(50, 13);
  vertex(50, 13); vertex(8, 0);
  vertex(8, 0); vertex(5, 35);
  vertex(5, 35); vertex(23, 50);
  vertex(23, 50); vertex(23, 60);
  vertex(23, 60); vertex(2, 55);
  vertex(2, 55); vertex(0, 65);
  endShape();  
  // end airplane drawing
  
  popMatrix();
}
