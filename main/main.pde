import peasy.*;

PeasyCam cam;
Daisyworld dw;

float inc;
Boolean doRotate = false;

// number of spaces = 20*4^(n),
// where n=startSize and n∈{0,+inf},
// although performance drops at n>6.
int startSize = 0;

// initial number of daisies: 
int startNumBlack = 0;
int startNumWhite = 0; 

void setup () {

	dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	println("Number of daisies: " + dw.daisies.size());
	println("Number of black daisies: " + dw.bDaisies.size());
	println("Number of white daisies: " + dw.wDaisies.size());
	cam = new PeasyCam(this, 100);	

	size(900, 900, P3D);
	// fullScreen(P3D);
	colorMode(HSB);
}

void draw () {
	// soft blue 
	// background(140, 140, 100);
	background(0);
	// background(50+100*sin(2*inc));	
	inc += 0.001;

	// run the daisyworld
	pushMatrix();
		// slight constant rotation
		if(doRotate) rotate(inc);
		dw.run();
	popMatrix();

	// HUD
	cam.beginHUD();
	cam.endHUD();
}

void keyPressed() {
	// increment daisyworld size up
	if (keyCode == UP) {
		startSize++;
		println(startSize);
		dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	}
	// increment daisyworld size down
	else if (keyCode == DOWN) {
		startSize = max(0, startSize-1);
		println(startSize);
		dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	} 
	// restart sim with same initial parameters
	else if (key == 'r') {
		dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	} 
	// add a single black daisy
	else if (key == '1') {
		dw.add(0, new PVector(-1, -1));
	} 
	// add a single white daisy
	else if (key == '2') {
		dw.add(1, new PVector(-1, -1));
	} 
	// add many daisies of each color
	else if (key == '3') {
		for(int i=0; i<sq(startSize); i++)
			dw.add((int)random(2), new PVector(-1, -1));
	}
}