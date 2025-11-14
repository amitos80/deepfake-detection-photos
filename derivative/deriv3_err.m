function[ err ] = deriv3_err( u, F_sym, F_asym, omega, Mind )

     p  = u( Mind(1,1):Mind(1,2) );
     d1 = u( Mind(2,1):Mind(2,2) );
     d2 = u( Mind(3,1):Mind(3,2) );
     d3 = u( Mind(4,1):Mind(4,2) );
     
     P  = F_sym*p;
     D1 = F_asym*d1;
     D2 = F_sym*d2;
     D3 = F_asym*d3;
     
     err1 = diag(omega.^3)*P*P' - D3*P';
     err2 = P*(diag(omega.^3)*P)' - P*D3';
     err3 = 3*((diag(omega.^2)*P)*(diag(omega)*P)' - D2*D1');
     err4 = 3*((diag(omega)*P)*(diag(omega.^2)*P)' - D1*D2');
     
     err1a = 3*err1 + err4;
     err2a = 3*err2 + err3;
     err3a = err1 - err4;
     err4a = err3 - err2;	
     
     errN = sum(sum( abs(err1a).^2 )) + sum(sum( abs(err2a).^2 )) + ...
	    sum(sum( abs(err3a).^2 )) + sum(sum( abs(err4a).^2 ));	
     errD = sum( P.^2 )^2;
     err = errN / errD;
     
     fprintf( '%f\n', err );
     
