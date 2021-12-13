function fp = dfchemdc(c, params)
% @brief: return dfchem/dc, basis is on Legendre polynomial, parameterized by param
% @param: c, concentration
% @param: params, struct (order, coefficients), contains Legendre
% derivatives
    
    c = min(1.0,c);
    c = max(0,c);
    fp = zeros(size(c));
    for iter = 2:params.order
        fp = fp + 2*params.coefficients(iter) .* dlegendre(iter-1,2.*c-1);
    end
end