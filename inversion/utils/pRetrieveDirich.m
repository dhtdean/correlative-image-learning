function [pinv,K,err,Dm, err_lst, D0, err_all, B, ud] = pRetrieveDirich(order, hmax, filename, C, d, p)
% @brief: retrieve experiment
% @param: order
% @param: hmax, grid intervals
% @param: d, displacement
% @returns: pinv, K, err
    
    % define boundary of particle
    ushape = scatteredInterpolant(p(1,:)',p(2,:)',d(1:end/2));
    vshape = scatteredInterpolant(p(1,:)',p(2,:)',d(end/2+1:end));
    
    % get D
    [Dm, D0, K, B, ud] = retrieveDDirich(order, hmax, filename, C, ushape, vshape);
    
    dt = B\(d-ud);
    pinv = Dm\((K*dt)-D0);
    err_lst = K*dt - Dm*pinv - D0;
    err = norm(err_lst);
    err_all = B * err_lst(:);
end
