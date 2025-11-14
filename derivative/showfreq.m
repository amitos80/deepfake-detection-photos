%%%
%%% LOOK AT FILTERS IN FREQUENCY DOMAIN
%%%
function[] = showfreq( u_full, fignum )

   global order omega F_basis;
   
   [fdim, taps] = size( F_basis );
	
   p = real( u_full(1 : taps) );
   P = (F_basis * p);
   for k = 0 : order
      d = real( u_full( k*taps+1 : (k+1)*taps ) );
      Pd = (F_basis * p) .* (omega .^ k);
      D = (F_basis * d);
      
      figure( fignum);
      if( k==0 )
	 subplot( 1, order+1, k+1 ); cla;
	 plot( abs(P), 'r--' );
      else
	 subplot( 1, order+1, k+1 ); cla;
	 hold on;
	 plot( abs(Pd), 'r--' ); 
	 plot( abs(D), 'b-.' ); 
	 hold off;
      end
      maxval = max( max(max(abs(P)), max(abs(Pd))), max(abs(D)) );
      axis( [0 fdim 0 maxval+0.1*maxval] ); 
      axis square;
      box on;
      hold off;
      if( maxval<=1 )
	 set( gca, 'XTick', [] ); set(gca, 'YTick', [0 maxval] );
      else
	 set( gca, 'XTick', [] ); set(gca, 'YTick', [0 1 maxval] );
      end		
      if( k > 0 )
	 title( sprintf( '(%d) err=%f \n', k, mean( (abs(Pd)-abs(D)).^2 ) ) );
	 fprintf( '(%d) err=%f \n', k, mean( (abs(Pd)-abs(D)).^2 ) );
      end
   end
   drawnow;
   

