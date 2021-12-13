function [D, D0, K, B, ud] = retrieveDDirich(order, hmax, filename, C, ushape, vshape)
% @brief: calculates discrete form of loadings from standard legendre
% function
% @param: order, highest order number
% @param: hmax, hmax of model
% @param: filename, filename that allows to load geometry
% @param: C, 2d effective stiffness tensor
% @returns: D, vectorized form of legendre at each node value
% @returns: D0, vector independent of legendre function

    %% parameters
    N = 2;
    epsilon = .5e-2;
    stepsize = 1e-3;
    
    paramx = struct('order', order, 'coefficients', ones([1,order]));
    paramy = struct('order', order, 'coefficients', ones([1,order]));
    rhs_param = struct('C',C, 'stepsize',stepsize,...
        'filename', filename, 'epsilon', epsilon, ...
        'paramx',paramx, 'paramy',paramy);   
    
    param0 = struct('order', order, 'coefficients', zeros([1,order]));
    rhs_param0 = struct('C',C, 'stepsize',stepsize,...
            'filename', filename, 'epsilon', epsilon, ...
            'paramx',param0, 'paramy',param0); 
        
    % define c matrix for general pde
    bcfun = @(location, state) brhsDirich(location, state, ushape, vshape);
    fPDE = @(location, state) -1.*frhs(location, state, rhs_param);
    %% make pde model
    model = createpde(N);
    % geometry
    tri = loadGeometry(filename);
    geometryFromMesh(model, tri.Points', tri.ConnectivityList');
    msh = generateMesh(model, 'Hmax', 250*hmax);

    % general pde
    c = create_c(C);
    specifyCoefficients(model, 'm', 0, 'd', 0, 'a',0, 'c',c, 'f',fPDE,'Face',1);

    % boundary condition
    force = applyBoundaryCondition(model, 'neumann', 'Edge',...
        1:model.Geometry.NumEdges, 'g', bcfun,'q',[0;0;0;0], 'Vectorized','on');

    % get basic parameters
    FEM0 = getFEM_helper(rhs_param0, model,C, bcfun);
    D0 = FEM0.Fc;
    B = FEM0.B;
    ud = FEM0.ud;
    K = FEM0.Kc;
    
    % get D
    nd = length(D0);
    D = zeros(nd, 2*order); 
    for i = 1:order
        coeffx = zeros([1,order]);
        coeffy = zeros([1,order]);
        coeffx(i) = 1;
        coeffy(i) = 1;
        paramx = struct('order', order, 'coefficients', coeffx);
        paramy = struct('order', order, 'coefficients', coeffy);
        param0 = struct('order', order, 'coefficients', zeros([1,order]));
        rhs_parama = struct('C',C, 'stepsize',stepsize,...
            'filename', filename, 'epsilon', epsilon, ...
            'paramx',paramx, 'paramy',param0); 
        rhs_paramb = struct('C',C, 'stepsize',stepsize,...
            'filename', filename, 'epsilon', epsilon, ...
            'paramx',param0, 'paramy',paramy); 
        FEM1 = getFEM_helper(rhs_parama, model,C, bcfun);
        D(:,i) = FEM1.Fc - D0(:);
        FEM2 = getFEM_helper(rhs_paramb, model,C, bcfun);
        D(:,order+i)= FEM2.Fc - D0(:);
    end
end

function FEM = getFEM_helper(rhs_param, model, C, bcfun)
    fPDE = @(location, state) -1.*frhs(location, state, rhs_param);
    % general pde
    c = create_c(C);
    % c = 1;
    specifyCoefficients(model, 'm', 0, 'd', 0, 'a',0, 'c',c, 'f',fPDE,'Face',1);

    % boundary condition
    force = applyBoundaryCondition(model, 'dirichlet', 'Edge',...
    1:model.Geometry.NumEdges, 'u', bcfun,'Vectorized','on');

    FEM = assembleFEMatrices(model,'Nullspace');
end