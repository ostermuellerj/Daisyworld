void drawDaisy(float h, float r, float c) {
	// float h = 100;
	// float r = 40;
	float numPetals = 9;
	// float petalWidth = 0.5*TWO_PI*r/numPetals;
	float petalWidth = r/4;

	//draw stem
	stroke(255);
	strokeWeight(1);
	// line(0, 0, 0, 0, 0, h);
	
	pushMatrix();
		translate(0, 0, c);
		pushMatrix();
			translate(0, 0, h);

			//draw petals
			noStroke();
			// strokeWeight(3);
			// stroke(170, 40, 230, 100);
			// fill(170, 20, 255, 255);
			for(int i=0; i<numPetals; i++) {
				pushMatrix();
					// rotate(TWO_PI*i/numPetals);
					rotate(i*TWO_PI*(1 + sqrt(5))/2);
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
			strokeWeight(r);
			fill(40, 200, 255, 255);
			ellipse(0, 0, r/3, r/3);
			strokeWeight(r/5);
		popMatrix();
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
	popMatrix();
}