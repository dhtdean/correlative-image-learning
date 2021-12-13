 function G = brhsDirich(location, state, ushape, vshape)
% @brief: set up the dirichlet boundary condition
% @params, location, struct(x,y) position
% @params, state, struct
% @params, ushape, vshape, shapeFunction for u and v
% @returns: dirichlet bc
     
    % allocate G
    G = [ushape(location.x,location.y);
        vshape(location.x,location.y)];
 end