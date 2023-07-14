Flock flock;
color white = color(255);
color red = color(255,0,0);
color blue = color(0,0,255);

void setup() {
  size(1024, 720);
  flock = new Flock();
  int cantidad_pajaros = 10;
  // Add an initial set of boids into the system
  for (int i = 0; i < cantidad_pajaros; i++) {
    flock.addBoid(new Boid(width/2,height/2, blue));
  }
  //Aqui debería setear al lider de manera distinta a la bandada.
  flock.addLeader(new Leader(width/2 + 20,height/2 + 20, red));
}

void draw() {
  //SE DECLARA EL COLOR DE FONDO EN RGB
  background(0,0,0);
  flock.run();
}
