import peasy.*;

PeasyCam cam;
Daisyworld dw;

float inc;

int startSize = 200;
int startNumBlack = 0;
int startNumWhite = 3; 

void setup () {

	dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	println("Number of daisies: " + dw.daisies.size());
	println("Number of black daisies: " + dw.bDaisies.size());
	println("Number of white daisies: " + dw.wDaisies.size());
	cam = new PeasyCam(this, 100);	

	// size(900, 900, P3D);
	fullScreen(P3D);
	colorMode(HSB);
}

void draw () {
	background(140, 140, 100);
	// background(50+100*sin(2*inc));	
	inc += 0.001;

	pushMatrix();
		rotate(inc);
		dw.run();
	popMatrix();

	cam.beginHUD();
	cam.endHUD();
}

void keyPressed() {
	if (keyCode == UP) {

	} else if (key == 'r') {
		dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	} else if (key == '1') {
		dw.add(0, new PVector(-1, -1));
	} else if (key == '2') {
		dw.add(1, new PVector(-1, -1));
	} else if (key == '3') {
		for(int i=0; i<sq(startSize)/30; i++)
			dw.add((int)random(2), new PVector(-1, -1));
	}
}