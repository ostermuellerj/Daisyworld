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

	void display() {
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

	void displayCentroid() {
		text(dw.spaces.indexOf(this), c.x, c.y, c.z);
		point(c.x, c.y, c.z);
	}

/*
	Builds this Space's verts by matching up neighbors.
*/
	void makeVerts() {
		v1 = getCommonVertex(n1, n3);
		v2 = getCommonVertex(n1, n2);
		v3 = getCommonVertex(n2, n3);
	}

/*
	Return a common vertex between two triangles.
*/
	PVector getCommonVertex(Space s1, Space s2) {
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
	void setCentroid() {
		this.c = new PVector((v1.x+v2.x+v3.x)/3, (v1.y+v2.y+v3.y)/3, (v1.z+v2.z+v3.z)/3);
	}

	PVector getMidpoint(PVector vert1, PVector vert2) {
		return new PVector((vert1.x+vert2.x)/2, (vert1.y+vert2.y)/2, (vert1.z+vert2.z)/2);
	}

	//WIP
	// void setNeighbors(int s1, int s2, int s3) {
	// 	println(dw.spaces);
	// 	// n1 = dw.spaces.get(s1);
	// 	// n2 = dw.spaces.get(s2);
	// 	// n3 = dw.spaces.get(s3);
	// }

	void drawNeighborVectors() {
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
