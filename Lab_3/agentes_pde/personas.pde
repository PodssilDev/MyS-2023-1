class Persona {
  PVector posicion;
  PVector velocidad;
  float maxFuerza;
  float maxVelocidad;
  float radio;
  
  // Constructor
  Persona() {
    // Se asume que todas las personas comienzan con x igual a 5 e y igual a un número en el rango [15, 485]
    posicion = new PVector(5, random(15, 486));
    velocidad = new PVector();
    maxVelocidad = 2.0;
    maxFuerza = 0.03;
    radio = 7.5;
  }
  
  // Descripción: Actualiza la dirección de movimiento, velocidad y posición de una persona.
  void update() {
    PVector direccionDeseada = getDireccionDeseada();
    // Calcula la dirección necesaria para alinear el movimiento con la dirección deseada
    PVector direccion = PVector.sub(direccionDeseada, velocidad);
    direccion.limit(maxFuerza);
    // Cambiar velocidad en torno a la dirección que no supere la velocidad máxima
    velocidad.add(direccion);
    velocidad.limit(maxVelocidad);
    // Actualiza la posición
    posicion.add(velocidad);
    applyRepulsion();
  }
  
  // Descripción: Obtiene la dirección deseada de movimiento según la posición actual de una persona. 
  // Salida: Vector que indica hacia donde se dirigue la dirección deseada de la persona.
    PVector getDireccionDeseada() {
      float y = 0.0;
    if (posicion.y <= 224) {
      // Parte superior de la sala
      y = 224;
    } else if (224 < posicion.y && posicion.y < 276) {
      // Frente a la salida
      y = posicion.y;
    } else {
      // Parte inferior de la sala
      y = 276;
    }
    // Dirección salida
    PVector movimiento = new PVector(600, y);
    PVector direccionDeseada = PVector.sub(movimiento, posicion);
    // Vector unitario que no supera la velocidad máxima
    direccionDeseada.normalize();
    direccionDeseada.mult(maxVelocidad);
    return direccionDeseada;
  }

  // Descripción: Aplica las fuerzas de repulsión de paredes y pilares y la fuerza de roce con otras personas que se encuentren en un radio R.
  void applyRepulsion() {
    // Radio de la vecindad que permite que otras personas y fuerzas ejerzan fuerzas sobre la persona
    float R = 25.0;

    // Fuerzas de otras personas
    for (Persona persona : personas) {
      if (this != persona) {
        float distancia = posicion.dist(persona.posicion);
        // Se encuentra dentro del radio R
        if (distancia < R) {
          // Dirección de persona actual a la otra persona
          PVector direccion = PVector.sub(posicion, persona.posicion);
          direccion.normalize();
          // La fuerza de repulsión es aplicada considerando la distancia a la que se encuentran ambas personas
          float factorRepulsion = map(distancia, 0, R, 1, 0);
          direccion.mult(factorRepulsion);
          velocidad.add(direccion);
        }
      }
    }

    // Repulsión de los pilares
    PVector pilarG = new PVector(200, 200);
    PVector pilarC = new PVector(380, 280);
    PVector direccionPilarG = PVector.sub(posicion, pilarG);
    PVector direccionPilarC = PVector.sub(posicion, pilarC);
    float radioPilarG = 25; 
    float radioPilarC = 15; 

    // Pilar grande
    if (direccionPilarG.mag() < R + radioPilarG) {
      float distanciaPilarG = direccionPilarG.mag() - radioPilarG;
      direccionPilarG.normalize();
      // La fuerza de repulsión depende de la distancia a la que se encuentre la persona
      float factorRepulsion = map(distanciaPilarG, 0, R, 1, 0);
      direccionPilarG.mult(factorRepulsion);
       velocidad.add(direccionPilarG);
    }

    // Pilar chico
    if (direccionPilarC.mag() < R + radioPilarC) {
      float distanciaPilarC = direccionPilarC.mag() - radioPilarC;
      direccionPilarC.normalize();
      float factorRepulsion = map(distanciaPilarC, 0, R, 1, 0);
      direccionPilarC.mult(factorRepulsion);
      velocidad.add(direccionPilarC);
    }    

    // Repulsión de las paredes
    if (distanciaPuntoLinea(posicion.x, posicion.y, 0, 0, 600, 216) < R + 5) {
      PVector direccionParedS = PVector.sub(posicion, new PVector(0, 0));
      float distanciaParedS = distanciaPuntoLinea(posicion.x, posicion.y, 0, 0, 600, 216) - 10;
      direccionParedS.normalize();
      float factorR = map(distanciaParedS, 0, R, 1, 0);
      direccionParedS.mult(factorR);
      velocidad.add(direccionParedS);
    }
    
    
    if (distanciaPuntoLinea(posicion.x, posicion.y, 600, 284, 0, 500) < R + 5) {
      PVector direccionParedI = PVector.sub(posicion, new PVector(0, 500));
      float distanciaParedI = distanciaPuntoLinea(posicion.x, posicion.y, 600, 284, 0, 500) - 5;
      direccionParedI.normalize();
      float factorR = map(distanciaParedI, 0, R, 1, 0);
      direccionParedI.mult(factorR);
      velocidad.add(direccionParedI);
    }
  }
  
  float distanciaPuntoLinea(float x, float y, float x1, float y1, float x2, float y2) {
  float A = x - x1;
  float B = y - y1;
  float C = x2 - x1;
  float D = y2 - y1;

  float distancia = abs(A * D - C * B) / sqrt(C * C + D * D);

  return distancia;
  }

  boolean isOutsideRoom() {
    return (posicion.x > 600);
  }
}
