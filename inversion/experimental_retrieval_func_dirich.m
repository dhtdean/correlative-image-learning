function experimental_retrieval_func_dirich(filename)
% @brief: perform image inversion from experimental data using Dirichlet
% boundary conditions, stores output in output folder
% params: filename, ".mat" file to be analyzed

    warning('off','all');
    if nargin == 0
        filename = 'LFP50_P2.mat';
    end
    fprintf('Begin processing %s \n',filename);
    switch filename
        case 'LFP50_P1.mat'
            hmax = 0.9e-2;
        case 'LFP50_P2.mat'
            hmax = .75e-2;
        otherwise
            hmax = 1e-2;
    end

    msh = generate_msh(hmax, filename);
    [p, e, t] = meshToPet(msh);

    %Step1. Import Experimental Data 
    [d,anchor] = DFromExperiment(filename,p);
    [~,Np] = size(d);
    d = reshape(d', [2*Np,1]);
    fprintf('Step 1 finished, displacement fetched\n');

    % Step2. Recovery
    order = [1:7];
    pinv = cell(length(order),1);
    K = cell(length(order),1);
    err = cell(length(order),1);
    err_sh = cell(length(order),1);
    err_lst = cell(length(order),1);
    D = cell(length(order),1);
    D0 = cell(length(order),1);
    B = cell(length(order),1);
    ud = cell(length(order),1);
    fprintf('Step 2 Find params \n');
    C = struct('alpha',2.4947e3, 'beta', 765, 'gamma', 2.5897e3, 'omega',858);

    tic
    for i = 1:length(order)
        warning('off','all');
        [pinv{i}, K{i}, err{i}, D{i}, err_sh{i}, D0{i}, err_lst{i}, B{i}, ud{i}]= pRetrieveDirich(order(i), hmax, filename, C, d, p);
        fprintf('Degree: %d \n',i);
    end
    toc
    fprintf('Step 2 Finished \n');

    % Step 3. Save
    output_file = extractBefore(filename,'.mat');
    fn = [output_file,'_inv.mat'];
    save(fullfile(pwd,'output',fn));
end
