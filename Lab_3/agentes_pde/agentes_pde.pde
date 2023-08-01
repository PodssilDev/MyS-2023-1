ArrayList<Persona> personas;

/* 
LABORATORIO 3 MODELOS Y SIMULACIÓN

INTEGRANTES
- VANINA CORREA CHÁVEZ
- JOHN SERRANO CARRASCO

*/

void setup() {
  // Tamaño del lienzo
  size(700, 500);
  int numPersonas = 100;
   personas = new ArrayList<Persona>();
   // Crea personas al inicio de la sala y guarda el objeto en un arreglo
  for (int i = 0; i < numPersonas; i++) {
    Persona persona = new Persona();
    personas.add(persona);
  }
}

void draw() {
  background(255);
  
  // Pared superior
  stroke(0);
  line(0, 0, 600, 216);
  // Pared inferior
  line(600, 284, 0, 500);
  // Pilar grande
  fill(150);
  ellipse(200, 200, 50, 50);
  // Pilar más pequeño
  ellipse(380, 280, 30, 30);
  fill(0);

  // Dibuja la posición actual de todas las personas 
  for (int i = personas.size() - 1; i >= 0; i--) {
    Persona persona = personas.get(i);
    persona.update();
     ellipse(persona.posicion.x, persona.posicion.y, 7.5, 7.5);
    // Verifica si la persona está fuera de la sala para eliminarla 
    if (persona.isOutsideRoom()) {
      personas.remove(i);
    }
  }
  
  // Generación de personas aleatorias de manera constante cada 5 fotogramas
  if (frameCount % 5 == 0) {
    personas.add(new Persona());
  }
}
  
