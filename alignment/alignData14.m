function [stackAligned] = alignData14(sCompare,stack)

% Apply alignments to stack of images

flagFlipImage = 1;
nullValue = 0;

N = [size(stack,1) size(stack,2) size(stack,3)];
sizeOutput = size(sCompare.align4DSTEM);
stackAligned = zeros(sizeOutput(1),sizeOutput(2),N(3));



for a0 = 1:N(3)
    if flagFlipImage == false
        imageInput = stack(:,:,a0);
    else
        imageInput = fliplr(stack(:,:,a0));        
    end
    stackAligned(:,:,a0) = ...
        remap( ...
        imageInput,...
        sCompare.basis,sCompare.kxy,sizeOutput(1:2),nullValue);
end

figure(115)
clf
imagesc(abs(stackAligned(:,:,a0)))
axis equal off
colormap(gray(256))
set(gca,'position',[0 0 1 1])



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
end