import peasy.*;

PeasyCam cam;
Daisyworld dw;

float inc;
Boolean doRotate = true;

float sw=15;

int startSize = 0;

// initial number of daisies: 
int startNumBlack = 0;
int startNumWhite = 0; 

int start;
//debug Space.display()
int o = 10;

void setup () {

	dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	println("Number of daisies: " + dw.daisies.size());
	println("Number of black daisies: " + dw.bDaisies.size());
	println("Number of white daisies: " + dw.wDaisies.size());
	cam = new PeasyCam(this, 100);	

	// size(900, 900, P3D);
	fullScreen(P3D);
	colorMode(HSB);
	// frameRate(10);

	start=millis();
}

void draw () {
	// soft blue 
	// background(140, 140, 100);
	background(0);
	// background(50+100*sin(2*inc));	

	// run the daisyworld
	pushMatrix();
		// slight constant rotation
		if(doRotate) {
			inc += 0.01;
			rotate(inc);
		}
		dw.run();
	popMatrix();

	// HUD
	cam.beginHUD();
	cam.endHUD();

	// if(doRotate) save(nf(inc, 2, 5) + ".png");
	if(inc>PI) exit();
}

void keyPressed() {
	// increment daisyworld size up
	if (keyCode == UP) {
		startSize++;
		println(startSize);
		dw = new Daisyworld(startSize, startNumBlack, startNumWhite);

		// sw-=5;
		// stroke(sw/30*255%255, 180, 255, 150);
		// strokeWeight(sw);
	}
	// increment daisyworld size down
	else if (keyCode == DOWN) {
		startSize = max(0, startSize-1);
		println(startSize);
		dw = new Daisyworld(startSize, startNumBlack, startNumWhite);

		// sw+=5;
		// stroke(sw/30*255%255, 180, 255, 150);
		// strokeWeight(sw);
	} 
	// restart sim with same initial parameters
	else if (key == 'r') {
		dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	}
	// else if (key == 'b') {
	// 	background(255);
	// 	strokeWeight(sw);
	// } 
	else if (key == 'k') {
		doRotate=true;
	} 
	// add a single black daisy
	else if (key == '1') {
		// dw.addDaisy(0, new PVector(-1, -1));
		dw.addDaisy(0, int(random(dw.emptySpaces.size())));
	} 
	// add a single white daisy
	else if (key == '2') {
		// dw.addDaisy(1, new PVector(-1, -1));
		dw.addDaisy(1, int(random(dw.emptySpaces.size())));
	} 
	// add many daisies of each color
	else if (key == '3') {
		for(int i=0; i<sq(startSize); i++) {
			// dw.addDaisy((int)random(2), int(random(dw.emptySpaces.size())));
			dw.addDaisy(1, int(random(dw.spaces.size())));
		}
	}
}