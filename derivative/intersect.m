function Q = intersect(A,B)
%INTS	  Intersection of subspaces.
%  Q = ints(A,B) is an orthonormal basis for the subspace (imA) intersection (imB) .

%  Basile and Marro 4-20-90
% http://www.deis.unibo.it/Staff/FullProf/GiovanniMarro/geometric.htm#ints

mm= ' **** WARNING: a matrix is empty in ints';
if (isempty(A))&(isempty(B)), error(' empty matrices in ints'), end
if isempty(A), A=zeros(size(B,1),1); disp(mm), end
if isempty(B), B=zeros(size(A,1),1); disp(mm), end
Q = ortco(sums(ortco(A),ortco(B)));
% --- last line of ints

function Q = sums(A,B)
%SUMS     Sum of subspaces.
%  Q = sums(A,B) is an orthonormal basis for subspace im[A B] = imA + imB .

%  Basile and Marro 4-20-90

Q = ima([A B],0);
% --- last line of sums ---

function Q = ima(A,p)
%IMA      Orthogonalization.
%  Q=ima(A) is an orthonormal basis for imA. If called as Q=ima(A,p) with
%  p=1 permutations are allowed, while with p=0 they are not.

%  Basile and Marro 4-20-90 (modified for Matlab 5: 5-22-97)

nargs=nargin;
error(nargchk(1,2,nargs));
if nargs == 1
  p = 1;
end
tol = eps*norm(A,'fro')*10^6;
[ma,na] = size(A);
if p == 1
[Q,R,E] = qr(A);
  if (na == 1)|(ma == 1)
    d = R(1,1);
  else
    d = diag(R);
  end
  d = (abs(d))';
  nul = find(d > tol);
  r=length(nul > 0);
  if r > 0
    Q = Q(:,nul);
  else
    Q = zeros(ma,1);
  end
else
  ki = 1;
  A1=A;
  while ki == 1
    [ma,na] = size(A1);
    punt = 1:na;
    [Q,R] = qr(A1);
    if (na == 1)|(ma == 1)
      d = R(1,1);
    else
      d = diag(R);
    end
    d = (abs(d))';
    nul = find(d <= tol);
    n = min(nul);
    if ~isempty(n), punt = find(punt ~= n); end
    if (isempty(nul))|(isempty(punt))
      ki = 0;
    else
      A1 = A1(:,punt);
    end
  end
  if (~isempty(n))&(isempty(punt))
    Q = zeros(ma,1);
  else
    r = length(d);
    if r > 0
      Q=Q(:,1:r);
      Q = -Q;
      Q(:,r) = -Q(:,r);
    end
  end
end
% --- last line of ima ---

function Q = ortco(A)
%ORTCO	  Complementary orthogonalization.
%  Q=ortco(A) is an orthonormal basis for the orthogonal complement of imA .

%  Basile and Marro 4-20-90

[ma,na] = size(A);
if norm(A,'fro')<10^(-10), Q = eye(ma); return, end
[ma,na] = size(ima(A,1));
RR = ima([A,eye(ma)],0);
Q = RR(:,na+1:ma);
if isempty(Q)
  Q = zeros(ma,1);
end
% --- last line of ortco ---


