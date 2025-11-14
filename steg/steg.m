%%% Detecting Steganographic Messages in Digital Images 
%%% H. Farid 
%%%
%%% Technical Report, TR2001-412, Dartmouth College, Computer Science 
%%% (www.cs.dartmouth.edu/farid/publications/tr01.html)
%%%
%%% Copyright (c), 2000, Trustees of Dartmouth College (Institute for 
%%% Security Technology Studies). All rights reserved.

%%% ----------------------------------------------------------------------

%%% PART I: COLLECT WAVELET STATISTICS 
%%% PART II: CLASSIFIER - TRAINING
%%% PART III: CLASSIFIER - TESTING

%%% ----------------------------------------------------------------------
%%% 
%%% PART I: COLLECT WAVELET STATISTICS 
%%%         You will need the matlabPyrTools by E.P. Simoncelli
%%%            ftp://ftp.cis.upenn.edu/pub/eero/matlabPyrTools.tar.gz
%%%
%%%         Given an image (im) the code below will construct the wavelet
%%%         coefficient feature vector.
%%%

path( path, './matlabPyrTools' );

%%% BUILD WAVELET PYRAMID
[pyr,ind] = buildWpyr(im,4);

%%% COLLECT STATISTICS FROM SUB-BANDS
for k = 1 : 3
   
   [lev,sz] = wpyrLev(pyr,ind,k);		% LEVEL K
   dim1v = sz(1,1)*sz(1,2);
   dim1h = sz(2,1)*sz(2,2);
   dim1d = sz(3,1)*sz(3,2);
   sb1v = reshape( lev(1:dim1v), sz(1,1), sz(1,2) );
   sb1h = reshape( lev(dim1v+1:dim1v+dim1h), sz(2,1), sz(2,2) );
   sb1d = reshape( lev(dim1v+dim1h+1:dim1v+dim1h+dim1d), sz(3,1), sz(3,2) );
   
   [lev,sz] = wpyrLev(pyr,ind,k+1);		% LEVEL K+1
   dim2v = sz(1,1)*sz(1,2);
   dim2h = sz(2,1)*sz(2,2);
   dim2d = sz(3,1)*sz(3,2);
   sb2v = reshape( lev(1:dim2v), sz(1,1), sz(1,2) );	
   sb2h = reshape( lev(dim2v+1:dim2v+dim2h), sz(2,1), sz(2,2) );
   sb2d = reshape( lev(dim2v+dim2h+1:dim2v+dim2h+dim2d), sz(3,1), sz(3,2) );
   
   c	= 1;
   [ydim,xdim] = size(sb1v);
   vert = zeros( (xdim-2)*(ydim-2), 8 );
   horiz = zeros( (xdim-2)*(ydim-2), 8 );
   diag = zeros( (xdim-2)*(ydim-2), 8 );
   xlim = [2:xdim-1];
   ylim = [2:ydim-1];
   dim = length(vert);
   
   vert(:,1) = reshape( sb1v(ylim,xlim), dim, 1 );
   vert(:,2) = reshape( sb1v(ylim-1,xlim), dim, 1 );
   vert(:,3) = reshape( sb1v(ylim,xlim-1), dim, 1 );
   vert(:,4) = reshape( sb2v(round(ylim/2), round(xlim/2)), dim, 1 );
   vert(:,5) = reshape( sb1d(ylim,xlim), dim, 1 );
   vert(:,6) = reshape( sb2d(round(ylim/2), round(xlim/2)), dim, 1 );
   vert(:,7) = reshape( sb1v(ylim+1,xlim), dim, 1 );
   vert(:,8) = reshape( sb1v(ylim,xlim+1), dim, 1 );
   
   horiz(:,1) = reshape( sb1h(ylim,xlim), dim, 1 );
   horiz(:,2) = reshape( sb1h(ylim-1,xlim), dim, 1 );
   horiz(:,3) = reshape( sb1h(ylim,xlim-1), dim, 1 );
   horiz(:,4) = reshape( sb2h(round(ylim/2), round(xlim/2)), dim, 1 );
   horiz(:,5) = reshape( sb1d(ylim,xlim), dim, 1 );
   horiz(:,6) = reshape( sb2d(round(ylim/2), round(xlim/2)), dim, 1 );
   horiz(:,7) = reshape( sb1h(ylim+1,xlim), dim, 1 );
   horiz(:,8) = reshape( sb1h(ylim,xlim+1), dim, 1 );

   diag(:,1) = reshape( sb1d(ylim,xlim), dim, 1 );
   diag(:,2) = reshape( sb1d(ylim-1,xlim), dim, 1 );
   diag(:,3) = reshape( sb1d(ylim,xlim-1), dim, 1 );
   diag(:,4) = reshape( sb2d(round(ylim/2), round(xlim/2)), dim, 1 );
   diag(:,5) = reshape( sb1h(ylim,xlim), dim, 1 );
   diag(:,6) = reshape( sb1v(ylim,xlim), dim, 1 );
   diag(:,7) = reshape( sb1d(ylim+1,xlim), dim, 1 );
   diag(:,8) = reshape( sb1d(ylim,xlim+1), dim, 1 );
   
   % COEFFICENT STATISTICS
   V = vert(:,1);
   H = horiz(:,1);
   D = diag(:,1);
   M1 = [mean(V) mean(H) mean(D)];
   M2 = [var(V) var(H) var(D)];
   M3 = [kurtosis(V) kurtosis(H) kurtosis(D)];
   M4 = [skewness(V) skewness(H) skewness(D)];
   
   %%% LINEAR PREDICTOR OF COEFFICIENT MAGNITUDE
   V = abs(V);
   nzind = find( V>=1 );
   V = V(nzind);
   Qv = abs(vert(nzind,[2:8]));
   v(:,k) = inv(Qv'*Qv) * Qv' * V;
   
   H = abs(H);
   nzind = find( H>=1 );
   H = H(nzind);
   Qh = abs(horiz(nzind,[2:8]));
   h(:,k) = inv(Qh'*Qh) * Qh' * H;
   
   D = abs(D);
   nzind = find( D>=1 );
   D = D(nzind);
   Qd = abs(diag(nzind,[2:8]));
   d(:,k) = inv(Qd'*Qd) * Qd' * D;
   
   %%% DIFFERENCE BETWEEN ACTUAL AND PREDICTED COEFFICIENTS
   Vp = Qv * v(:,k);
   Hp = Qh * h(:,k);
   Dp = Qd * d(:,k);
   Ev = (log2(V) - log2(abs(Vp)));
   Eh = (log2(H) - log2(abs(Hp)));
   Ed = (log2(D) - log2(abs(Dp)));
   
   M5 = [mean(Ev) mean(Eh) mean(Ed)];
   M6 = [var(Ev) var(Eh) var(Ed)];
   M7 = [kurtosis(Ev) kurtosis(Eh) kurtosis(Ed)];
   M8 = [skewness(Ev) skewness(Eh) skewness(Ed)];

   fprintf( '%.3f ', M1, M2, M3, M4 );
   fprintf( '%.3f ', M5, M6, M7, M8 );
end
fprintf( '\n' );

%%% ----------------------------------------------------------------------
%%% 
%%% PART II: CLASSIFIER - TRAINING
%%%
%%%          Let 'a' be a matrix whose rows contain "no-steg" image
%%%          feature vectors. Let 'b' be a matrix whose rows contain
%%%          "steg" image feature vectors. Compute FLD discriminator.
%%%

%%% FISHER LINEAR DISCRIMINANT FOR TWO CLASSES 
N = size(a,2);
numImA = size(a,1);
numImB = size(b,1);

%%% ALL SAMPLE MEAN
mu = mean( [a ; b] );

%%% CLASS MEAN
mu1 = mean( a );
mu2 = mean( b );

%%% VARIANCE MATRICES
Sb = size(a,1)*((mu1-mu)'*(mu1-mu)) + size(b,1)*((mu2-mu)'*(mu2-mu));
clear M1 M2;
for k = 1 : N
   M1(k,:) = a(:,k)' - mu1(k);
   M2(k,:) = b(:,k)' - mu2(k);
end
Sw = M1 * M1' + M2 * M2';

%%% EIGEN-DECOMPOSITION
[vec,val] = eig( Sb, Sw );
[maxval,ind] = max(diag(real(val))); 
e = real( vec(:,ind) );

%%% PROJECT TRAINING ONTO MAXIMAL EIGENVALUE-EIGENVECTOR
projA = (a * e)';
muA = mean( projA ); sigA = std( projA );
projB = (b * e)';
muB = mean( projB ); sigB = std( projB );

%%% COMPUTE THRESHOLD
t0 = 1.01*min([projA projB]);
t1 = 1.01*max([projA projB]) + eps;
meanprojA = mean(projA);
meanprojB = mean(projB);
   
c = 1;
for thresh = t0 : (t1-t0)/250 : t1 %%% SEE BELOW TO MATCH SAMPLING DENSITY
   if( meanprojA < meanprojB )
      inda = find( projA<=thresh );
      indb = find( projB>thresh );
   else
      inda = find( projA>=thresh );
      indb = find( projB<thresh );
   end
   
   f(c,1) = 100 * length(inda)/length(projA);
   f(c,2) = 100 * length(indb)/length(projB);
   c = c + 1;
end

[minval,minind] = min( abs(99-f(:,1)) ); %%% 1\% FALSE-POSITIVE RATE
thresh = t0 : (t1-t0)/250 : t1; %%% SEE ABOVE TO MATCH SAMPLING DENSITY
T = thresh( minind ); %%% TRESHOLD FOR DISCRIMINATION 
                      %%% USED WITH FLD AXIS 'e'

%%% ----------------------------------------------------------------------
%%% 
%%% PART III: CLASSIFIER - TESTING
%%%
%%%          Let 'a2' be a matrix whose rows contain "no-steg" image
%%%          feature vectors. Let 'b2' be a matrix whose rows contain
%%%          "steg" image feature vectors. 
%%%

projA2 = (a2 * e)'; %%% PROJECT ONTO FLD AXIS
projB2 = (b2 * e)';
   
c = 0;
right = 0;
wrong = 0;
for k = 1 : length(projA2) %%% COMPUTE PREDICTION ACCURACY (NO STEG IMAGES)
   c = c + 1;
   if( meanprojA < meanprojB )
      if( projA2(k)<=T )
	 right = right + 1;
      else
	 wrong = wrong + 1;
      end
   else
      if( projA2(k)>T )
	 right = right + 1;
      else
	 wrong = wrong + 1;
      end
   end
end
fprintf( 'no steg: right=%.2f  wrong=%.2f\n', 100*right/c, 100*wrong/c );

c = 0;
right = 0;
wrong = 0;
for k = 1 : length(projB2) %%% COMPUTE PREDICTION ACCURACY (STEG IMAGES)
   c = c + 1;
   if( meanprojA < meanprojB )
      if( projB2(k)>=T )
	 right = right + 1;
      else
	 wrong = wrong + 1;
      end
   else
      if( projB2(k)<T )
	 right = right + 1;
      else
	 wrong = wrong + 1;
      end
   end
end
fprintf( 'steg: right=%.2f  wrong=%.2f\n', 100*right/c, 100*wrong/c );
   
