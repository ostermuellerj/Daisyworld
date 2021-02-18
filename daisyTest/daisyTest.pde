import peasy.*;
float size = 150;
float inc = 0;
PeasyCam cam;
float phi = (1 + sqrt(5))/2;

float rr = 33;

void setup () {
  colorMode(HSB);	
  // size(600, 600, P3D);
  fullScreen(P3D);
  cam = new PeasyCam(this, 1000);  

}

void draw() {
	inc+=0.02;
	background(170, 100, 120);
 	
 	pushMatrix();
	 	translate(rr*cos(TWO_PI/3), rr*sin(TWO_PI/3), 0);
		drawDaisy(85, 25);
 	popMatrix();

 	pushMatrix();
	 	translate(rr*cos(2*TWO_PI/3), rr*sin(2*TWO_PI/3), 0);
		drawDaisy(120, 30);
 	popMatrix();

 	pushMatrix();
	 	translate(rr*cos(0), rr*sin(0), 0);
		drawDaisy(90, 20);
 	popMatrix(); 	 	
}

void drawDaisy(float h, float r) {
	// float h = 100;
	// float r = 40;
	float numPetals = 21;
	// float petalWidth = 0.5*TWO_PI*r/numPetals;
	float petalWidth = 10;

	//draw stem
	stroke(255);
	strokeWeight(1);
	// line(0, 0, 0, 0, 0, h);
	noFill();
	beginShape();
		curveVertex(0, 0, 0);
		curveVertex(0, 0, h/8);		
		curveVertex(1, 1, h/4);		
		curveVertex(3, 1, h/2);
		curveVertex(1, 0, 3*h/4);
		curveVertex(1, 0, 7*h/8);	
		curveVertex(0, 0, h);					
		curveVertex(0, 0, h);		
	endShape();

	pushMatrix();
		translate(0, 0, h);

		//draw petals
		strokeWeight(3);
		stroke(170, 40, 230, 100);
		fill(170, 20, 255, 255);
		for(int i=0; i<numPetals; i++) {
			pushMatrix();
				// rotate(TWO_PI*i/numPetals);
				rotate(i*TWO_PI*phi);
				//tilt petals upwards		
				rotateY(-PI/20-PI/40*sin(inc));
				//slight twist
				rotateX(PI/20);
				// arc(0, 0, 10*r, petalWidth, PI/2, 3*PI/2);
				beginShape();
					curveVertex(0,-petalWidth/4.5, 0);			
					curveVertex(r/5,-petalWidth/4.5, 0);
					curveVertex(r/3,-petalWidth/3.5, 0);						
					curveVertex(2*r/3,-petalWidth/2.5, 0);			
					curveVertex(r,-petalWidth/2.5, 0);
					curveVertex(r*1.15, 0, 0);			
					curveVertex(r,petalWidth/2.5, 0);
					curveVertex(2*r/3,petalWidth/2.5, 0);			
					curveVertex(r/3,petalWidth/3.5, 0);						
					curveVertex(r/5,petalWidth/4.5, 0);
					curveVertex(0,petalWidth/4.5, 0);			
				endShape();
			popMatrix();
		}

		//draw disc
		translate(0, 0, 1.3);
		stroke(40, 200, 255, 255);
		strokeWeight(10);
		fill(40, 200, 255, 255);
		ellipse(0, 0, r/3, r/3);
	popMatrix();


}