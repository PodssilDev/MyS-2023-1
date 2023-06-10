function [A,B,C,D] = bam(a,b,c,d,e,f)
% Calcula las matrices del modelo de estado según resultado algebraico
% presentado en el informe.
A = [c/b -a/b ; d/e f/e];
B = [a/b ; 0];
C = [1 0];
D = 0;
end