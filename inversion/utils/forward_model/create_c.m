function c = create_c(C)
% @brief: define c matrix for general pde
% @params: C, struct containing alpha, beta, gamma, omega
% 2returns c tensor for general pde
% c11 = [C.alpha, 0, C.omega];
% c12 = [0, C.beta; C.omega, 0];
% c22 = [C.omega, 0, C.gamma];

c11 = [C.alpha, 0, C.omega/2];
c12 = [0, C.beta; C.omega/2, 0];
c22 = [C.omega/2, 0, C.gamma];

c = [c11(:);c12(:);c22(:)];
end