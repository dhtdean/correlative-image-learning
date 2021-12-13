function c_interp = concentration(filename, epsilon)
% @brief: return a interpolant for concentration, read data from filename
% @param: filename, cmap to load
% @param: epsilon, threshold for finding boundaries
% @return: c_interp, interpolant function handle
    data = load(filename);
    th = data.FP + data.LFP+1e-6;
    [row,col] = find(th > epsilon);
    conc= data.LFP./th;
    conc = conc(find(th > epsilon));
    c_interp = scatteredInterpolant(col,row,conc);
    c_interp.Method = 'natural';
end