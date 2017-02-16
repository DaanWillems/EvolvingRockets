var maxspeed = 2;
var lifeSpan = 200;
var count = 0;
var popSize = 20;
var c = document.getElementById("myCanvas");
var ctx = c.getContext("2d");
var rockets = []
var width = c.width;
var height = c.height;

var rocket = new Rocket();

rocket.Draw();

var pop = new Population();
pop.Init();




function Gene() {
	this.xAcc = Math.random();
	this.xAcc -= 0.5;
	
	this.yAcc = Math.random();
	this.yAcc -= 0.5;
}

function Population() {

	

	
	this.MakeRocket = function() {
		
		if(rockets.length < popSize) {
			rockets.push(new Rocket());
			window.setTimeout(this.MakeRocket, 5);
		}
	}
	
	
	this.Update = function() {
		if(count > lifeSpan-2) {
			this.Init();
			count = 0;
		}
		ctx.clearRect(0, 0, width, height);
		for(i = 0; i < rockets.length; i++) {
			rockets[i].Update();
		}
		count++;
	}
	
	this.Init = function() {
		
		var i = 0;
		
		this.MakeRocket();
		setInterval(function(){ this.Update(); }, 20);
	}
}

function Dna() {
	this.genes = [];
	for(i = 0; i < lifeSpan; i++) {
		this.genes.push(new Gene());
	}
}

function Rocket() {
	
	this.dna = new Dna();
	
	this.Crashed = false;
	
	this.xPos = width/2;
	this.yPos = height/2;
	
	this.xVel = 0;
	this.yVel = 0;
	
	this.Update = function() {
		this.ApplyForce();
		this.Draw();
	}
	
	this.ApplyForce = function() {
		this.xVel += this.dna.genes[count].xAcc;
		this.yVel += this.dna.genes[count].yAcc;
		if(!this.Crashed) {
			this.xPos += this.xVel;
			this.yPos += this.yVel;
		} else {
			xVel = 0.0;
			yVel = 0.0;
		}
		
		if(this.xVel > maxspeed) {
			this.xVel = maxspeed;
		}
		if(this.yVel > maxspeed) {
			this.yVel = maxspeed;
		}
		console.log(this.dna.genes[count].xAcc);
		console.log(this.dna.genes[count].yAcc);
		this.IsCrashed();
	};
	
	this.IsCrashed = function() {
		if (this.xPos > width || this.xPos < 0) {
		  this.Crashed = true;
		}
		if (this.yPos > height || this.yPos < 0) {
		  this.Crashed = true;
		} 
	}
	
	this.Draw = function() {
		ctx.fillRect(this.xPos, this.yPos, 10 ,10)
	};
}

function Obstacle() {
	
	
}