ArrayList<Persona> personas;

void setup() {
  size(700, 500);
  int numPeople = 100;
   personas = new ArrayList<Persona>();
   // Crear personas aleatorias en el extremo izquierdo de la sala
  for (int i = 0; i < numPeople; i++) {
    Persona person = new Persona();
    personas.add(person);
  }
  
}

void draw() {
  background(255);
  
  // Dibujar la pared superior
  stroke(0);
  line(0, 0, 600, 216);
  
  // Dibujar la pared inferior
  line(600, 284, 0, 500);
  
  // Dibujar el pilar más grande
  fill(150);
  ellipse(200, 200, 50, 50);
  
  // Dibujar el pilar más pequeño
  ellipse(380, 280, 30, 30);
  
  fill(0);
  /*
  for (Person person : people) {
    person.update();
    ellipse(person.position.x, person.position.y, 7.5, 7.5);
    
    
  }
  */
  for (int i = personas.size() - 1; i >= 0; i--) {
    Persona persona = personas.get(i);
    persona.update();
     ellipse(persona.posicion.x, persona.posicion.y, 7.5, 7.5);

    // Verificar si la persona está fuera de la sala y eliminarla del array
    if (persona.isOutsideRoom()) {
      personas.remove(i);
    }
  }
  
}
  
