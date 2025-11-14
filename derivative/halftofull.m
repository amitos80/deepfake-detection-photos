%%%
%% HALF-TO-FULL CONVERSION
%%%
function[ u_full ] = halftofull( u_half, taps, order, Mind, PRINT );
   
   u_full	= [];
   for k = 1 : order+1
      if( rem(k,2) == 1 ) % even order
	 if( rem(taps,2) == 0 ) % even filter size
	    f = [u_half(Mind(k,1):Mind(k,2)) ; ...
		 flipud(u_half(Mind(k,1):Mind(k,2)))];
	 else
	    f = [u_half(Mind(k,1):Mind(k,2)) ; ...
		 flipud(u_half(Mind(k,1):Mind(k,2)-1))];
	 end	
	 u_full = [u_full ; f];
      else % odd order
	 if( rem(taps,2) == 0 ) % even filter size		
	    f = [u_half(Mind(k,1):Mind(k,2)) ; ...
		 -flipud(u_half(Mind(k,1):Mind(k,2)))];
	 else
	    f = [u_half(Mind(k,1):Mind(k,2)) ; 0 ; ...
		 -flipud(u_half(Mind(k,1):Mind(k,2)))];
	 end
	 u_full = [u_full ; f];
      end
      if( PRINT )
	 fprintf( '%10.6f ', f );
	 fprintf( ' -- %10.6f\n', sum(f) );
      end
   end
   
   

