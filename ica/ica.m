%%% INDEPENDENT COMPONENTS ANALYSIS (ICA)
%%%     A NON-ITERATIVE SOLUTION BASED ON HIGHER-ORDER MOMENTS
%%%
%%% NOTE:
%%%     PLACE THE FUNCTION histoMatch.m (see below) INTO A SEPARATE FILE
%%%
%%% REFERENCES:
%%%     www.cs.dartmouth.edu/farid/publications/josa99.html
%%%


%%% GENERATE DATA ACCORDING TO A GENERAL GAUSSIAN DISTRIBUTION SPECIFIED BY
%%% dist AND THE EXPONENT p.
clear;
dim	= 2;
N	= 1000;

p 	= 0.5; 
range	= 25 * [ -1 : 0.01 : 1 ]; % plot( range, dist );
dist 	= exp( -abs(range).^p );
x	= randn( dim, N );
x	= histoMatch( x, dist, range );


%%% APPLY AN ARIBTRAY LINEAR TRANSFORM TO THE DATA.  LOOK AT THE COVARIANCE
%%% MATRIX - NOTE THAT IT IS NOT DIAGONAL.
M	= rand( dim ) - 0.5;
x_M	= M * x;
x_M * x_M';


%%% CONVERT DATA TO POLAR COORDINATES FIRST
rad	= x_M(1,:).^2 + x_M(2,:).^2;
ang	= atan2( x_M(2,:), x_M(1,:) );
cos2	= sum( rad .* cos(2*ang) );
sin2	= sum( rad .* sin(2*ang) );


%%% SOLVE FOR ROTATION AND APPLY ROTATION MATRIX TO DATA - REMOVE SECOND
%%% HARMONIC .  NOTE THAT THE COVARIANCE MATRIX IS DIAGONAL.
th2	= 1/2 * atan2( sin2, cos2  );
R2	=  [ cos(th2) sin(th2) ; -sin(th2) cos(th2) ];
x_R2	= R2 * x_M;
x_R2 * x_R2';


%%% SCALE THE AXIS TO MAKE THE COVARIANCE MATRIX HAVE UNIT VARIANCE ALONG
%%% THE DIAGONAL 
S	= diag( 1 ./ ( sqrt(N) * std(x_R2')' ) );
x_S	= S * x_R2;
x_S * x_S';


%%% NOW, APPLY THE SECOND ROTATION MATRIX - REMOVE FOURTH HARMONIC
%%% NOTE: THIS FINAL ROTATION MAY BE OFF BY 45 DEG -- See:
%%%    Separating Reflections from Images by use of ICA
%%%    H. Farid and E.H. Adelson 
%%%    Journal of the Optical Society of America, 16(9):2136-2145, 1999 
%%%
rad	= x_S(1,:).^2 + x_S(2,:).^2;
ang	= atan2( x_S(2,:), x_S(1,:) );
cos4	= sum( rad .* cos(4*ang) );
sin4	= sum( rad .* sin(4*ang) );
th4	= 1/4 * atan2( sin4, cos4  );
R4	= [ cos(th4) sin(th4) ; -sin(th4) cos(th4) ];
x_R4	= R4 * x_S;


%%% THE CONCATENATION OF THE TWO ROTATION MATRICES AND SCALING MATRICES
%%% SHOULD BE THE INVERSE OF THE MATRIX 'M' - THIS SHOULD BE THE IDENTITY
I	= R4 * S * R2 * M;
I	= I ./ max(abs(I(:)));

subplot(2,2,1); plot( x(1,:), x(2,:), '.' ); axis equal; title( 'original' );
subplot(2,2,2); plot( x_M(1,:), x_M(2,:), '.' ); axis equal; title( 'mixed' );
subplot(2,2,3); plot( x_S(1,:), x_S(2,:), '.' ); axis equal; title( 'pca+whitened' );
subplot(2,2,4); plot( x_R4(1,:), x_R4(2,:), '.' ); axis equal; title( 'separate' );




% ----------------------- place in histoMatch.m --------------------------
% RES = histoMatch(MTX, N, X)
%
% Modify elements of MTX so that normalized histogram matches that
% specified by vectors X and N, where N contains the histogram counts
% and X the histogram bin positions (see histo).

% Eero Simoncelli, 7/96.

function res = histoMatch(mtx, N, X)

if ( exist('histo') == 3 )
  [oN, oX] = histo(mtx(:), size(X(:),1));
else
  [oN, oX] = hist(mtx(:), size(X(:),1));
end

oStep = oX(2) - oX(1);
oC = [0, cumsum(oN)]/sum(oN);
oX = [oX(1)-oStep/2, oX+oStep/2];

N = N(:)';
X = X(:)';
N = N + 1e-10;   %% HACK: no empty bins ensures nC strictly monotonic

nStep = X(2) - X(1);
nC = [0, cumsum(N)]/sum(N);
nX = [X(1)-nStep/2, X+nStep/2];

nnX = interp1(nC, nX, oC, 'linear');

if ( exist('pointOp') == 3 )
  res = pointOp(mtx, nnX, oX(1), oStep);
else
  res = reshape(interp1(oX, nnX, mtx(:)),size(mtx,1),size(mtx,2));
end
