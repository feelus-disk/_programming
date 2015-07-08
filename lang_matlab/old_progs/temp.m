u = -3 : 0.1 : 3;
[ X , Y ] = meshgrid( u, u );
Z = exp( - X.^2 - Y.^2 );
plot3( X, Y, Z );