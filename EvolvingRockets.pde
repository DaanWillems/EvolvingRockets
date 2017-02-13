//Create obstacle variables
boolean selecting;
PVector mBegin;
PVector mEnd;

//Simulation Variables
ArrayList<Obstacle> obstacles; 
int lifespan;
int popSize;
boolean useObst;
Population pop;

//Target Variables
int tx, ty, tw, th;

//General
int step;

void setup() {
  size(1000,600);
  
  obstacles = new ArrayList<Obstacle>();
  
  useObst = true;

  popSize = 100;

  lifespan = 300;

  pop = new Population();
  
  step = 0;
  
  //init target
  tx = width/2;
  ty = 50;
  tw = 20;
  th = 20;
  
  //Define standard obstacles
  obstacles.add(new Obstacle(new PVector(width/2-150, height/2+180), new PVector(width/2+150, height/2+200)));
  obstacles.add(new Obstacle(new PVector(width/2-150, 150), new PVector(width/2+150, 170)));
  obstacles.add(new Obstacle(new PVector(width/2-150, 150), new PVector(width/2-130, 500)));
  obstacles.add(new Obstacle(new PVector(width/2+130, 150), new PVector(width/2+150, 500)));
}


//Function for creating obstacles
void mouseClicked() {
  if(selecting) {
   selecting = false; 
   obstacles.add(new Obstacle(mBegin, mEnd));
  } else {
    selecting = true;
    mBegin = new PVector(mouseX, mouseY);
  }
}

class Obstacle {
  PVector begin;
  PVector end;
  
  Obstacle(PVector _b, PVector _e) {
    begin = _b;
    end = _e;
  }
  
  //Speaks for itself
  void Draw() {
    rect(begin.x, begin.y, end.x-begin.x, end.y-begin.y); 
  }
  
  //Checks if rocket has collided
  void CheckCollision(Rocket r) {
    PVector rpos = r.pos;
      if(rpos.x > begin.x && rpos.x < end.x && rpos.y > begin.y && rpos.y < end.y) {
         r.crashed = true;
      }
   }
}

void draw() {
  background(0);
    
  //Draw current mouseSelection
  mEnd = new PVector(mouseX, mouseY);
  if(mBegin != null) {
    if(selecting) {
      rect(mBegin.x, mBegin.y, mEnd.x-mBegin.x, mEnd.y-mBegin.y); 
    }
  }

  if(step >= lifespan) {
    delay(100);
    pop.Evolve();
    step = 0;
  } else {
    pop.Update();
    step++;
  }
  
  
  //Draw target
  ellipse(tx, ty, tw, th);
  //Draw obstacles
  if(useObst) {
    for(Obstacle o : obstacles) {
      o.Draw();
    }
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
      for(Obstacle o : obstacles) {
      o.CheckCollision(this);
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