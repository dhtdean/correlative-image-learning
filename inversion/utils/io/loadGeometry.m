function tr = loadGeometry(filename)
% @brief: find geometry of the particle
% params: filename, ".mat" file of the image
% returns: tr, shape function of the particle boundary

% specifies individual particle optical density threshold (epsilon)
    switch filename
        case 'LFP_P3.mat'
            epsilon = 30e-2;
        case 'LFP_P1.mat'
            epsilon = 25e-2;
        case 'LFP_P2.mat'
            epsilon = 10e-2;
        case 'LFP50_P1.mat'
            epsilon = 12e-2;  
        case 'LFP50_P5.mat'
            epsilon = 24e-2;  
        case 'LFP50_P4.mat'
            epsilon = 15e-2;
        case 'FP_P3.mat'
            epsilon = 20e-2;
        case 'LFP50_P2s.mat'
            epsilon = 20e-2;
        otherwise 
            epsilon = 10e-2;
    end
    data = load(filename);
    [row,col] = find( (data.FP + data.LFP) > epsilon);
    boundaries = boundary(row, col);
    X = col(boundaries);
    Y = row(boundaries);
    pgon = polyshape(X,Y);
    tr = triangulation(pgon);
end