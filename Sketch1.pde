
Rocket r;
int lifespan;
int step;

Population pop;


void setup() {
  size(1000,600);

  pop = new Population();
  
  lifespan = 200;
  step = 0;
}

void draw() {
    background(0);

  pop.Update();
  step++;
  
  if(step >= lifespan) {
    pop = new Population();
    step = 0;
  }
}

class Population {
  Rocket[] rockets;
  
  Population() {
       rockets = new Rocket[7];  //<>//
       for(int i = 0; i < rockets.length; i++) {
         rockets[i] = new Rocket();
       }
    }
    
    void Update() {
      for(int i = 0; i < rockets.length; i++) {
        Rocket r = rockets[i];
        r.Update();
        r.Show();
    } 
  }
}

class DNA {
  
 public PVector[] genes;
 
 DNA() {
   genes = new PVector[200];
   
  for (int i = 0; i < genes.length; i++) {
    PVector v = PVector.random2D();
    v.setMag(0.6);
    genes[i] = v;
  }
 }
}

class Rocket {
  
 PVector pos, vel, acc;
 DNA dna;
 int count;
 
 Rocket() {
   dna = new DNA();
   
   count = 0;
   
   pos = new PVector(width/2,height-25); 
   vel = new PVector(0,0);
 }
 
 void Update() {
   ApplyForce(dna.genes[count]); //<>//
   count++;
   vel.limit(4);
 }
 
 void ApplyForce(PVector v) {
   vel.add(v);
   pos.add(vel);
   vel.limit(4);
 }
 
 void Show() {
   rect(pos.x, pos.y, 10, 10); //<>//
 }
}