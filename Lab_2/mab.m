% Descripción: Función que calcula la función de transferencia de un 
% modelo de estado matricial.
% Entradas: Matrices A, B, C y D del modelo de estado matricial del sistema.
% Salida: Función de transferencia del sistema.
function H = mab(A,B,C,D)
% Matriz identidad 2x2.
I = eye(2);
% Se define el modelo para las funciones de transferencia.
s = tf('s');
% Utiliza fórmula para calcular la función de transferencia.
sI_A = s*I - A;
inversa = inv(sI_A);
H = C*inversa*B + D;
end