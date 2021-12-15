function [sCompare] = alignData11(sCompare,imageAlign)

% Colin Ophus - July 2019
% 11 - generate inputs for alignment

% Ptych
flagUseMask = 0;
flagFlipImage = 1;
% flagUseMask = 1;
% flagFlipImage = 0;


erodeSteps = 1;


if flagUseMask == false
    sCompare.align4DSTEM = -1*sCompare.STEM4D_DF;
    sCompare.alignMask = bwmorph(sCompare.STEM4D_mask,'erode',erodeSteps);
else
    sx = fspecial('sobel');
    k = fspecial('gaussian',5,1);
    sx = conv2(sx,k,'full');
    imageEdge = sqrt( ...
        conv2(double(sCompare.STEM4D_mask),sx,'same').^2 + ...
        conv2(double(sCompare.STEM4D_mask),sx','same').^2);
    
    
    
    sCompare.align4DSTEM = imageEdge;
    sCompare.alignMask = bwmorph(true(size(sCompare.STEM4D_mask)),'erode',4);
end


if flagFlipImage == false
    sCompare.alignImage = imageAlign;
else
    sCompare.alignImage = fliplr(imageAlign);    
end

figure(1)
clf
imagesc(sCompare.align4DSTEM)
axis equal off
colormap(gray(256))
set(gca,'position',[0 0 1 1])
cR = [min(sCompare.align4DSTEM(sCompare.alignMask)) ...
    max(sCompare.align4DSTEM(sCompare.alignMask))];
caxis(cR)


figure(2)
clf
imagesc(sCompare.alignImage)
axis equal off
colormap(gray(256))
set(gca,'position',[0 0 1 1])
cR = [min(sCompare.alignImage(:)) ...
    max(sCompare.alignImage(:))];
caxis(cR)


% sCompare.upsampleFactor4DSTEM = 1;
% % sCompare.alignSigma4DSTEM = 1;
% sCompare.intRange4DSTEM = [10 20];
% sCompare.intRangeXray = [-0.99 -0.98];
% 
% % correlation instead of mask for scoring function
% sCompare.flagCorr = true;
% intRange4DSTEM = [2.00 2.15];
% intRangeXray = [0 1];
% 
% 
% % upsample 4DSTEM
% sCompare.image_4DSTEM_DF_us = ...
%     imresize(sCompare.image_4DSTEM_DF,...
%     sCompare.upsampleFactor4DSTEM,...
%     'bilinear');
% sCompare.image_4DSTEM_acRatio_us = ...
%     imresize(sCompare.image_4DSTEM_acRatio,...
%     sCompare.upsampleFactor4DSTEM,...
%     'bilinear');
%     
%     
% % % Scale masks for alignment
% % if sCompare.alignSigma4DSTEM > 0
% % else
% % end
% if sCompare.flagCorr == false
%     sCompare.align4DSTEM = ...
%         (sCompare.image_4DSTEM_DF_us - sCompare.intRange4DSTEM(1)) ...
%         / (sCompare.intRange4DSTEM(2) - sCompare.intRange4DSTEM(1));
%     sCompare.alignXray = ...
%         (sCompare.image_Xray_comp - sCompare.intRangeXray(1)) ...
%         / (sCompare.intRangeXray(2) - sCompare.intRangeXray(1));
% else
%     sCompare.align4DSTEM = ...
%         (sCompare.image_4DSTEM_acRatio_us - intRange4DSTEM(1)) ...
%         / (intRange4DSTEM(2) - intRange4DSTEM(1));
%     sCompare.alignXray = ...
%         (sCompare.image_Xray_comp - intRangeXray(1)) ...
%         / (intRangeXray(2) - intRangeXray(1));
% end
% sCompare.align4DSTEM(:) = min(max(sCompare.align4DSTEM,0),1);
% sCompare.alignXray(:) = min(max(sCompare.alignXray,0),1);
% 
% 
% 
% figure(11)
% clf
% imagesc(sCompare.align4DSTEM)
% axis equal off
% colormap(violetFire)
% colorbar
% 
% figure(12)
% clf
% imagesc(sCompare.alignXray)
% axis equal off
% colormap(violetFire)
% colorbar


% figure(11)
% clf
% imagesc(sCompare.image_4DSTEM_DF)
% axis equal off
% colormap(violetFire)
% colorbar
% 
% figure(12)
% clf
% imagesc(sCompare.image_4DSTEM_acRatio)
% axis equal off
% colormap(violetFire)
% colorbar
% 
% figure(13)
% clf
% imagesc(sCompare.image_Xray_comp)
% axis equal off
% colormap(violetFire)
% colorbar


end