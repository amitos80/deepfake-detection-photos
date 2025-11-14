%%%
%%% LOOK AT FILTERS
%%%
function[] = showfilt( u_full, fignum )

   global order omega F_basis;
   
   [fdim, taps] = size( F_basis );
   
   for k = 0 : order
      f = real( u_full( k*taps+1 : (k+1)*taps ) );
      figure( fignum);
      subplot( 1, order+1, k+1 ); cla;
      stem( f ); 
      h = line( [0 taps], [0 0] );
      set( h, 'LineStyle', '--' );
      title( sprintf('(%d)', k) );
      axis square;
		set( gca, 'Xlim', [1 taps] );
   end
   drawnow;


