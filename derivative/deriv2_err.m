function[ err ] = deriv2_err( u, F_sym, F_asym, omega, Mind )

     p  = u( Mind(1,1):Mind(1,2) );
     d1 = u( Mind(2,1):Mind(2,2) );
     d2 = u( Mind(3,1):Mind(3,2) );
     
     P  = F_sym*p;
     D1 = F_asym*d1;
     D2 = F_sym*d2;
     
     err1 = diag(omega.^2)*P*P' - D2*P';
     err2 = (diag(omega)*P)*(diag(omega)*P)' - D1*D1';
     errN = sum(sum( err1.^2 )) + sum(sum( err2.^2 ));
     errD = sum( P.^2 )^2;
     err = errN / errD;
     
     fprintf( '%f\n', err );
     
