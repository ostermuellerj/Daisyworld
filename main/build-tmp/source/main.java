import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {



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

public void setup () {

	dw = new Daisyworld(startSize, startNumBlack, startNumWhite);
	println("Number of daisies: " + dw.daisies.size());
	println("Number of black daisies: " + dw.bDaisies.size());
	println("Number of white daisies: " + dw.wDaisies.size());
	cam = new PeasyCam(this, 100);	

	
	// fullScreen(P3D);
	colorMode(HSB);
}

public void draw () {
	// soft blue 
	// background(140, 140, 100);
	background(0);
	// background(50+100*sin(2*inc));	
	inc += 0.001f;

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

public void keyPressed() {
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
class Daisy {

	float age;
	PVector loc;

	Daisy (int x, int y) {
		loc = new PVector(x, y);
	}

	public void display () {
		

	}

	public void update () {
		age+=1;
	}
}

class BDaisy extends Daisy {

	BDaisy (int x, int y) {
		super(x, y);
	}

	public @Override
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

	public void display () {
		fill(0, 0, 255, 255*(age/1000));
		// stroke(60, 100, 255, min(150*(age/5000), 150));
		// noStroke();
		strokeWeight(1);
		// dw.drawQuad(loc, 0.5);
		noFill();
	}

}
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
	ArrayList<PVector> emptySpaces;
	// all spaces
	ArrayList<Space> spaces;

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
		Builds base icosahedron, then subdivides each face of
		the icosphere to the desired recursion level.
	*/
	public void buildSpaces() {
		spaces = new ArrayList<Space>();
		buildIco();

		// if density = 0, normalize points but don't subdivide,
		// otherwise, subdivide.
		for(int i=0; i<density; i++) {
			println("des: "+density);
			ArrayList<Space> newSpaces = new ArrayList<Space>();
			for(Space s : spaces) {

				// define the midpoints of the given space's vectors
				// and normalize these points to the unit sphere.
				PVector m1 = pointToSphere(s.getMidpoint(s.v1, s.v2));
				PVector m2 = pointToSphere(s.getMidpoint(s.v2, s.v3));
				PVector m3 = pointToSphere(s.getMidpoint(s.v3, s.v1));

				// subdivide the Space into four new Spaces
				// (think triforce shape) using the vertices
				// and midpoints of the parent Space.
				newSpaces.add(new Space(s.v1, m1, m3));
				newSpaces.add(new Space(s.v2, m2, m1));			
				newSpaces.add(new Space(s.v3, m2, m3));			
				newSpaces.add(new Space(m1, m2, m3));

				// assign neighbors to the new Spaces	
				// do 		
			}

			// replace parent Spaces with new Spaces.
			spaces = newSpaces;

			// debug:
			// println(spaces.toString());
			// println("Number of spaces: " + spaces.size());
		}
	}

	/*
		Builds base icosahedron's vertices and 20 Spaces, then 
		links each Space to its 3 direct neighbors.
	*/
	public void buildIco() {
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
		spaces.add(new Space(p5, p7, p11));  //10
		spaces.add(new Space(p11, p3, p10)); //11
		spaces.add(new Space(p10, p6, p4));  //12
		spaces.add(new Space(p4, p8, p0));   //13
		spaces.add(new Space(p0, p9, p5));   //14

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
		Runs the Daisyworld.
	*/
	public void run() {
		this.display();
		this.update();
	}

	/*
		Updates the Daisyworld for the given time (inc).
	*/
	public void update() {
		for(Daisy d : daisies) {
			d.update();
		}		
	}

	/*
		Displays the Daisyworld.
	*/
	public void display () {
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
	}

	/*
		Add a Daisy to this Daisyworld at location p.
		If p is {-1,-1}, a random empty space will be chosen.
		type = 0: black
		type = 1: white
	*/
	public Daisy add (int type, PVector p) {
		Daisy d = new Daisy(-1, -1);

		//if diceroll, add daisy next to an existing daisy of same type
		// debug: "random(1) > 0.0" 
		if(random(1)>0.0f) {
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
	public boolean checkIfEmpty(PVector p) {
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
	public PVector getEmptyNeighbor (int type) {
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

	// ***UPDATE
	/*
		Returns an empty space by getting 
		a random PVector from emptySpaces.
	*/
	public PVector getEmptySpace() {
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

	/*
		Normalizes a PVector to the unit sphere with radius=size.
	*/
	public PVector pointToSphere(PVector p) {
		float mag = sqrt(p.x*p.x + p.y*p.y + p.z*p.z);
		return new PVector(size*p.x/mag, size*p.y/mag, size*p.z/mag);		
	}
}
/*
	A plot of land for a daisy/a single face of the icosphere.
	Each Space is linked to it's three neighbors.
*/
class Space {	
	//vertices
	PVector v1;
	PVector v2;
	PVector v3;

	//centroid
	PVector c;

	//neighbors
	Space n1;
	Space n2;
	Space n3;

	/*
		Creates a Space with 3 vertices.
	*/
	Space (PVector vert1, PVector vert2, PVector vert3) {
		v1 = vert1;
		v2 = vert2;
		v3 = vert3;
		setCentroid();
	}

	/*
		Create a Space from neighbors instead of vertices.
	*/
	Space (Space neighbor1, Space neighbor2, Space neighbor3) {
		n1 = neighbor1;
		n2 = neighbor2;
		n3 = neighbor3;
		makeVerts();
		setCentroid();
	}

	public void display() {
		stroke(255);

		// rainbow pattern
		// float theta = atan2(c.y, c.x);
		// float phi = atan2(c.y, c.z);		
		// stroke((200*inc+(50*sin(inc)+100)*sin(phi+inc)*sin(theta+inc))%255, 120, 200, 180);
		
		// draw tri v1-v2 v2-v3 v1-v3
		line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
		line(v2.x, v2.y, v2.z, v3.x, v3.y, v3.z);
		line(v1.x, v1.y, v1.z, v3.x, v3.y, v3.z);

		// displayCentroid();
		drawNeighborVectors();
	}

	public void displayCentroid() {
		text(dw.spaces.indexOf(this), c.x, c.y, c.z);
		point(c.x, c.y, c.z);
	}

/*
	Builds this Space's verts by matching up neighbors.
*/
	public void makeVerts() {
		v1 = getCommonVertex(n1, n3);
		v2 = getCommonVertex(n1, n2);
		v3 = getCommonVertex(n2, n3);
	}

/*
	Return a common vertex between two triangles.
*/
	public PVector getCommonVertex(Space s1, Space s2) {
		if(s1.v1 == s2.v1) return s1.v1;
		if(s1.v1 == s2.v2) return s1.v1;
		if(s1.v1 == s2.v3) return s1.v1;

		if(s1.v2 == s2.v1) return s1.v2;
		if(s1.v2 == s2.v2) return s1.v2;
		if(s1.v2 == s2.v3) return s1.v2;

		if(s1.v3 == s2.v1) return s1.v3;
		if(s1.v3 == s2.v2) return s1.v3;
		if(s1.v3 == s2.v3) return s1.v3;

		println("No common vertex.");
		return new PVector(-1, -1, -1);
	}

/*
	Returns PVector of centroid:
	c(p1,p2,p3) = average of p1, p2, p3's components
*/
	public void setCentroid() {
		this.c = new PVector((v1.x+v2.x+v3.x)/3, (v1.y+v2.y+v3.y)/3, (v1.z+v2.z+v3.z)/3);
	}

	public PVector getMidpoint(PVector vert1, PVector vert2) {
		return new PVector((vert1.x+vert2.x)/2, (vert1.y+vert2.y)/2, (vert1.z+vert2.z)/2);
	}

	//WIP
	// void setNeighbors(int s1, int s2, int s3) {
	// 	println(dw.spaces);
	// 	// n1 = dw.spaces.get(s1);
	// 	// n2 = dw.spaces.get(s2);
	// 	// n3 = dw.spaces.get(s3);
	// }

	public void drawNeighborVectors() {
		//n1 = red
		stroke(0, 255, 255, 200);
		PVector n1mid = getMidpoint(v1, v2);
		line(c.x, c.y, c.z, n1mid.x, n1mid.y, n1mid.z);
		
		//n2 = green
		stroke(85, 255, 255, 200);
		PVector n2mid = getMidpoint(v2, v3);
		line(c.x, c.y, c.z, n2mid.x, n2mid.y, n2mid.z);
		
		//n3 = blue
		stroke(170, 255, 255, 200);
		PVector n3mid = getMidpoint(v3, v1);
		line(c.x, c.y, c.z, n3mid.x, n3mid.y, n3mid.z);
	}

	// moved to daisyworld
	// PVector pointToSphere(PVector p) {
	// 	float mag = sqrt(p.x*p.x + p.y*p.y + p.z*p.z);
	// 	return new PVector(dw.size*p.x/mag, dw.size*p.y/mag, dw.size*p.z/mag);		
	// }	
}
  public void settings() { 	size(900, 900, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
