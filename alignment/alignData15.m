

sComp = sComp_P2;
% sComp = sComp_P3b;
% sComp = sComp_P4;
% sComp = sComp_P5;

xrayComp = alignData14(sCompareXray,sComp.sigComp);
xrayExitWaves = alignData14(sCompareXray,sComp.stackCrop);
xrayMask = alignData14(sCompareXray,sComp.sigMask);
xrayOpticalDensity = alignData14(sCompareXray,sComp.stackOpticalDens);
xrayTotal = alignData14(sCompareXray,sComp.sigTotal);
xray_FP = alignData14(sCompareXray,sComp.imageFP);
xray_LFP = alignData14(sCompareXray,sComp.imageLFP);

clear sComp;