%%%
%% FULL-TO-HALF CONVERSION
%%%
function[ u_half ] = fulltohalf( u_full, taps, order );

   mid = ceil( (taps+1) /2 );
   u_half = [];
   
   for k = 0 : order
      f = u_full( k*taps+1: (k+1)*taps );
      if( rem(taps,2) == 1 ) % odd-length filter
	 if( rem(k,2) == 1 ) 
	    u_half = [u_half; f(1:mid-1)]; % even order
	 else
	    u_half = [u_half; f(1:mid)]; % odd order
	 end
      else % even-length filter
	 u_half = [u_half; f(1:mid-1)];
      end
   end	
   
