void setup() {
  size(700, 500);
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
}
