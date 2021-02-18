class Daisyworld {
	float size = 1000;
	float density = 0;

	// all daisies
	ArrayList<Daisy> daisies;
	// black daisies
	ArrayList<Daisy> bDaisies;
	// white daisies
	ArrayList<Daisy> wDaisies;
	// all available spaces		
	ArrayList<PVector> emptySpaces;
	// all spaces
	ArrayList<PVector> spaces;

	int numBlack = 0;
	int numWhite = 0;

	/*
		s = "density", or square root of size of daisyworld
		b = initial number of black daisies
		w = initial number of white daisies
	*/
	Daisyworld (int s, int b, int w) {

		density = s;
		spaces = new ArrayList<PVector>();
		buildSpaces();
		println("number of spaces: " + spaces.size());
		emptySpaces = (ArrayList)spaces.clone();
		daisies = new ArrayList<Daisy>();
		bDaisies = new ArrayList<Daisy>();
		wDaisies = new ArrayList<Daisy>();

		//add black daisies
		for(int i=0; i<b; i++) {
			this.add(0, new PVector(-1, -1));
		}

		//add white daisies
		for(int i=0; i<w; i++) {
			this.add(1, new PVector(-1, -1));
		}
	}

	/*
		Fill spaces arraylist with index PVectors, eg
		{0, 0}
		{0, 1}
		{0, 2}
		...
		{0, s-1}
		{1, 0}
		{1, 1}
		...
		{s-1, s-1} 
	*/
	void buildSpaces() {
		// for(int i=0; i<=0; i++) {
		for(int i=0; i<=density-1; i++) {			
			for(int j=1; j<=density/2; j++) {
				spaces.add(new PVector(i, j));
			}
		}
	}

	/*
		Runs the Daisyworld.
	*/
	void run() {
		this.display();
		this.update();
	}

	void update() {
		for(Daisy d : daisies) {
			d.update();
		}		
	}

	/*
		Displays the Daisyworld.
	*/
	void display () {

		//draw gridsphere
		int k = 0;
		for(PVector p : spaces) {
			if(k%2==1)
				continue;
			k++;
			stroke(0, 0, 255, 100);
			// stroke(2*255*p.y/density%255, 255, 255, 80);
			strokeWeight(1);
			// fill(0, 0, 150);
			// noFill();
			this.drawQuad(p, 1);
		}
	
		//draw daisies
		for(Daisy d : daisies) {
			d.display();
		}	
	}

	/*
		Draws a quad using spherical projection.
		p = location on the sphere
		scale = percent size of the grid space to fill
	*/
	void drawQuad(PVector p, float scale) {
			float r = size/2;
			float x = p.x;
			float y = p.y;

			pushMatrix();
				//x-y angle
				float theta = TWO_PI*((x)/(density));			
				//x-z angle		
				float phi = ((density/2)-1)*PI/density + TWO_PI*y/density;				

				//translate points to x/y/z location based on calculated angles
				float a = r*cos(HALF_PI*(1-((density-2)/density)));
				translate(a*cos(phi)*cos(theta), a*cos(phi)*sin(theta), a*sin(phi));
				
				//rotate quads
				rotateZ(-PI/2+theta);
				rotateX(phi+PI/2);

				// debug
				// fill(255);
				// text("["+x+","+y+"]", 0, 0);

				float h = scale*2*r*sin(HALF_PI*(1-((density-2)/density)));

				float w1 = scale*h*cos(((density/2)-1)*PI/density + TWO_PI*(y-0.5)/density);
				float w2 = scale*h*cos(((density/2)-1)*PI/density + TWO_PI*(y+0.5)/density);			

				// x1,y1   x2,y2
				// x4,y4   x3,y3

				quad(-w1/2, -h/2,
					 w1/2, -h/2,
					 w2/2, h/2,
					 -w2/2, h/2);
			popMatrix();
	}

	/*
		Add a Daisy to this Daisyworld at location p.
		If p is {-1,-1}, a random empty space will be chosen.
		type = 0: black
		type = 1: white
	*/
	Daisy add (int type, PVector p) {
		Daisy d = new Daisy(-1, -1);

		//if diceroll, add daisy next to an existing daisy of same type
		// debug: "random(1) > 0.0" 
		if(random(1)>0.0) {
			p = getEmptyNeighbor(type);
		}

		//if fed a null vector, add daisy at any open space
		if(p.x == -1 && p.y == -1) {
			// println("Finding empty space...");
			p = this.getEmptySpace();
		} 

		if(type==0) {
			d = new BDaisy((int)p.x, (int)p.y);
			bDaisies.add(d);
			numBlack++;
			println("BDaisy added");
		} else if(type==1) {
			d = new WDaisy((int)p.x, (int)p.y);
			wDaisies.add(d);
			numWhite++;
			println("WDaisy added");
		}
		
		daisies.add(d);
		emptySpaces.remove(d.loc);
		return d;
	}

	/*
		Checks if a given space is empty.
		return true = space is empty
		return false = space is not empty
	*/
	boolean checkIfEmpty(PVector p) {
		int index = emptySpaces.indexOf(p); 
		if(index == -1)
			return false;
		else 
			return true;	
	}

	/*
		Returns PVector of an empty space that 
		is next to an existing daisy.

		"type" determines the color of the neighbor:
		type = 0: black
		type = 1: white
	*/
	PVector getEmptyNeighbor (int type) {
		//  2
		//1   3
		//  4

		PVector p;

		if(type == 0 && numBlack>0) {
			p = bDaisies.get((int)random(bDaisies.size())).loc;
		} else if (type == 1 && numWhite>0) {
			p = wDaisies.get((int)random(wDaisies.size())).loc;
		} else {
			return new PVector(-1, -1);
		}

		switch((int) random(4)) {
			case 0:
				p.set((p.x-1)%density, p.y);
				if(checkIfEmpty(p)) return p;
				break;
			case 1:
				p.set(p.x, (p.y-1)%density);
				if(checkIfEmpty(p)) return p;
				break;
			case 2:
				p.set((p.x+1)%density, p.y);
				if(checkIfEmpty(p)) return p;
				break;
			case 3:
				p.set(p.x, (p.y+1)%density);
				if(checkIfEmpty(p)) return p;
				break;
		}

		return new PVector(-1, -1);
	}

	/*
		Returns an empty space by getting 
		a random PVector from emptySpaces.
	*/
	PVector getEmptySpace() {
		if(emptySpaces.size()>0) {
			// println((int)random(emptySpaces.size()));
			return emptySpaces.get((int)random(emptySpaces.size()));
		}
		else 
		{
			println("No empty spaces.");
			return new PVector(-1, -1);
		}
	}
	
}