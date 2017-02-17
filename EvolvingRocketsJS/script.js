var maxspeed = 2;
var lifeSpan = 300;
var count = 0;
var popSize = 1;
var c = document.getElementById("myCanvas");
var ctx = c.getContext("2d");
var width = c.width;
var height = c.height;
var size = 10;
var pop = new Population();

var Obstacles = [];

setInterval(function() {pop.Update();}, 13);

var v1 = new Vector(10, 10);

var v2 = new Vector(60, 60);

Obstacles.push(new Obstacle(v1, v2));

var target = new Target(new Vector(width/2, 0+50), 10);


function Vector(_x, _y) {
	
	if(_x != null && _y != null) {
		this.x = _x;
		this.y = _y;
	}
	else {
		this.x = 0.0;
		this.y = 0.0;
	}	

	this.setMag = function(newMag) {
		this.norm();
		this.x *= newMag;
		this.y *= newMag;
	}
	
	this.getMag = function() {
		return Math.sqrt(this.x*this.x + this.y*this.y);
	}
	
	this.norm = function() {
		var m = this.getMag();
		if(m > 0) {
			this.div(m);
		}
	}
	
	this.div = function(n) {
		this.x /= n;
		this.y /= n;
	}
	
	this.add = function(vector) {
		this.x += vector.x;
		this.y += vector.y;
	}
	
	this.sub = function(vector) {
		this.x -= vector.x;
		this.y -= vector.y;
	}
	
}

function Population() {
	
	this.rockets = [];
	
	//Temporary method of creating rockets to solve the annoying Math.random situation
	for(i = 0; i < popSize; i++) {
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
	}
	
	this.Evolve = function() {
		this.rockets = [];
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
		this.rockets.push(new Rocket());
	}
	
	this.Update = function() {
		//Check if we should reset
		if(count > lifeSpan-2) {
			this.Evolve();
			count = 0;
		}
		
		//Draw all rockets
		ctx.fillStyle="black";
		ctx.fillRect(0, 0, width, height);
		for(i = 0; i < this.rockets.length; i++) {
			this.rockets[i].Update();
		}
		count++;
		
		//Draw all obstacles
		for(i = 0; i < Obstacles.length; i++) {
			Obstacles[i].Draw();
		}
		//Draw target
		target.Draw();
	}
}

function Dna() {
	this.genes = [];
	//Init dna with random vectors
	for(i = 0; i < lifeSpan; i++) {
		var v = new Vector();
		v.x = Math.random()-0.5;
		v.y = Math.random()-0.5;
		this.genes.push(v);
	}
}

function Rocket() {
	
	this.dna = new Dna();
	
	this.Crashed = false;
	
	//Place rocket in the middle at the bottom of the screen
	this.pos = new Vector(width/2, height-50);
	
	this.vel = new Vector();
	
	//Update the entire rocket
	this.Update = function() {
		
		if(!this.Crashed) {
			this.ApplyForce();
			this.IsCrashed();
		}
		
		this.Draw();
		
	}
	
	//Move the rocket
	this.ApplyForce = function() {
		this.vel.add(this.dna.genes[count]);
		this.vel.norm();
		this.vel.setMag(1.6);
		this.pos.add(this.vel);
	};
	
	//Check if rocket has collided with something
	this.IsCrashed = function() {
		if(this.pos.x + size > width || this.pos.x < 0) {
			this.Crashed = true;
		}	

		if(this.pos.y + size > height || this.pos.y < 0) {
			this.Crashed = true;
		}			
	}
	
	//Draw rocket on screen
	this.Draw = function() {
		ctx.fillStyle="white";
		ctx.fillRect(this.pos.x, this.pos.y, size ,size)
	};
}

function Target(v, size) {
	this.pos = v;
	
	this.Draw = function() {
		ctx.fillStyle="white";
		ctx.beginPath();
		ctx.arc(this.pos.x, this.pos.y, size, 0, 2 * Math.PI);
		ctx.closePath();
		ctx.fill();
	}
}

function Obstacle(_b, _e) {
  
	this.minx;
    this.miny;
    this.maxx;
    this.maxy;
    
    if(_b.x < _e.x) {
     minx = _b.x; 
     maxx = _e.x;
    } else {
     minx = _e.x; 
     maxx = _b.x;
    }
    
    if(_b.y < _e.y) {
     miny = _b.y; 
     maxy = _e.y;
    } else {
     miny = _e.y;
     maxy = _b.y;
    }
    
	begin = new Vector(minx, miny);
    end = new Vector(maxx, maxy);
	
	this.Draw = function() {
		ctx.fillRect(begin.x, begin.y, end.x-begin.x, end.y-begin.y); 
	}
	
	this.Collides = function(bx, by, ex, ey) {
		
	}
}







