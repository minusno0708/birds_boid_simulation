int num = 80;

float[] x  =new float[num+1];
float[] y  =new float[num+1];
float[] r  =new float[num+1];
float[] dx  =new float[num+1];
float[] dy  =new float[num+1];

float[] ctrDirX =new float[num+1];    
float[] ctrDirY =new float[num+1];    
float[] vel =new float[num+1];
float[] velAngle =new float[num+1];
float[] contX =new float[num+1];    
float[] contY =new float[num+1];
float[] avoiX =new float[num+1];    
float[] avoiY =new float[num+1];  
float[] kX =new float[num+1];    
float[] kY =new float[num+1];    

float aveX, aveY, aveAngle, aveVel;
float velX, velY;

void setup() {
  for (int i=0; i<num+1; i++) {
    r[i]     = 10;
    x[i]     = 250+80*cos(radians((360/num)*i));
    y[i]     = 250+80*sin(radians((360/num)*i));
    velAngle[i] = (360/num)*i;
    vel[i]   = random(0, 5.5);
    dx[i]    = vel[i]*cos(radians(velAngle[i]));
    dy[i]    = vel[i]*sin(radians(velAngle[i]));
  }

  size(500, 500);
  background(240);
  smooth();
}

void draw() {
  background(240);
  stroke(100);
  strokeWeight(1);
  noFill();
  for (int i=0; i<num; i++) {
    ellipse(x[i], y[i], 10, 10);
    line(x[i], y[i], x[i]+10*dx[i], y[i]+10*dy[i]);
  }
  ellipse(x[num], y[num], 20, 20);
  line(x[num], y[num], x[num]+15*dx[num], y[num]+15*dy[num]);

  aveX = 0;
  aveY = 0;
  for (int i=0; i<num; i++) {
    aveX += x[i];
    aveY += y[i];
  }
  aveX /= num;
  aveY /= num;
  if (mousePressed == true) {
    aveX = mouseX;
    aveY = mouseY;
    stroke(0, 0, 255);
    fill(0, 0, 255);
    ellipse(aveX, aveY, 10, 10);
  } 

  for (int i=0; i<num+1; i++) {
    ctrDirX[i] = aveX - x[i];
    ctrDirY[i] = aveY - y[i];
    //stroke(0, 0, 255);
    //line(x[i], y[i], x[i]+0.1*ctrDirX[i], y[i]+0.1*ctrDirY[i]);
  }
  //stroke(0, 0, 255);
  //fill(0, 0, 255);
  //ellipse(aveX, aveY, 10, 10);

  aveVel   = 0;
  aveAngle = 0;
  for (int i=0; i<num; i++) {
    aveVel   += sqrt(dx[i]*dx[i]+dy[i]*dy[i]);
    aveAngle += degrees(atan2(dy[i], dx[i]));
  }
  aveVel   /= num;
  aveAngle /= num;

  velX = aveVel*cos(radians(aveAngle));
  velY = aveVel*sin(radians(aveAngle));

  //stroke(0, 255,0);
  //for (int i=0; i<num; i++) {
  //line(x[i], y[i], x[i]+60*velX, y[i]+60*velY);
  //}

  for (int i=0; i<num; i++) {
    contX[i]=0;
    contY[i]=0;
    for (int j=0; j<num; j++) {
      if (i!=j) {
        float dist=sqrt((x[j]-x[i])*(x[j]-x[i])+(y[j]-y[i])*(y[j]-y[i]));
        if (0<dist&&dist<15) {
          contX[i] = -1*(x[j]-x[i]);
          contY[i] = -1*(y[j]-y[i]);
          float temp = sqrt(contX[i]*contX[i]+contY[i]*contY[i]);
          contX[i]/=temp;
          contY[i]/=temp;
        }
      }
    }
  }
  
  
  contX[num]=0;
  contY[num]=0;
  for (int j=0; j<num; j++) {
    
    float dist=sqrt((x[j]-x[num])*(x[j]-x[num])+(y[j]-y[num])*(y[j]-y[num]));
    float near=500;
    if (near > dist) {
      near = dist;
      contX[num] = (x[j]-x[num]);
      contY[num] = (y[j]-y[num]);
      float temp = sqrt(contX[num]*contX[num]+contY[num]*contY[num]);
      contX[num]/=temp;
      contY[num]/=temp;
    }
  }
  
  
  for (int i=0; i<num; i++) {
    avoiX[i]=0;
    avoiY[i]=0;

    float dist=sqrt((x[num]-x[i])*(x[num]-x[i])+(y[num]-y[i])*(y[num]-y[i]));
    if (0<dist&&dist<150) {
      avoiX[i] = -1*(x[num]-x[i]);
      avoiY[i] = -1*(y[num]-y[i]);
    float temp = sqrt(avoiX[i]*avoiX[i]+avoiY[i]*avoiY[i]);
    avoiX[i]/=temp;
    avoiY[i]/=temp;
       
    }
  }
  
  float chasX=0;
  float chasY=0;
   
  chasX = (x[10]-x[num]);
  chasY = (y[10]-y[num]);
  if(chasX<250){
     chasX=500-chasX; 
  }
  if(chasY<250){
     chasY=500-chasY; 
  }
  float temp = sqrt(chasX*chasX+chasY*chasY);
  chasX/=temp;
  chasY/=temp;
  
  //for (int i=0; i<num; i++) {
  //stroke(255, 0, 0);
  //line(x[i], y[i], x[i]+contX[i], y[i]+contY[i]);
  //}

  for (int i=0; i<num; i++) {
    kX[i] = 0.03*ctrDirX[i]+4.0*velX+5.0*contX[i]+20*avoiX[i];
    kY[i] = 0.03*ctrDirY[i]+4.0*velY+5.0*contY[i]+20*avoiY[i];

    float tempVel = sqrt(kX[i]*kX[i]+kY[i]*kY[i]);
    if (tempVel>4) {
      kX[i]=2*kX[i]/tempVel;
      kY[i]=2*kY[i]/tempVel;
    }

    dx[i] += (kX[i]-dx[i])*0.02;
    dy[i] += (kY[i]-dy[i])*0.02;

    x[i] += dx[i];
    y[i] += dy[i];

    if (x[i]>500)x[i]=0;
    if (x[i]<0)x[i]=500;
    if (y[i]>500)y[i]=0;
    if (y[i]<0)y[i]=500;
  }

   kX[num] = 0.0*ctrDirX[num]+8*contX[num]+00*chasX;
   kY[num] = 0.0*ctrDirY[num]+8*contY[num]+00*chasY;
   float tempVel = sqrt(kX[num]*kX[num]+kY[num]*kY[num]);
    if (tempVel>2) {
      kX[num]=2*kX[num]/tempVel;
      kY[num]=2*kY[num]/tempVel;
    }

    dx[num] += (kX[num]-dx[num])*0.02;
    dy[num] += (kY[num]-dy[num])*0.02;

    x[num] += dx[num];
    y[num] += dy[num];

    if (x[num]>500)x[num]=0;
    if (x[num]<0)x[num]=500;
    if (y[num]>500)y[num]=0;
    if (y[num]<0)y[num]=500;
    
    saveFrame("frames_chase/######.png");
}
