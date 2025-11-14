function[ err ] = rot_invariance_err( v1, order, facttbl, fdim, taps, Mind, v0, U1 )

   u_half = v0 + U1*v1;
   u_full = halftofull( u_half, taps, order, Mind, 0 );
   
   %%% EXTRACT FILTERS
   for k = 0 : order
      filt(k+1).f = u_full( k*taps+1 : (k+1)*taps );
   end
   
   %%% COMPUTE ERROR 
   err = 0;
   for theta = [0 : 10 : 170] * pi/180	
      
      %%% 2-D FOURIER TRANSFORM
      f = filt(1).f * filt(order+1).f';
      Forig = abs (fftshift( fft2(f, fdim, fdim) ) );
      
      %%% 2-D ROTATED FOURIER TRANSFORM
      Frotate = rotate( Forig, theta, 'linear' );

      %%% 2-D STEERED FOURIER TRANSFORM
      f = zeros( taps );
      for k = 0 : order
	 c = facttbl(order+1) / (facttbl(k+1)*facttbl(order-k+1));
	 c = c * sin(theta)^k * cos(theta)^(order-k);
	 f = f + c * filt(k+1).f * filt(order-k+1).f';
      end
      Fsteer = abs (fftshift( fft2(f, fdim, fdim) ) );
      
      %%% DIFFERENCE, | STEER - ROTATE |
      err = err + mean(abs(Fsteer(:) - Frotate(:)));
   end
   fprintf( '%f\n', err );
   