class Daisy {

	float age;
	PVector loc;

	Daisy (int x, int y) {
		loc = new PVector(x, y);
	}

	void display () {
		

	}

	void update () {
		age+=1;
	}
}

class BDaisy extends Daisy {

	BDaisy (int x, int y) {
		super(x, y);
	}

	@Override
	void display () {
		// println("BDaisy display");
		fill(0, 0, 0, 255*(age/1000));
		// stroke(60, 100, 255, min(150*(age/5000), 150));
		// noStroke();
		strokeWeight(1);
		// dw.drawQuad(loc, 0.5);
		noFill();
	}
}

class WDaisy extends Daisy {
	
	WDaisy (int x, int y) {
		super(x, y);	
	}

	void display () {
		fill(0, 0, 255, 255*(age/1000));
		// stroke(60, 100, 255, min(150*(age/5000), 150));
		// noStroke();
		strokeWeight(1);
		// dw.drawQuad(loc, 0.5);
		noFill();
	}

}