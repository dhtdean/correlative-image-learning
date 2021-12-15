function [inputXrayTotal,inputXrayComp,inputXrayMask] = importSTXM(fbase)

maskRange = [0.05 0.10];
flagCleanMask = true;
minMaskRegionSize = 20;

if nargin == 0
    fbase = 'C:\Matlab\ToyotaResearchInstitute\DengSTXM\L50FP\P6\NS_19031005';

    % FP
%         fbase = 'C:\Matlab\ToyotaResearchInstitute\DengSTXM\FP\15\NS_19030919';
%     fbase = 'C:\Matlab\ToyotaResearchInstitute\DengSTXM\FP\027\NS_19031002';
%     fbase = 'C:\Matlab\ToyotaResearchInstitute\DengSTXM\FP\205\NS_19030920';

% % LFP
%     fbase = 'C:\Matlab\ToyotaResearchInstitute\DengSTXM\LFP\150\NS_19030915';
%     fbase = 'C:\Matlab\ToyotaResearchInstitute\DengSTXM\LFP\151\NS_19030915';
    fbase = 'C:\Matlab\ToyotaResearchInstitute\DengSTXM\LFP\159\NS_19030915';
end

filename1 = [fbase 'rgbrightness.txt'];
filename2 = [fbase 'rgcompo.txt'];

% C = textscan(filename1,'%f');
% size(C)
inputXrayTotal = importdata(filename1);
inputXrayComp = importdata(filename2);

% make mask
inputXrayMask = (inputXrayTotal - maskRange(1)) ...
    / (maskRange(2) - maskRange(1));
inputXrayMask(:) = min(max(inputXrayMask,0),1);
inputXrayMask(:) = sin(inputXrayMask*(pi/2)).^2;

% Clean up the mask?
if flagCleanMask == true
    CC = bwconncomp(inputXrayMask > 0.2);
    
    for a0 = 1:CC.NumObjects
        if length(CC.PixelIdxList{a0}) < minMaskRegionSize
            
            maskTemp = false(size(inputXrayMask));
            maskTemp(CC.PixelIdxList{a0}) = true;
            maskTemp(:) = bwmorph(maskTemp,'dilate',1);
            inputXrayMask(maskTemp) = 0;
        end
    end
    
end


end