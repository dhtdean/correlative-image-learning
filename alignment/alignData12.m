function [sCompare] = alignData12(sCompare)

% Colin Ophus - May 2019

% P01 - 
% sCompare.kxy = [ ...
%     30 0;
%     -30 5;
%     70 65;
%     15 95]; % ptych
% sCompare.kxy = [ ...
%     -10 1;
%     -10 95;
%     55 1;
%     55 95];  % HAADF
% sCompare.kxy = [ ...
%     -50 11;
%     10 105;
%     50 -10;
%     80 75];  % SEM

% % P02
% sCompare.kxy = [ ...
%     30 -5;
%     -30 5;
%     60 55;
%     15 85];
% sCompare.kxy = [ ...
%     -10 -5;
%     -10 80;
%     50 -5;
%     50 80];  % HAADF
% P02 - BIG
sCompare.kxy = [ ...
    90 -10;
    -110 10;
    180 150;
    30 260];
sCompare.kxy = [ ...
    -30 -10;
    -30 240;
    150 -10;
    150 240];  % HAADF
% sCompare.kxy = [ ...
%     -14 -4;
%     -14 80;
%     50 -4;
%     60 80];  % SEM

% % P03
% sCompare.kxy = [ ...
%     30 -5;
%     -25 5;
%     90 110;
%     20 130];  % xray
% sCompare.kxy = [ ...
%     -40 40;
%     28 140;
%     33 -20;
%     105 85];  % HAADF
% 
% % P04
% sCompare.kxy = [ ...
%     65 0;
%     -3 -20;
%     55 100;
%     -10 100];  % xray
% sCompare.kxy = [ ...
%     10 -60;
%     -40 80;
%     110 70;
%     40 110];  % HAADF
% 
% % P5
% sCompare.kxy = [ ...
%     51 11-10;
%     -10 21-10;
%     71 100-10;
%     21 100-0]; % ptych
% sCompare.kxy = [ ...
%     -25 -10;
%     -25 120;
%     90 -10;
%     90 120]; % HAADF


% p6 
sCompare.kxy = [ ...
    100 75;
    1 75;
    100 -15;
    1 -15]; % STXM
sCompare.kxy = [ ...
    -10 -20;
    -10 80;
    100 -20;
    100 80]; % HAADF

% FP particle 01
sCompare.kxy = [ ...
    20 -20;
    80 50;
    -20 90;
    40 120]; % STXM
sCompare.kxy = [ ...
    1 1;
    1 110;
    60 1;
    60 110]; % HAADF


% % FP particle 03
sCompare.kxy = [ ...
    110 1;
    110 60;
    1 1;
    1 60]; % STXM
% sCompare.kxy = [ ...
%     -10 -10;
%     -10 60;
%     110 -10;
%     110 60]; % HAADF

% LFP particle 01
% sCompare.kxy = [ ...
%     30 -20;
%     90 50;
%     -40 70;
%     50 120]; % STXM
sCompare.kxy = [ ...
    1 1;
    1 110;
    60 1;
    60 110]; % HAADF
% % LFP 02
% sCompare.kxy = [ ...
%     40 -20;
%     80 50;
%     -30 70;
%     60 120]; % STXM
% % sCompare.kxy = [ ...
% %     -10 -15;
% %     -10 115;
% %     60 -15;
% %     60 115]; % HAADF
% LFP 03
sCompare.kxy = [ ...
    10 -80;
    220 0;
    -10 60;
    50 140]; % STXM
% sCompare.kxy = [ ...
%     1 1;
%     1 70;
%     140 1;
%     140 70]; % HAADF




%Make basis function for image remapping
mn = [1 1];
N = size(sCompare.alignImage);
u0 = linspace(0,1,N(1));
v0 = linspace(0,1,N(2));
[v,u] = meshgrid(v0,u0);
u = u(:);
v = v(:);

Nbasis = [numel(u) prod(mn+1)];
sCompare.basis = zeros(Nbasis);
for i = 0:mn(1)
    for j = 0:mn(2)
        ind = i*(mn(2)+1) + j + 1;
        sCompare.basis(:,ind) ...
            = nchoosek(mn(1),i).*u.^i.*(1-u).^(mn(1)-i) ...
            .*nchoosek(mn(2),j).*v.^j.*(1-v).^(mn(2)-j);        
    end
end


% % For initial alignment
% figure(14)
% clf
% imagesc(reshape(sCompare.basis(:,1),N))
% axis equal off
% colormap(gray(256))

sizeOutput = size(sCompare.align4DSTEM);
imageOutput = remap(sCompare.alignImage,...
    sCompare.basis,sCompare.kxy,sizeOutput);

Ip1 = imageOutput;
intRange = [min(Ip1(sCompare.alignMask)) max(Ip1(sCompare.alignMask))];
Ip1(:) = (Ip1 - intRange(1)) / (intRange(2) - intRange(1));
Ip1(:) = min(max(Ip1,0),1);

Ip2 = sCompare.align4DSTEM;
% intRange = [min(Ip2(sCompare.alignMask)) max(Ip2(sCompare.alignMask))];
intMean = mean(Ip2(sCompare.alignMask));
intRMS = sqrt(mean((Ip2(sCompare.alignMask)-intMean).^2));
intRange = intMean + [-2 2]*intRMS;
Ip2(:) = (Ip2 - intRange(1)) / (intRange(2) - intRange(1));
Ip2(:) = min(max(Ip2,0),1);

figure(11)
clf
imagesc([Ip1;Ip2])
% Irgb = zeros(size(imageOutput,1),size(imageOutput,2),3);
% Irgb(:,:,1) = Ip1;
% Irgb(:,:,2) = Ip2;
% Irgb(:,:,3) = Ip2;
% Irgb(:) = min(max(Irgb(:),0),1);
% imagesc(Irgb)
axis equal off
set(gca,'position',[0 0 1 1])
drawnow;



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