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
boolean draggingTarget;
double avfit;

void setup() {
  size(1000,600);
  
  avfit = 0;
  obstacles = new ArrayList<Obstacle>();
  
  useObst = true;

  popSize = 1000;

  lifespan = 300;

  pop = new Population();
  
  step = 0;
  
  //init target
  tx = width/2;
  ty = 220;
  tw = 20;
  th = 20;
  
  //Define standard obstacles
  //obstacles.add(new Obstacle(new PVector(width/2-150, height/2+180), new PVector(width/2+150, height/2+200)));
  //obstacles.add(new Obstacle(new PVector(width/2-150, 150), new PVector(width/2+150, 170)));
 // obstacles.add(new Obstacle(new PVector(width/2-150, 170), new PVector(width/2-130, 500)));
  obstacles.add(new Obstacle(new PVector(width/2+130, 170), new PVector(width/2+150, 500))); 
}


//Function for creating obstacles
void mouseClicked() {
  if(dist(mouseX, mouseY, tx, ty) < 10) {
    if(draggingTarget) {
      draggingTarget = false;
    } else {
      draggingTarget = true; 
    }
  } else {
   if(selecting) {
     selecting = false; 
     obstacles.add(new Obstacle(mBegin, mEnd));
    } else {
      selecting = true;
      mBegin = new PVector(mouseX, mouseY);
    }
  }
}

void keyPressed() {
  if(keyCode == 68) {
    ArrayList<Obstacle> newObst = new ArrayList<Obstacle>();
    for(Obstacle o : obstacles) {
      if(!o.CheckCollision(mouseX, mouseY)) {
       newObst.add(o);
      }
    }
    obstacles = newObst;
  }
}

class Obstacle {
  PVector begin;
  PVector end;
  
  Obstacle(PVector _b, PVector _e) {
    
    float minx;
    float miny;
    float maxx;
    float maxy;
    
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
    
    begin = new PVector(minx, miny);
    end = new PVector(maxx, maxy);
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
   
  boolean CheckCollision(float xpos, float ypos) {
    PVector rpos = new PVector(xpos, ypos);
      if(rpos.x > begin.x && rpos.x < end.x && rpos.y > begin.y && rpos.y < end.y) {
         return true;
      }
      return false;
   }
   
     boolean CheckCollision(float x2, float y2, int width2, int height2) {
     float x1 = begin.x;
     float y1 = begin.y;
     
     float width1 = end.x-begin.x;
     float height1 = end.y-begin.y;
     
     print(width1 + " || " + height1 + "\n"); 
     
     if(x1 < x2 + width2 &&
       x1 + width1 > x2 &&
       y1 < y2+height2 &&
       height1+y1 > y2) {
        return true; 
       }
      return false;
   }
}

void draw() {
  background(0);
  
  int squareSize = 20;
  
  for(int x = 0; x < height; x += squareSize) {
    for(int i = 0; i < width; i += squareSize) {
      boolean col = false;
      for(Obstacle o :obstacles) {
        if(o.CheckCollision(i, x, squareSize, squareSize)) {
          col = true;
        }
      }
      if(col) {
        fill(color(255, 0, 0, 255));
      } else {
       fill(color(0, 0, 255, 50)); 
      }
      rect(i, x, squareSize, squareSize);
    }
  }
    
  //Draw text
  textSize(17);
  text("Count: "+step+"/"+lifespan ,10, 17);
  text("Avg fitness: "+avfit ,10, 34);
    
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
  
  if(draggingTarget) {
   tx = mouseX;
   ty = mouseY;
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
      double totfit = 0;
      for(int i = 0; i < rockets.length; i++) {
        Rocket r = rockets[i];
        r.CalcFitness();
        r.count = 0;
        totfit += r.fitness;
        if(r.fitness > maxfit) {
          maxfit = r.fitness;
        }
      }
      avfit = totfit / popSize;
     
   
     
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
    v.setMag(2);
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