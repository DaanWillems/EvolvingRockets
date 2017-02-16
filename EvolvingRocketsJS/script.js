var maxspeed = 2;
var lifeSpan = 200;
var count = 0;
var popSize = 1;
var c = document.getElementById("myCanvas");
var ctx = c.getContext("2d");
var width = c.width;
var height = c.height;
var size = 10;
var pop = new Population();

setInterval(function() {pop.Update();}, 13);

function Vector() {
	
	this.x = 0;
	this.y = 0.0;
	
	this.heading = function() {
		
	}
	
	this.setMag = function(newMag) {
	
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
	}
}

function Dna() {
	this.genes = [];
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
	
	this.pos = new Vector();
	this.vel = new Vector();
	
	this.pos.x = width/2;
	this.pos.y = height-50;
	
	this.Update = function() {
		
		if(!this.Crashed) {
			this.ApplyForce();
			this.IsCrashed();
		}
		
		this.Draw();
		
	}
	
	this.ApplyForce = function() {
		this.vel.add(this.dna.genes[count]);
		this.vel.norm();
		this.pos.add(this.vel);
	};
	
	this.IsCrashed = function() {
		if(this.pos.x + size > width || this.pos.x < 0) {
			this.Crashed = true;
		}	

		if(this.pos.y + size > height || this.pos.y < 0) {
			this.Crashed = true;
		}			
	}
	
	this.Draw = function() {
		console.log(this.pos.x, this.pos.y, this.pos.getMag());
		ctx.fillStyle="white";
		ctx.fillRect(this.pos.x, this.pos.y, size ,size)
	};
}

function Obstacle() {
	
	
}