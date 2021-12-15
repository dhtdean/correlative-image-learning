function [sCompare] = alignData13(sCompare,numberIter)
tic
% Colin Ophus - May 2019
% 13 - iterative remapping function


% Inputs
stepSizeInit = 0.5/5;%0.1*4;
flagPlot = true;
flagForceLinear = true;  % use this option to convert 4 coords to 3 (linear)

if nargin == 1
    numberIter = 1;
end


% Initial score
sizeOutput = size(sCompare.align4DSTEM);
imageOutput = remap(sCompare.alignImage,...
    sCompare.basis,sCompare.kxy,sizeOutput);

mask = sCompare.alignMask;
score = corr(sCompare.align4DSTEM(mask),imageOutput(mask));


% Init
    step = stepSizeInit;
numPoints = numel(sCompare.kxy);
if ~isfield(sCompare,'stats')
%     step = stepSizeInit;
    sCompare.stats = [0 score step];
else
%     step = sCompare.stats(end,3);
end

% main loop
for a0 = 1:numberIter
    
    % Test each point moving up and down
    numChanges = 0;
    for a1 = 1:numPoints
        kxyTest = sCompare.kxy;
        
        kxyTest(a1) = kxyTest(a1) + step;
        imageOutput = remap(sCompare.alignImage,...
            sCompare.basis,kxyTest,sizeOutput);

        scoreUp = corr(sCompare.align4DSTEM(mask),imageOutput(mask));
        
        kxyTest(a1) = kxyTest(a1) - 2*step;
        imageOutput = remap(sCompare.alignImage,...
            sCompare.basis,kxyTest,sizeOutput);

        scoreDown = corr(sCompare.align4DSTEM(mask),imageOutput(mask));

        
        if scoreUp > score
            sCompare.kxy(a1) = sCompare.kxy(a1) + step;
            score = scoreUp;
            numChanges = numChanges + 1;
        elseif scoreDown > score
            sCompare.kxy(a1) = sCompare.kxy(a1) - step;
            score = scoreDown;
            numChanges = numChanges + 1;
        end
        
        comp = (a1 / numPoints ...
            + a0 - 1) / numberIter;
        progressbar(comp,2);
    end
    
    if flagForceLinear == true
        basisTemp = [ ...
            1 0 1;
            1 1 1;
            1 0 0;
            1 1 0];
        beta = basisTemp \ sCompare.kxy;
        kxyFit = basisTemp * beta;
        sCompare.kxy = (kxyFit + sCompare.kxy) / 2;
        
        % Recompute score
        imageOutput = remap(sCompare.alignImage,...
            sCompare.basis,sCompare.kxy,sizeOutput);

        score = corr(sCompare.align4DSTEM(mask),imageOutput(mask));
    end
    
    % stats
    ind = size(sCompare.stats,1);
    sCompare.stats(ind+1,:) = [ind score step];
    
    if numChanges == 0
        step = step / 2;
    end
    
    if flagPlot == true
%         intRange = [ ...
%             -2 1;
%             -1 1];
                intRange = [ ...
             -3 1;
            -2 1];

        Ip1 = imageOutput;
        %         intRange = [min(Ip1(sCompare.alignMask)) max(Ip1(sCompare.alignMask))];
        %         Ip1(:) = (Ip1 - intRange(1)) / (intRange(2) - intRange(1));
        %         Ip1(:) = min(max(Ip1,0),1);
        Ip1 = Ip1 - mean(Ip1(mask));
        Ip1 = Ip1 / sqrt(mean(Ip1(mask).^2));
        Ip1(:) = (Ip1 - intRange(1,1)) / (intRange(1,2) - intRange(1,1));
        Ip1(:) = min(max(Ip1,0),1);
        
        Ip2 = sCompare.align4DSTEM;
        %         intRange = [min(Ip2(sCompare.alignMask)) max(Ip2(sCompare.alignMask))];
        %         Ip2(:) = (Ip2 - intRange(1)) / (intRange(2) - intRange(1));
        %         Ip2(:) = min(max(Ip2,0),1);
        Ip2 = Ip2 - mean(Ip2(mask));
        Ip2 = Ip2 / sqrt(mean(Ip2(mask).^2));
        Ip2(:) = (Ip2 - intRange(2,1)) / (intRange(2,2) - intRange(2,1));
        Ip2(:) = min(max(Ip2,0),1);

        figure(11)
        clf
        Irgb = zeros(size(imageOutput,1),size(imageOutput,2),3);
        Irgb(:,:,1) = Ip1;
        Irgb(:,:,2) = Ip2;
        Irgb(:,:,3) = Ip2;
        Irgb(:) = min(max(Irgb(:),0),1);
        imagesc([repmat(Ip1,[1 1 3]); Irgb; repmat(Ip2,[1 1 3])])
        %         imagesc(Irgb)
        %         imagesc([sCompare.align4DSTEM;
        %             imageOutput]);
        axis equal off
        set(gca,'position',[0 0 1 1])
        drawnow;
    end
end
figure(10)
clf
plot(sCompare.stats(:,1),sCompare.stats(:,2),'linewidth',2,'color','r')


% Output the aligned image
sCompare.alignImage_resampled = ...
    remap( ...
    sCompare.alignImage,...
    sCompare.basis,sCompare.kxy,sizeOutput,-1);



% intRange = [ ...
%     -1 1;
%     -1 1];
        intRange = [ ...
            -3 1;
            -2 1];

Ip1 = imageOutput;
Ip1 = Ip1 - mean(Ip1(mask));
Ip1 = Ip1 / sqrt(mean(Ip1(mask).^2));
Ip1(:) = (Ip1 - intRange(1,1)) / (intRange(1,2) - intRange(1,1));
Ip1(:) = min(max(Ip1,0),1);

Ip2 = sCompare.align4DSTEM;
Ip2 = Ip2 - mean(Ip2(mask));
Ip2 = Ip2 / sqrt(mean(Ip2(mask).^2));
Ip2(:) = (Ip2 - intRange(2,1)) / (intRange(2,2) - intRange(2,1));
Ip2(:) = min(max(Ip2,0),1);

figure(11)
clf
Irgb = zeros(size(imageOutput,1),size(imageOutput,2),3);
Irgb(:,:,1) = Ip1;
Irgb(:,:,2) = Ip2;
Irgb(:,:,3) = Ip2;
Irgb(:) = min(max(Irgb(:),0),1);
imagesc([repmat(Ip1,[1 1 3]); Irgb; repmat(Ip2,[1 1 3])])
%         imagesc([sCompare.align4DSTEM;
%             imageOutput]);
axis equal off
set(gca,'position',[0 0 1 1])
drawnow;




toc
end


function [imageOutput] = remap(imageInput,basis,kxy,sizeOutput,nullValue)
if nargin == 4
    nullValue = 0;
end

xyInd = basis * kxy;
xF = floor(xyInd(:,1));
yF = floor(xyInd(:,2));
dx = xyInd(:,1) - xF;
dy = xyInd(:,2) - yF;


xyInds = [ ...
    xF+0 yF+0;
    xF+1 yF+0;
    xF+0 yF+1;
    xF+1 yF+1];
sub = xyInds(:,1) >= 1 ...
    & xyInds(:,2) >= 1 ...
    & xyInds(:,1) <= sizeOutput(1) ...
    & xyInds(:,2) <= sizeOutput(2);
weights =  [ ...
    (1-dx).*(1-dy);
    (  dx).*(1-dy);
    (1-dx).*(  dy);
    (  dx).*(  dy)];
imageRep = repmat(imageInput(:),[4 1]);
imageOutput = accumarray(xyInds(sub,:),...
    imageRep(sub).*weights(sub),...
    sizeOutput);
imageNorm = accumarray(xyInds(sub,:),...
    weights(sub),...
    sizeOutput);
sub = imageNorm > 1e-2;
imageOutput(sub) = imageOutput(sub) ./ imageNorm(sub);
imageOutput(~sub) = nullValue;


% xyInd = basis * kxy;
% sub = xyInd(:,1) >= 1 ...
%     & xyInd(:,2) >= 1 ...
%     & xyInd(:,1) <= sizeOutput(1)-1 ...
%     & xyInd(:,2) <= sizeOutput(2)-1;
% xF = floor(xyInd(sub,1));
% yF = floor(xyInd(sub,2));
% dx = xyInd(sub,1) - xF;
% dy = xyInd(sub,2) - yF;
%
%
% xyInds = [ ...
%     xF+0 yF+0;
%     xF+1 yF+0;
%     xF+0 yF+1;
%     xF+1 yF+1];
% weights =  [ ...
%     (1-dx).*(1-dy);
%     (  dx).*(1-dy);
%     (1-dx).*(  dy);
%     (  dx).*(  dy)];
%
% imageOutput = accumarray(xyInds,...
%     repmat(imageInput(sub),[4 1]).*weights,...
%     sizeOutput);
% imageNorm = accumarray(xyInds,weights,sizeOutput);
% sub = imageNorm > 1e-2;
% imageOutput(sub) = imageOutput(sub) ./ imageNorm(sub);

end