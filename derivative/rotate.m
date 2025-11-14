function[im_rot] = rotate( im, theta, method )

	[ydim,xdim] = size( im );
	midx	= xdim/2 + 1;
	midy		= ydim/2 + 1;
	theta	= -theta;
	
	if( theta == 0 )
		im_rot = im;
		return;
	end

	%%% ROTATE
	xramp	= ones( ydim, 1 ) * [1 : xdim];
	yramp	= [1 : ydim]' * ones( 1, xdim );
	warpx	= midx + (cos(theta) * (xramp-midx) - sin(theta)*(yramp-midy));
	warpy	= midy + (sin(theta) * (xramp-midx) + cos(theta)*(yramp-midy));

	im2     = interp2( xramp, yramp, im, warpx, warpy, method );

	%%% REMOVE NANS DUE TO INTERP2
	im2      	= im2(:);
	index    	= find( isnan( im2 ));
	im2(index) = zeros( 1, size(index,1) );
	im_rot = reshape( im2, ydim, xdim );
 

