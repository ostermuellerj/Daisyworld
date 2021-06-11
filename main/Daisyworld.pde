class Daisyworld {
	float size = 200;
	float density = 0;

	// all daisies
	ArrayList<Daisy> daisies;
	// black daisies
	ArrayList<Daisy> bDaisies;
	// white daisies
	ArrayList<Daisy> wDaisies;
	// all available spaces		
	ArrayList<Space> emptySpaces;
	// all spaces
	ArrayList<Space> spaces;

	PVector[] ico;

	int numBlack = 0;
	int numWhite = 0;

	/*
		s = "density", or square root of size of daisyworld
		b = initial number of black daisies
		w = initial number of white daisies
	*/
	Daisyworld (int s, int b, int w) {
		density = s;
		buildSpaces();
		emptySpaces = new ArrayList<Space>(spaces);
		daisies = new ArrayList<Daisy>();
		bDaisies = new ArrayList<Daisy>();
		wDaisies = new ArrayList<Daisy>();

		//add black daisies
		for(int i=0; i<b; i++) {
			this.addDaisy(0, spaces.indexOf(random(emptySpaces.size())));
			// this.addDaisy(0, i);
			
			// old
			// this.addDaisy(0, new PVector(-1, -1));
		}

		//add white daisies
		for(int i=0; i<w; i++) {
			this.addDaisy(1, spaces.indexOf(random(emptySpaces.size())));
			// this.addDaisy(1, i);

			//old
			// this.addDaisy(1, new PVector(-1, -1));
		}
	}

	/*
		Builds base icosahedron, then subdivides each face of
		the icosphere to the desired recursion level.
	*/
	void buildSpaces() {
		spaces = new ArrayList<Space>();
		buildIco();

		// if density = 0, normalize points but don't subdivide,
		// otherwise, subdivide.
		for(int i=0; i<density; i++) {
			// println("des: "+density);
			ArrayList<Space> newSpaces = new ArrayList<Space>();
			for(Space s : spaces) {

				// define the midpoints of the given space's vectors
				// and normalize these points to the unit sphere.
				PVector m1 = pointToSphere(s.getMidpoint(s.verts[0], s.verts[1]));
				PVector m2 = pointToSphere(s.getMidpoint(s.verts[1], s.verts[2]));
				PVector m3 = pointToSphere(s.getMidpoint(s.verts[2], s.verts[0]));

				// subdivide the Space into four new Spaces
				// (think triforce shape) using the vertices
				// and midpoints of the parent Space.
				Space t0 = new Space(m1, m2, m3);
				Space t1 = new Space(s.verts[0], m1, m3);
				Space t2 = new Space(s.verts[1], m2, m1);
				Space t3 = new Space(s.verts[2], m2, m3);
				
				// assign new spaces as children of s 
				// s.ch0 = t0;
				// s.ch1 = t1;
				// s.ch2 = t2;
				// s.ch3 = t3;
				s.children = new Space[] {t0, t1, t2, t3};
				// s.children.add(t1);
				// s.children.add(t2);
				// s.children.add(t3);

				// assign interal neighbors to the new Spaces	
				t1.n2 = t0; 
				t3.n2 = t0;
				t2.n2 = t0;
				t0.n1 = t2;
				t0.n2 = t3;
				t0.n3 = t1;

				newSpaces.add(t0);
				newSpaces.add(t1);
				newSpaces.add(t2);
				newSpaces.add(t3);
				
			}

			// make a copy of the parent spaces
			ArrayList<Space> parentSpaces = new ArrayList<Space>(spaces);

			// populate spaces array with new spaces
			spaces = newSpaces;

			// another pass over parent spaces to bridge the 
			// previously undefined neighbor-connections
			for(Space s : parentSpaces) {
				//s.n1
				int n1_offset = s.findNeighbor(s, s.n1, 1);
				s.children[1].n1 = s.n1.children[(2+n1_offset-1)%3+1];
				s.children[2].n3 = s.n1.children[(1+n1_offset-1)%3+1];

				//s.n2
				int n2_offset = s.findNeighbor(s, s.n2, 2);
				s.children[2].n1 = s.n2.children[(3+n2_offset-1)%3+1];
				s.children[3].n1 = s.n2.children[(2+n2_offset-1)%3+1];
				
				//s.n3
				int n3_offset = s.findNeighbor(s, s.n3, 3);
				s.children[3].n3 = s.n3.children[(1+n1_offset-1)%3+1];
				s.children[1].n3 = s.n3.children[(3+n1_offset-1)%3+1];
			}


			// debug:
			// println(spaces.toString());
			// println("Number of spaces: " + spaces.size());
		}
	}

	/*
		Builds base icosahedron's vertices and 20 Spaces, then 
		links each Space to its 3 direct neighbors.
	*/
	void buildIco() {
		// implementation inpsired by http://blog.andreaskahler.com/2009/06/creating-icosphere-mesh-in-code.html
		
		// essentially, an icosahedron can be constructed with
		// three special rectangles of size 1 x phi and each
		// rectangle sitting on its own plane x, y, or z. 

		// The 12 vertices of these three rects form 20 equilateral
		// triangles in space. The values for these vertices are hardcoded, 
		// then the created faces are subdivided later using recursion.

		// each rect is size w x t
		float w = size;
		float t = w * (1 + sqrt(5))/2;

		// define ico's 12 vertices
		// rect 1
		PVector p0 = pointToSphere(new PVector( w,  t, 0));
		PVector p1 = pointToSphere(new PVector( w, -t, 0));
		PVector p2 = pointToSphere(new PVector(-w,  t, 0));
		PVector p3 = pointToSphere(new PVector(-w, -t, 0));

		// rect 2
		PVector p4 = pointToSphere(new PVector(0,  w,  t));
		PVector p5 = pointToSphere(new PVector(0,  w, -t));
		PVector p6 = pointToSphere(new PVector(0, -w,  t));
		PVector p7 = pointToSphere(new PVector(0, -w, -t));

		// rect 3		
		PVector p8 = pointToSphere(new PVector(  t, 0,  w));
		PVector p9 = pointToSphere(new PVector(  t, 0, -w));
		PVector p10 = pointToSphere(new PVector(-t, 0,  w));
		PVector p11 = pointToSphere(new PVector(-t, 0, -w));									

		ico = new PVector[] {p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11};

		//define ico's 20 faces
		//top 5 tris
		spaces.add(new Space(p1, p6, p3)); //0
		spaces.add(new Space(p1, p3, p7)); //1
		spaces.add(new Space(p1, p7, p9)); //2
		spaces.add(new Space(p1, p9, p8)); //3
		spaces.add(new Space(p1, p8, p6)); //4

		//adjacent tris
		spaces.add(new Space(p6, p10, p3)); //5
		spaces.add(new Space(p3, p11, p7)); //6
		spaces.add(new Space(p7, p5, p9));  //7
		spaces.add(new Space(p9, p0, p8));  //8
		spaces.add(new Space(p8, p4, p6));  //9

		//bottom 5 tris
		spaces.add(new Space(p2, p5, p11));  //10
		spaces.add(new Space(p2, p11, p10)); //11
		spaces.add(new Space(p2, p10, p4));  //12
		spaces.add(new Space(p2, p4, p0));   //13
		spaces.add(new Space(p2, p0, p5));   //14

		//adjacent tris
		spaces.add(new Space(p5, p7, p11));  //15
		spaces.add(new Space(p11, p3, p10)); //16
		spaces.add(new Space(p10, p6, p4));  //17
		spaces.add(new Space(p4, p8, p0));   //18
		spaces.add(new Space(p0, p9, p5));   //19

		for(Space s : spaces) {
			setNeighbors(s);
		}

		//assign neighbors WIP
		// spaces.get(0).setNeighbors(4, 5, 1);
		// spaces.get(1).setNeighbors(0, 6, 2);
		// spaces.get(2).setNeighbors(1, 7, 3);
		// spaces.get(3).setNeighbors(2, 8, 4);
		// spaces.get(4).setNeighbors(3, 9, 0);
		// spaces.get(5).setNeighbors(17, 16, 0);
		// spaces.get(6).setNeighbors(16, 15, 1);
		// spaces.get(7).setNeighbors(15, 19, 2);
		// spaces.get(8).setNeighbors(19, 18, 3);
		// spaces.get(9).setNeighbors(18, 17, 4);
		// spaces.get(10).setNeighbors(14, 15, 11);
		// spaces.get(11).setNeighbors(10, 16, 12);
		// spaces.get(12).setNeighbors(11, 17, 13);
		// spaces.get(13).setNeighbors(12, 18, 14);
		// spaces.get(14).setNeighbors(13, 19, 10);						
		// spaces.get(15).setNeighbors(7, 6, 10);
		// spaces.get(16).setNeighbors(6, 5, 11);
		// spaces.get(17).setNeighbors(5, 9, 12);
		// spaces.get(18).setNeighbors(9, 8, 13);
		// spaces.get(19).setNeighbors(8, 7, 14);						
	}

	/*
		Brute-force searches across spaces to find 
		and set the neighbors of the given Space.

		Only run once at lowest resolution ico due to
		heavy cpu cost.
	*/
	void setNeighbors(Space s){
		for(Space p : spaces) {
			if(p==s) continue;
			boolean v1_in_p = false;
			boolean v2_in_p = false;
			boolean v3_in_p = false;

			for(PVector v_p : p.verts) {
				if(s.verts[0] == v_p) v1_in_p = true;
				else if(s.verts[1] == v_p) v2_in_p = true;
				else if(s.verts[2] == v_p) v3_in_p = true;
			}
			if(v1_in_p && v2_in_p) s.n1 = p;
			else if(v2_in_p && v3_in_p) s.n2 = p;
			else if(v3_in_p && v1_in_p) s.n3 = p;
		}

	}

	
	// 	Finds whether or not two Spaces are neighbors.

	// 	Returns:
	// 	true if the Spaces are neighbors
	// 	false if the Spaces are not neighbor
	
	// boolean areNeighbors(Space a, Space b){
	// 	float[] a_mids = new float[] {};
	// 	float[] b_mids = new float[] {};
	// }

	/*
		Runs the Daisyworld.
	*/
	void run() {
		this.display();
		this.update();
	}

	/*
		Updates the Daisyworld for the given time (inc).
	*/
	void update() {
		for(Daisy d : daisies) {
			d.update();
		}		
	}

	/*
		Displays the Daisyworld.
	*/
	void display () {
		//draw icosphere
		pushMatrix();
		// scale(10);
		for(Space p : spaces) {
			p.display();
		}
		popMatrix();
	
		//draw daisies
		for(Daisy d : daisies) {
			d.display();
		}	


		noStroke();
		//draw rects
		// fill(255/3, 100, 255, 150);
		// beginShape(QUADS);
		// vertex(ico[0].x, ico[0].y, ico[0].z);
		// vertex(ico[2].x, ico[2].y, ico[2].z);
		// vertex(ico[3].x, ico[3].y, ico[3].z);
		// vertex(ico[1].x, ico[1].y, ico[1].z);
		// endShape();

		// fill(2*255/3, 100, 255, 150);
		// beginShape(QUADS);
		// vertex(ico[4].x, ico[4].y, ico[4].z);
		// vertex(ico[6].x, ico[6].y, ico[6].z);
		// vertex(ico[7].x, ico[7].y, ico[7].z);
		// vertex(ico[5].x, ico[5].y, ico[5].z);
		// endShape();

		// fill(255, 100, 255, 150);
		// beginShape(QUADS);
		// vertex(ico[8].x, ico[8].y, ico[8].z);
		// vertex(ico[10].x, ico[10].y, ico[10].z);
		// vertex(ico[11].x, ico[11].y, ico[11].z);
		// vertex(ico[9].x, ico[9].y, ico[9].z);
		// endShape();
	}

	/*
		Add a Daisy to this Daisyworld at location p.
		If p is {-1,-1}, a random empty space will be chosen.
		type = 0: black
		type = 1: white
	*/
	Daisy addDaisy (int type, int id) {
	// Daisy addDaisy (int type, PVector p) {
		// Daisy d = new Daisy(-1, -1);
		Daisy d = new Daisy(-1);
		//if diceroll, add daisy next to an existing daisy of same type
		// debug: "random(1) > 0.0" 
		// if(random(1)>0.0) {
		// 	p = getEmptyNeighbor(type);
		// }

		//if fed a null vector, add daisy at any open space
		// if(p.x == -1 && p.y == -1) {
		// 	// println("Finding empty space...");
		// 	p = this.getEmptySpace();
		// } 

		if(type==0) {
			d = new BDaisy(id);
			// d = new BDaisy((int)p.x, (int)p.y);
			bDaisies.add(d);
			numBlack++;
			println("BDaisy added"+id);
		} else if(type==1) {
			d = new WDaisy(id);
			// d = new WDaisy((int)p.x, (int)p.y);
			wDaisies.add(d);
			numWhite++;
			println("WDaisy added"+id);
		}

		// old
		// if(type==0) {
		// 	d = new BDaisy((int)p.x, (int)p.y);
		// 	bDaisies.addDaisy(d);
		// 	numBlack++;
		// 	println("BDaisy added");
		// } else if(type==1) {
		// 	d = new WDaisy((int)p.x, (int)p.y);
		// 	wDaisies.addDaisy(d);
		// 	numWhite++;
		// 	println("WDaisy added");
		// }
		
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

	// ***UPDATE
	/*
		Returns PVector of an empty space that 
		is next to an existing daisy.

		"type" determines the color of the neighbor:
		type = 0: black
		type = 1: white
	*/
	// PVector getEmptyNeighbor (int type) {
	// 	//  2
	// 	//1   3
	// 	//  4

	// 	PVector p;

	// 	if(type == 0 && numBlack>0) {
	// 		p = bDaisies.get((int)random(bDaisies.size())).loc;
	// 	} else if (type == 1 && numWhite>0) {
	// 		p = wDaisies.get((int)random(wDaisies.size())).loc;
	// 	} else {
	// 		return new PVector(-1, -1);
	// 	}

	// 	switch((int) random(4)) {
	// 		case 0:
	// 			p.set((p.x-1)%density, p.y);
	// 			if(checkIfEmpty(p)) return p;
	// 			break;
	// 		case 1:
	// 			p.set(p.x, (p.y-1)%density);
	// 			if(checkIfEmpty(p)) return p;
	// 			break;
	// 		case 2:
	// 			p.set((p.x+1)%density, p.y);
	// 			if(checkIfEmpty(p)) return p;
	// 			break;
	// 		case 3:
	// 			p.set(p.x, (p.y+1)%density);
	// 			if(checkIfEmpty(p)) return p;
	// 			break;
	// 	}

	// 	return new PVector(-1, -1);
	// }

	// // ***UPDATE
	// /*
	// 	Returns an empty space by getting 
	// 	a random PVector from emptySpaces.
	// */
	// PVector getEmptySpace() {
	// 	if(emptySpaces.size()>0) {
	// 		println((int)random(emptySpaces.size()));
	// 		return emptySpaces.get((int)random(emptySpaces.size()));
	// 	}
	// 	else 
	// 	{
	// 		println("No empty spaces.");
	// 		return new PVector(-1, -1);
	// 	}
	// }

	/*
		Normalizes a PVector to the unit sphere with radius=size.
	*/
	PVector pointToSphere(PVector p) {
		float mag = sqrt(p.x*p.x + p.y*p.y + p.z*p.z);
		return new PVector(size*p.x/mag, size*p.y/mag, size*p.z/mag);		
	}
}