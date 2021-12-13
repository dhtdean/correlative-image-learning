function dPndx = dlegendre(n,x)
% @brief: calculates first derivative of legendre polynomial
% params: (n,x), Pn(x)
% returns: dPndx

   if n == 0
       dPndx = zeros(size(x));
   else
       dpndx = legendre_derivative(n,x);
       dPndx = dpndx(1,:,:);
       dPndx = reshape(dPndx, size(x));
   end
%     dPndx = legendre0(n,x);
end
