function msh = generate_msh(hmax, filename)
% @brief: generate a mesh
% @param: hmax represents a 
    N = 2;

    %% make pde model
    model = createpde(N);
    % geometry
    tri = loadGeometry(filename);
    geometryFromMesh(model, tri.Points', tri.ConnectivityList');
    msh = generateMesh(model, 'Hmax', 250*hmax);
end