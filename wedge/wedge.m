%%%
%%% Matlab routines for building even- and odd-symmetric steerable 
%%% wedge filters.
%%%
%%% NOTE: Due to the sampling of the polar-seperable functional form of the
%%%       filters onto a rectangular grid, the DC value is aliased:
%%%       the DC value should be zero at all orientations.  The simplest
%%%       solution to this problem is to create large  filters (d=127) and
%%%       repeatedly blur and subsample.
%%%
%%% BY:    Hany Farid, farid@mit.edu, www-bcs.mit.edu/~farid
%%% DATE:  2.1.96
%%% REF:   E.P. Simoncelli and H. Farid
%%%	   Steerable Wedge Filters for Local Orientation Analysis
%%%	   IEEE Transactions on Image Processing, 5(9):1377-1382, 1996
%%%

%%%% DESIGN 1D angular portion of filters 
theta     = pi * [-255:256] / 256; 
W         = diag( abs(theta) ); 
N         = 5; 					% NUMBER OF FREQUENCIES
S         = zeros(size(theta,2),N); 
C         = zeros(size(theta,2),N); 

for freq = 1:N 
        S(:,freq) = sin(freq*theta)'; 
        C(:,freq) = cos(freq*theta)'; 
end 
 
M         = (S' * W' * W * S) + (C' * W' * W * C); 
[minval, minpos] = min(eig(M)); 
[V,D]     = eig(M); 
vs        = V(:,minpos); 
solns     = S*vs; 
solnc     = C*vs; 
vc        = sign(solnc(floor(size(solnc,1)/2),1))*vs; 
solnc     = C*vc; 
 

%%%% 2D wedge filters 
numfilts  = N; 		% SHOULD BE 'N' FOR JOINT INTERPOLATION, '2N' OTHERWISE
d         = 11;         % FILTER SIZE
mid       =((d+1)/2); s=mid-2; 
evenfilts = zeros(d*d,numfilts); 
oddfilts  = zeros(d*d,numfilts); 
 
for fnum = 1:(numfilts) 
     ctrth = (2*(fnum-1)*pi)/(numfilts); 
     for X = 1:d 
          x = X-mid; 
          for Y = 1:d 
               y = Y-mid; 
               th = atan2(y,x) - ctrth - pi/2; 
               r = sqrt( x^2 + y^2 ); 
               if r >= mid 
                    rad = 0.0; 
               elseif r < 0.1 
                    rad = 0.0; 
               elseif r <= s 
                    rad = 1.0; 
               else 
                    rad = 0.5*(1+cos(pi*(r-s)/(mid-s))); 
               end 
               evenang = 0; 
               oddang  = 0; 
 
               for n = 1:(size(vc,1)) 
                    evenang = evenang + vc(n,1)*cos(n*th); 
                    oddang  = oddang + vs(n,1)*sin(n*th); 
               end 
               evenfilts((Y-1)*d+X,fnum) = evenang * rad; 
               oddfilts((Y-1)*d+X,fnum)  = oddang * rad; 
          end 
     end 
end 

 
%%%%% Interpolation Functions  
B = zeros(2*numfilts,2*N);  % interpolation matrix 
alpha = zeros(1,numfilts);  % positions of filters 
  
for a = 1:numfilts 
     alpha(a) = 2*(a-1)*pi/(numfilts);
     for freq = 1:N 
          B(2*a-1,2*freq-1) = cos(freq*alpha(a)); %odd
          B(2*a-1,2*freq)   = -sin(freq*alpha(a)); 
          B(2*a,  2*freq-1) = sin(freq*alpha(a)); %even
          B(2*a,  2*freq)   = cos(freq*alpha(a)); 
     end 
end 
invB = pinv(B); 

 
%%%%% Convolve basis filters (evenfilts, oddfilts) with image (I)
im = reshape(I,d^2,1); 
 
responses = zeros(2*numfilts,1); 
for k = 1:numfilts 
     responses(2*k-1) = oddfilts(:,k)' * im; 
     responses(2*k)   = evenfilts(:,k)' * im; 
end 

 
%%%%% Compute orientation energy response over [0,2pi], i.e. steer filters
numsamples = 360; 
E = zeros(1,numsamples); 
tmp = zeros(2,2*N); 
 
for deg = 1:numsamples 
     th = 2 * pi * (deg-1) / numsamples; 
     for freq = 1:N 
          tmp(1,2*freq-1) = cos(freq*th); %odd
          tmp(1,2*freq)   = -sin(freq*th); 
          tmp(2,2*freq-1) = sin(freq*th); %even
          tmp(2,2*freq)   = cos(freq*th); 
     end 
     E(deg) = norm(tmp*invB*responses)^2; 
end 
