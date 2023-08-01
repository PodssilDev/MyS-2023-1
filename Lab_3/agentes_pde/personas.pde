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

    // Repulsión de las paredes
    // Si la persona está cerca de la pared superior
    if (distanciaPuntoLinea(posicion.x, posicion.y, 0, 0, 600, 216) < R + radio) {
      PVector direccionParedS = PVector.sub(posicion, new PVector(0, 0));
      // Calcula la distancia desde la posición actual de la persona hasta la pared superior, restando el radio de la persona
      float distanciaParedS = distanciaPuntoLinea(posicion.x, posicion.y, 0, 0, 600, 216) - radio;
      direccionParedS.normalize();
      // Calcula la fuerza de repulsión ejercida dependiendo de la distancia a la cual se encuentra la persona
      float factorR = map(distanciaParedS, 0, R, 1, 0);
      direccionParedS.mult(factorR);
      velocidad.add(direccionParedS);
    }
    
    // Si la persona está cerca de la pared inferior
    if (distanciaPuntoLinea(posicion.x, posicion.y, 600, 284, 0, 500) < R + 5) {
      PVector direccionParedI = PVector.sub(posicion, new PVector(0, 500));
      // Calcula la distancia desde la posición actual de la persona hasta la pared inferior, restando el radio de la persona
      float distanciaParedI = distanciaPuntoLinea(posicion.x, posicion.y, 600, 284, 0, 500) - radio;
      direccionParedI.normalize();
      // Calcula la fuerza de repulsión ejercida dependiendo de la distancia a la cual se encuentra la persona
      float factorR = map(distanciaParedI, 0, R, 1, 0);
      direccionParedI.mult(factorR);
      velocidad.add(direccionParedI);
    }

    // Repulsión de los pilares
    PVector pilarG = new PVector(200, 200);
    PVector pilarC = new PVector(380, 280);
    PVector direccionPilarG = PVector.sub(posicion, pilarG);
    PVector direccionPilarC = PVector.sub(posicion, pilarC);
    float radioPilarG = 25; 
    float radioPilarC = 15; 

    // Si la persona está cerca del pilar grande
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
      // La fuerza de repulsión depende de la distancia a la que se encuentre la persona
      float factorRepulsion = map(distanciaPilarC, 0, R, 1, 0);
      direccionPilarC.mult(factorRepulsion);
      velocidad.add(direccionPilarC);
    }    
    
    // Repulsión entre personas
    for (Persona persona : personas) {
      if (this != persona) {
        float distancia = posicion.dist(persona.posicion);
        // Se encuentra dentro del radio R y no atraviesa las paredes
        if (distancia < R && !(distanciaPuntoLinea(posicion.x, posicion.y, 0, 0, 600, 216) < R) && !(distanciaPuntoLinea(posicion.x, posicion.y, 600, 284, 0, 500) < R)) {
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
  }
  
// Descripción: Calcula la distancia de un punto (x, y) a una línea definida por dos puntos (x1, y1) y (x2, y2).
// Entrada: Coordenadas del punto (x, y) y las coordenadas de los dos puntos que definen la línea (x1, y1) y (x2, y2).
// Salida: Distancia del punto a la línea.
  float distanciaPuntoLinea(float x, float y, float x1, float y1, float x2, float y2) {
    float A = x - x1;
    float B = y - y1;
    float C = x2 - x1;
    float D = y2 - y1;
    float distancia = abs(A * D - C * B) / sqrt(C * C + D * D);
    return distancia;
  }

// Descripción: Verifica si la persona se encuentra fuera de la sala.
// Salida: true si la persona está fuera de la sala, false si no lo está.
  boolean isOutsideRoom() {
    return (posicion.x > 650);
  }
}
