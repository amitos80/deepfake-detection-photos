%%% DERIVATIVE FILTER DESIGN
%%%
%%% SPECIFY TAP SIZE AND DERIVATIVE ORDER IN 'taps' and 'order'.
%%% ONLY UP TO 3rd-ORDER SUPPORTED.
%%%
%%% BY:    Hany Farid, farid@cs.dartmouth.edu  (www.cs.dartmouth.edu/farid)
%%%        and
%%%        Eero P. Simoncelli, eero.simoncelli@nyu.edu
%%%
%%% DATE:  10.22.03
%%%
%%% REFS:  
%%%        E.P. Simoncelli 
%%%        Design of Multi-Dimensional Derivative Filters
%%%        First International Conference on Image Processing
%%%        Austin, Texas, 1994
%%%
%%%        H. Farid and E.P. Simoncelli 
%%%        Optimally Rotation-Equivariant Directional Derivative Kernels  
%%%        Computer Analysis of Images and Patterns (CAIP) 
%%%        Kiel, Germany,  1997 
%%%
%%%        H. Farid and E.P. Simoncelli 
%%%        Differentiation of Discrete Multi-Dimensional Signals
%%%        IEEE Transactions on Image Processing
%%%        (to appear) 2004
%%%

clear all;
close all;
global order omega F_basis W2 facttbl Mind;


taps	  = 5;		% filter size
order	  = 1;		% derivative order
SHOWFREQ  = 1;
SHOWFILT  = 1;
PRINTFILT = 1;

order1	= 1;		% don't change - setup matrices to  design of P,D1
fdim	= 128;		% size of Fourier basis (even)
fig	= 1;
EPS	= 1e+12;


%%% FOURIER BASIS (FULL)
omega	    = -sqrt(-1) * 2*pi * [-(fdim/2):(fdim/2)-1]' / fdim;  % ramp
phaseshift = exp(-omega*(taps-1)/2);
F_basis	   = diag(phaseshift) * exp(omega * [ 0:taps-1 ]);
F_basis	   = F_basis ./ repmat( sqrt(diag(F_basis' * F_basis))', [fdim,1]);
F_basis	   = sqrt(fdim)*F_basis;

%%% FOURIER BASIS (EVEN)
F_sym	   = real( F_basis );
[I,J]	   = find( abs(F_sym' * F_sym) > 0.25);
meta_i	   = find(I > J);
F_sym	   = F_sym( :, setdiff( [1:taps], I(meta_i)) );
taps_sym   = size(F_sym,2);
scale	   = 2*eye( taps_sym );
if( rem(taps,2) == 1 ) % odd filter size
	scale(taps_sym,taps_sym) = 1;
end
F_sym	   = -F_sym * scale;

%%% FOURIER BASIS (ODD)
F_asym	   = imag( F_basis );
[I,J]	   = find( abs(F_asym' * F_asym) > 0.25 );
meta_i	   = find(I > J);
F_asym	   = F_asym( :, setdiff( [1:taps], I(meta_i)) );
F_asym	   = F_asym( :, find( diag(F_asym'*F_asym)>0.25 ) );
taps_asym  = size(F_asym,2);
scale	   = 2*eye( taps_asym );
F_asym	   = F_asym * scale;
F_asym	   = sqrt(-1)*F_asym;


%%% FREQUENCY WEIGHTING (deriv_design)
W	   = diag( ones(fdim,1) );			% none

%%% MISC.
facttbl	   = gamma(1:order+1); % factorial lookup table


%%% BUILD MATRIX M [E(u)=(Mu)^2]: make pairwise comparisons of filters of different orders
Mind(1,1) = 1;
Mind(1,2) = taps_sym;
for c = 2 : order+1 % index into matrix M
   Mind(c,1) = Mind(c-1,2)+1;
   if( rem(c,2) == 0 )
      Mind(c,2) = Mind(c,1) + taps_asym - 1;
   else
      Mind(c,2) = Mind(c,1) + taps_sym - 1;
   end
end

M1 = [];
M2 = [];
c = 1;
for I = 1 : order1 % build matrix M
   for J = I+1 : order1+1
      if( rem(I,2) == 1 )
	 M1((c-1)*fdim+1:c*fdim, Mind(I,1):Mind(I,2)) = W*(diag(omega.^(J-I))*F_sym);
	 M2((c-1)*fdim+1:c*fdim, Mind(I,1):Mind(I,2)) = W*(F_sym);
      else
	 M1((c-1)*fdim+1:c*fdim, Mind(I,1):Mind(I,2)) = W*(diag(omega.^(J-I))*F_asym);
	 M2((c-1)*fdim+1:c*fdim, Mind(I,1):Mind(I,2)) = W*(F_asym);
      end	
      if( rem(J,2) == 1 )		
	 M1((c-1)*fdim+1:c*fdim, Mind(J,1):Mind(J,2)) = -W*F_sym;
	 M2((c-1)*fdim+1:c*fdim, Mind(J,1):Mind(J,2)) = zeros(size(F_sym));
      else
	 M1((c-1)*fdim+1:c*fdim, Mind(J,1):Mind(J,2)) = -W*F_asym;		
	 M2((c-1)*fdim+1:c*fdim, Mind(J,1):Mind(J,2)) = zeros(size(F_asym));			
      end
      c = c + 1;
   end
end


%%% LINEAR CONSTRAINTS (e.g., prefilter is unit-sum)
if( rem(taps,2) == 0 )
   C(1).c = [ 2*ones(1,taps_sym) zeros(1,size(M1,2)-taps_sym) ]'; % even filter size
   cnt = 2;
   for k = 3 : 2 : order+1
      C(cnt).c = zeros( size(M1,2), 1 );
      C(cnt).c(Mind(k,1):Mind(k,2)) = 2;
      cnt = cnt + 1;
   end		
else
   C(1).c = [ 2*ones(1,taps_sym-1) 1 zeros(1,size(M1,2)-taps_sym) ]'; % odd filter 
   cnt = 2;
   for k = 3 : 2 : order+1
      C(cnt).c = zeros( size(M1,2), 1 );
      C(cnt).c(Mind(k,1):Mind(k,2)) = 2;
      C(cnt).c(Mind(k,2)) = 1;
      cnt = cnt + 1;
   end		
end


%%% SOLVE: GENERALIZED EIGENVECTOR SOLUTION
[U,D,V] = svd( M1'*M1 ); % assumes eigenvalues in sorted order
N = size(D,1);
if( D(1,1)/D(N,N) < EPS )
   fprintf( 'no zeros\n' );
   [v,d] = eig(M2'*M2,M1'*M1);
   [val,ind] = max( diag(d) );
   u_half = v(:,ind);
   u_half = u_half / (u_half'*C(1).c); % make prefilter unit-length
else
   ind = find( D(1,1)./diag(D) > EPS );
   fprintf( 'multiple zeros (%d)\n', length(ind) );
   U0 = U(:,ind);
   Proj = (C(1).c*C(1).c') / (C(1).c'*C(1).c);
   U1 = intersect( U0, (eye(size(Proj))-Proj) ); 
   if( rank(U0) ~= rank(U1)+1 )
      fprintf( '*** WARNING: U1 is not rank deficient\n' );
   end
   [v,d] = eig(M2'*M2,M1'*M1);
   [val,ind] = max( diag(d) );
   v0 = v(:,ind);
   v0 = v0 / (v0'*C(1).c); % make prefilter unit-length
   
   if(1) % NON-LINEAR OPTIMIZATION ON ROTATION INVARIANCE
      options = optimset;
      if( rem(taps,2) == 1 ) % even filter size
	 load solution11;
	 Mind2 = Mind11;
	 u_half2 = u11_half;
      else % odd filter size
	 load solution10;
	 Mind2 = Mind10;
	 u_half2 = u10_half;
      end			
      for k = 1 : order1 + 1
	 g(Mind(k,1):Mind(k,2)) = 0; 
	 len = Mind2(k,2)-Mind2(k,1);
	 g(Mind(k,2)-len:Mind(k,2)) = u_half2(Mind2(k,1):Mind2(k,2));
      end
      g = g';
      v1 = inv(U1'*U1)*U1'*(g-v0); % don't use it
      v1 = zeros(size(v1));
      v1 = fminsearch( 'rot_invariance_err', v1, options, order1, facttbl, fdim, taps, Mind, v0, U1 );
      u_half = v0 + U1*v1;
   end	
end


%%% HIGHER-ORDER DERIVATIVES - FIRST-ORDER APPROXIMATION
cnt = 2;
for k = 2 : order
   if( rem(k,2) == 0 ) % even-order
      dk = pinv(F_sym)*W*(diag(omega.^k))*F_sym*u_half(Mind(1,1):Mind(1,2));
      dk = dk - dk'*C(cnt).c(Mind(k+1,1):Mind(k+1,2))/taps; % make  zero-sum
      cnt = cnt + 1;
   else % odd-order
      dk = pinv(F_asym)*W*(diag(omega.^k))*F_sym*u_half(Mind(1,1):Mind(1,2));
   end
   u_half = [u_half ; dk];
end
u_full = halftofull( u_half, taps, order, Mind, PRINTFILT );
if( SHOWFILT ) showfilt( u_full, fig ); fig = fig + 1; end;
if( SHOWFREQ ) showfreq( u_full, fig ); fig = fig + 1; end;


%%% HIGHER-ORDER DERIVATIVES - NON-LINEAR MINIMIZATION
if( order >= 2 )
   options = optimset;
   u_half = fminsearch( 'deriv2_err', u_half, options,  F_sym, F_asym, omega, Mind );
   
   p = u_half( Mind(1,1):Mind(1,2) );
   c = C(1).c( Mind(1,1):Mind(1,2) );
   p = p / (p'*c); % make prefilter unit-sum
   u_half( Mind(1,1):Mind(1,2) ) = p; 
   
   d2 = u_half( Mind(3,1):Mind(3,2) );
   c = C(2).c(Mind(3,1):Mind(3,2))/taps;
   d2 = d2 - d2'*c; % make derivative filter zero-sum
   u_half( Mind(3,1):Mind(3,2) ) = d2;	
end
if( order >= 3 )
   options = optimset;
   u_half = fminsearch( 'deriv3_err', u_half, options, F_sym, F_asym, omega, Mind );
   
   p = u_half( Mind(1,1):Mind(1,2) );
   c = C(1).c( Mind(1,1):Mind(1,2) );
   p = p / (p'*c); % make prefilter unit-sum
   u_half( Mind(1,1):Mind(1,2) ) = p; 
   
   d2 = u_half( Mind(3,1):Mind(3,2) );
   c = C(2).c(Mind(3,1):Mind(3,2))/taps;
   d2 = d2 - d2'*c; % make derivative filter zero-sum
   u_half( Mind(3,1):Mind(3,2) ) = d2;	
end
if( order > 3 )
   fprintf( 'WARNING: non-linear optimization not implemented\n' );
end


%%% DONE - SHOW RESULTS
if( order >= 2 )
   u_full = halftofull( u_half, taps, order, Mind, PRINTFILT );
   if( SHOWFILT ) showfilt( u_full, fig ); fig = fig + 1; end;
   if( SHOWFREQ ) showfreq( u_full, fig ); fig = fig + 1; end;
end
