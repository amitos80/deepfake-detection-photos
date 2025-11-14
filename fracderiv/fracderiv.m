%%%
%%% FRACTIONAL DERIVATIVES (12.14.00)
%%% Hany Farid (farid@cs.dartmouth.edu | www.cs.dartmouth.edu/~farid)
%%%

clear;
set( gcf, 'Renderer', 'zbuffer' );

dim	= 256;
ramp	= [-dim:dim-1];
ramp	= pi * ramp/dim;
f	= exp( -(ramp.^2)/(0.5) );		% GAUSSIAN
f	= f - mean(f);				% ZERO-MEAN: AVOID DISCONTINUITY
F	= fftshift( fft( f ) ); 		% FOURIER TRANSFORM


%%% CYCLE THROUGH FRACTIONAL DERIVATIVES
for n = 0 : 0.1 : 4
	Fn	= (j * ramp).^n .* F;		% MULIPLY BY RAMP^n
	fn	= ifft( fftshift(Fn) );		% INVERSE FOURIER TRANSFORM
	if( mean( abs(imag(fn)) ) > 1e-5 )	% FOR REAL SIGNALS
	   fprintf( 1, 'Non-zero imaginary component (%f)\n', mean(abs(imag(fn))) );
	   return;
	end
	fn 	= fn / max(abs(fn));		% NORMALIZE

	t = sprintf( '%0.2f', n );		% PLOT...
	plot( real(fn) ); 
	text( 20,1.0, sprintf( '%0.2f', n ) );	
	axis( [0 2*dim -1.2 1.2] ); axis square;
	h = line( [dim dim], [-1.2 1.2] );
	set( h, 'LineStyle', ':' );
	drawnow;
end
