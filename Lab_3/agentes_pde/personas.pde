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
    magnitude = 5.0;
    maxSpeed = 2.0;
    maxForce = 0.03;
    radius = 7.5;
  }
  
  void update() {
    PVector target = getTarget();
    PVector desired = PVector.sub(target, position);
    desired.normalize();
    desired.mult(maxSpeed);

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);

    velocity.add(steer);
    velocity.limit(maxSpeed);
    
    position.add(velocity);
    
    checkCollisionsWithPilares();
    applyRepulsionBetweenPersons();
  }

  PVector getTarget() {
    if (position.y <= 224) {
      return new PVector(600, 224);
    } else if (224 < position.y && position.y < 276) {
      return new PVector(600, position.y);
    } else {
      return new PVector(600, 276);
    }
  }

  void checkCollisionsWithPilares() {
    PVector pilarGrandePos = new PVector(200, 200);
    float pilarGrandeDiametro = 50;
    PVector pilarChicoPos = new PVector(380, 280);
    float pilarChicoDiametro = 30;

    // Comprobar colisión con pilar grande
    if (position.dist(pilarGrandePos) < radius + pilarGrandeDiametro / 2) {
      PVector direccion = PVector.sub(position, pilarGrandePos);
      direccion.normalize();
      position.add(direccion);
    }

    // Comprobar colisión con pilar chico
    if (position.dist(pilarChicoPos) < radius + pilarChicoDiametro / 2) {
      PVector direccion = PVector.sub(position, pilarChicoPos);
      direccion.normalize();
      position.add(direccion);
    }
  }

  void applyRepulsionBetweenPersons() {
    float radioInteraccion = 25.0;

    for (Person otraPersona : people) {
      if (this != otraPersona) {
        float distancia = position.dist(otraPersona.position);

        if (distancia < radioInteraccion) {
          PVector direccion = PVector.sub(position, otraPersona.position);
          direccion.normalize();
          float factorRepulsion = map(distancia, 0, radioInteraccion, 1, 0); // Cuanto más cerca, mayor repulsión
          direccion.mult(factorRepulsion);
          velocity.add(direccion);
        }
      }
    }
  }
  
  boolean isOutsideRoom() {
    return (position.x > width || position.y < 0 || position.y > height);
  }
}
