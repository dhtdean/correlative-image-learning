function [d, anchor] = DFromExperiment(filename, p)
% @brief: retrieve d from experimental data, d should be: d(1) = d(2) =
% d(end/2+1) = 0.
% @param: filename, filename of data
% @param: p, [2,Np] array, made of nodal coordinates
% @return: d, displacement, evaluated at points p.
% @return: anchor, anchor value that fixs the orientation of axis

    load(filename);
    % clean data
    theta(theta == 1) = 0;
    exx(theta == 0) = 0;
    eyy(theta == 0) = 0;
    exy(theta == 0) = 0;
    theta(theta == 0) = 0;
    
    cth = cos(rot);
    sth = sin(rot);
    
    % 4dstem, note that the definition of strain from data is different than normal definition
    duda = exx;
    dvdc = eyy;
    dudc = exy + theta;
    dvda = exy - theta;     
    dudx = sth .* duda + cth .* dudc;
    dudy = cth .* duda - sth .* dudc;
    dvdx = -(sth .* dvda + cth .* dvdc);
    dvdy = -(cth .* dvda - sth .* dvdc);


    %% integrate to get d = (u,v)
    [H,W] = size(exx);
    yp = 1:1:H;
    xp = 1:1:W;
    [X,Y]=meshgrid(xp,yp);

    tic,ur = intgrad2(dudx,dudy,1,1,0);toc
    tic,vr = intgrad2(dvdx,dvdy,1,1,0);toc
    
    % interpolate observation to simulation nodes to match d = (u,v)
    Xq = p(1,:);
    Yq = p(2,:);

    u = interp2(X,Y, ur, Xq, Yq, 'cubic');
    v = interp2(X,Y, vr, Xq, Yq, 'cubic');
    
    % translate and rotate, provide pts in u&v
    N = length(p');
    u = u - u(1);
    v = v - v(1);
    un = u(N);
    vn = v(N);
    
    % plot
    ur(theta == 0) = nan;
    vr(theta == 0) = nan;
    figure(1);
    subplot(2,1,1);surf(ur);colorbar();view([0,0,1]);shading flat;axis tight;
    subplot(2,1,2);surf(vr);colorbar();view([0,0,1]);shading flat;axis tight;
    plot_beautify;


    % add colors to nans
    u(isnan(u)) = 1000.*(1:sum(isnan(u)));
    v(isnan(v)) = 1000.*(1:sum(isnan(v)));
    d = [u;v];
    anchor = u(2);
end