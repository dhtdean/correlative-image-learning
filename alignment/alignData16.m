

% sComp = sComp_P2;
% sComp = sComp_P3b;
% sComp = sComp_P4;
% sComp = sComp_P5;

xrayTotal = alignData14(sCompareXray,inputXrayTotal);
xrayMask = alignData14(sCompareXray,inputXrayMask);
xrayComp = alignData14(sCompareXray,inputXrayComp);

% clear sComp;