class Daisy {

	float age;
	int id;
	Space space;

	//old
	PVector loc;


	Daisy (int id_) {
		id = id_;
		// try {
			// space = dw.spaces.get(id);
		// } catch (Exception e) {
		// 	println(e);
		// }
	}

	// old
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

	BDaisy (int id_) {
		super(id_);
	}

	@Override
	void display () {
		// println("BDaisy display");
		fill(0, 0, 0, 255*(age/1000));
		// stroke(60, 100, 255, min(150*(age/5000), 150));
		noStroke();
		// strokeWeight(1);
		// dw.drawQuad(loc, 0.5);
		beginShape();
		try {
			space = dw.spaces.get(id);
			
			// pushMatrix();
			// 	translate(space.c.x, space.c.y, space.c.z);
			// 	sphere(10);
			// popMatrix();
			
			vertex(space.verts[0].x,space.verts[0].y,space.verts[0].z);
			vertex(space.verts[1].x,space.verts[1].y,space.verts[1].z);
			vertex(space.verts[2].x,space.verts[2].y,space.verts[2].z);

			// vertex(space.verts[0].x,space.verts[0].y,space.verts[0].z);
			// vertex(space.verts[1].x,space.verts[1].y,space.verts[1].z);
			// vertex(space.verts[2].x,space.verts[2].y,space.verts[2].z);
		} catch (Exception e) {
			// println(e);
		}
		endShape(CLOSE);

	 	pushMatrix();
	 		float phi = atan2(space.c.z,space.c.x);
	 		float theta = atan2(space.c.z,space.c.y);
	 		rotateY(phi);
	 		rotateX(theta);
			pushMatrix();		
	 		drawDaisy(10, 15, dist(0,0,0,space.c.x,space.c.y,space.c.z));
	 		popMatrix();			
	 	popMatrix();
		noFill();
	}
}

class WDaisy extends Daisy {
	
	WDaisy (int id_) {
		super(id_);	
	}

	void display () {
		fill(0, 0, 255, 255*(age/1000));
		// stroke(60, 100, 255, min(150*(age/5000), 150));
		noStroke();
		// strokeWeight(1);
		// dw.drawQuad(loc, 0.5);
		beginShape();
		// try {
			space = dw.spaces.get(id);
			
			// pushMatrix();
			// 	translate(space.c.x, space.c.y, space.c.z);
			// 	sphere(10);
			// popMatrix();

			vertex(space.verts[0].x,space.verts[0].y,space.verts[0].z);
			vertex(space.verts[1].x,space.verts[1].y,space.verts[1].z);
			vertex(space.verts[2].x,space.verts[2].y,space.verts[2].z);

		// 	vertex(space.verts[0].x,space.verts[0].y,space.verts[0].z);
		// 	vertex(space.verts[1].x,space.verts[1].y,space.verts[1].z);
		// 	vertex(space.verts[2].x,space.verts[2].y,space.verts[2].z);
		// }  catch (Exception e) {
		// 	println("Cannot draw WDaisy"+e);
		// }
		endShape(CLOSE);


	 	pushMatrix();
	 		float phi = atan2(space.c.z,space.c.x);
	 		float theta = atan2(space.c.z,space.c.y);
	 		rotateY(phi);
	 		rotateX(theta);
			pushMatrix();		
	 		drawDaisy(10, 10, dist(0,0,0,space.c.x,space.c.y,space.c.z));
	 		popMatrix();			
	 	popMatrix();

		noFill();
	}

}