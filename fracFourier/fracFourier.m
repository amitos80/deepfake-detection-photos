%%%
%%% FRACTIONAL FOURIER TRANSFORM (12.14.00)
%%% Hany Farid (farid@cs.dartmouth.edu | www.cs.dartmouth.edu/~farid)
%%%

clear;
set( gcf, 'Renderer', 'zbuffer' );

dim	= 64;
ramp	= 2*pi/dim * [-dim/2 : dim/2];
f	= exp(-ramp.^2);
f	= f - min(f);
f	= f';

%%% BUILD FOURIER BASIS
c = 1;
for k = -dim/2 : dim/2
	B(c,:) = 1/sqrt(dim+1) * exp( -j * k * ramp );
	c = c + 1;
end

%%% CYCLE THROUGH FRACTIONAL FOURIER TRANSFORMS
c 	= 1;
for n = 0 : 0.1 : 2.0
	Bn = B^n;
	fn = abs( Bn * f );
	plot( fn, 'b' ); 		% PLOT FOURIER MAGNITUDE
	hold on; 
	plot( f, 'r--' ); 		% PLOT ORIGINAL SIGNAL
	hold off;
	axis( [1 dim+1 0 2] );	
	set( gca, 'Xtick', [], 'Ytick', [] );
	text( 10,1.7, sprintf( '%0.2f', n ) );	
	drawnow;
end
