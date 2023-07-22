class Person {
  PVector position;
  PVector velocity;
  PVector direction;
  float maxForce;
  float maxSpeed;
  float radius;
  float magnitude;
  
  Person() {
    int y = int(random(15, 486));
    position = new PVector(5, y);
    direction = new PVector(1, 0);
    velocity = new PVector();
    /*
    float angle = atan(5/y);
    velocity = new PVector(cos(angle), sin(angle));
    */
    magnitude = 5.0;
    maxSpeed = 2.0;
    maxForce = 0.03;
    radius = 7.5;
  }
  
  void update() {
    
    if(position.y <= 224) {
    }
    else if(224 < position.y && position.y < 276){
      float angle = random(TWO_PI);
      velocity = new PVector(cos(angle), sin(angle));
      position.add(velocity);
      text("¡Hola, mundo!", 200, 100);
    }
    else{
    }
    
    /*
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    position.add(velocity);
    */
    
  }
  
 
}
