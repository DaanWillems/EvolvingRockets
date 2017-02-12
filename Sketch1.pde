
Rocket r;
int lifespan;
int step;
int popSize;
boolean useObst;
Population pop;

int tx, ty, tw, th, ox, oy, ow, oh, ox1, oy1, ow1, oh1;

void setup() {
  size(1000,600);

  useObst = true;

  popSize = 50;

  lifespan = 500;

  pop = new Population();
  
  step = 0;
  
  //init target
  tx = width/2;
  ty = 50;
  tw = 20;
  th = 20;
  
  //Init obstacle
  ox = 0;
  oy = 200;
  ow = 550;
  oh = 20;
  
  ox1 = width-550;
  oy1 = 400;
  ow1 = 550;
  oh1 = 20;
}

void draw() {
    background(0);

  if(step >= lifespan) {
    delay(100);
    pop.Evolve();
    step = 0;
  }
  else {
    pop.Update();
    step++;
  }
  
  
  //Draw target
  ellipse(tx, ty, tw, th);
  //Draw obstacle
  if(useObst) {
    rect(ox, oy, ow, oh);
    rect(ox1, oy1, ow1, oh1);
  }
}

class Population {
  Rocket[] rockets;
  
  Population() {
       rockets = new Rocket[popSize];  //<>//
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
    
    void CalcFitness() {
      double maxfit = 0;
      for(int i = 0; i < rockets.length; i++) {
        Rocket r = rockets[i];
        r.CalcFitness();
        r.count = 0;
        if(r.fitness > maxfit) {
          maxfit = r.fitness;
        }
      }
     
      for(int i = 0; i < rockets.length; i++) {
       rockets[i].fitness /= maxfit; 
      }
    }
    
    void Evolve() {
      CalcFitness();
      
      ArrayList<Rocket> matingpool = new ArrayList<Rocket>();
      for(int i = 0; i < popSize; i++) {
        double n = rockets[i].fitness * 100;
        for(int x = 0; x < n; x++) {
         matingpool.add(rockets[i]);
        }
      }
      Rocket newRockets[] = new Rocket[rockets.length];
      for(int i = 0; i < newRockets.length; i++) {
        //Selection
        Rocket father = matingpool.get((int) random(0, matingpool.size() - 1));
        Rocket mother = matingpool.get((int) random(0, matingpool.size() - 1));
        
        Rocket child = father.CrossOver(mother);
        child.Mutate();
        newRockets[i] = child;
      }
      matingpool.clear();
      rockets = newRockets; 
    }
}

class DNA {
  
 public PVector[] genes;
 
 DNA() {
   genes = new PVector[lifespan];
   
   genes[0] = new PVector(0, -10);
   genes[0].setMag(1);
  for (int i = 1; i < genes.length; i++) {
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
 double fitness = 0;
 boolean completed;
 boolean crashed;
 
 Rocket() {
   dna = new DNA();
   
   count = 0;
   completed = false;
   pos = new PVector(width/2,height-25); 
   vel = new PVector(0,0);
 }
 
 void Update() {
   
   if(!completed && !crashed) {
     ApplyForce(dna.genes[count]); //<>//
     count++;
     vel.limit(4);

     MadeIt();
     Crashed();
   }
   else {
    vel = new PVector(); 
   }
 }
 
 void Crashed() {
    if (pos.x > width || pos.x < 0) {
      crashed = true;
    }
    if (pos.y > height || pos.y < 0) {
      crashed = true;
    } 
    if(useObst) {
      if (this.pos.x > ox && this.pos.x < ox + ow && this.pos.y > oy && this.pos.y < oy + oh) {
        this.crashed = true;
      }
      if (this.pos.x > ox1 && this.pos.x < ox1 + ow1 && this.pos.y > oy1 && this.pos.y < oy1 + oh1) {
        this.crashed = true;
      }
    }
 }
 
 void Mutate() {
     for (int i = 0; i < dna.genes.length; i++) {
      if (random(1) < 0.01) {
        dna.genes[i] = PVector.random2D();
        dna.genes[i].setMag(0.6);
      }
    }
  }
 
 void MadeIt() {
    float d = dist(pos.x, pos.y,tx, ty);
    if (d < 10) {
      completed = true;
    }
 }
 
 void ApplyForce(PVector v) {
   vel.add(v);
   pos.add(vel);
   vel.limit(4);
 }
 
 void CalcFitness() {
  float d = dist(pos.x, pos.y, tx, ty);
  fitness = map(d, 0, width, width, 0);
  
  if(completed) {
   fitness *= 10; 
  }
  if(crashed) {
   fitness /= 10;
  }
  
  print("Fitness {0} \n", fitness);
 }
 
 Rocket CrossOver(Rocket partner) {
   PVector[] newGenes = new PVector[lifespan];
   int mid = floor(random(dna.genes.length));
   
    for (int i = 0; i < dna.genes.length; i++) {
      if (i > mid) {
        newGenes[i] = dna.genes[i];
      } else {
        newGenes[i] = partner.dna.genes[i];
      }
    }
    Rocket newRocket = new Rocket();
    newRocket.dna.genes = newGenes;
    return newRocket;
 }
 
 void Show() {
   rect(pos.x, pos.y, 10, 10); //<>//
 }
}