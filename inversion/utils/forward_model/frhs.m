function G = brhs(location, state, params)
% @brief: set up the rhs of the poisson equation at the boundary, represent loading
% @params, location, struct(x,y) position
% @params, state, struct
% @params, params, struct with epsion, filename, stepsize and C
    
    
    % get constants
    epsilon = params.epsilon;
    filename = params.filename;
    stepsize = params.stepsize;
    C = params.C;
    paramx = params.paramx;
    paramy = params.paramy;
    N = 2;
    nr = length(location.x);
    G = zeros(N,nr);
    
    % gradient
    [gradc_x, gradc_y] = grad_c(location.x,location.y,filename, epsilon, stepsize); 
    c_interp = concentration(filename, epsilon);
    
    % allocate G
    c11 = C.alpha.*dfchemdc(c_interp(location.x, location.y), paramx);
    c12 = C.beta.*dfchemdc(c_interp(location.x, location.y), paramy);
    c21 = C.beta.*dfchemdc(c_interp(location.x, location.y), paramx);
    c22 = C.gamma.*dfchemdc(c_interp(location.x, location.y), paramy);
    G(1,:) = gradc_x.*(c11 + c12);
    G(2,:) = gradc_y.*(c21 + c22);
end

