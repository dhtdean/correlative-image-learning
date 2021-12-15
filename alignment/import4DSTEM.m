function [sCompare] = import4DSTEM()

% Quick and dirty import of 4DSTEM data - new version!



% if nargin == 0
% end
% filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190302_LFP_50percentDelithiated\Particle1_4DSTEM_processing.h5';
% theta = '-164.12021946225659';  % P1

% Get theta
% s.Groups(1).Groups(1).Groups(5).Groups.Name

% 50 50 particles

% filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190302_LFP_50percentDelithiated\Particle2_4DSTEM_processing.h5';
% theta = '-160.000497444999';
% 
% filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190302_LFP_50percentDelithiated\Particle3_4DSTEM_processing.h5';
% theta = '-170.0474479139184';
% 
% filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190302_LFP_50percentDelithiated\Particle4_4DSTEM_processing.h5';
% theta = '-28.74241447121299';
% % 
% % filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190302_LFP_50percentDelithiated\Particle5_4DSTEM_processing.h5';
% % theta = '-166.77552665637486';
% 
% % Particle 2 - stack 2
% filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190302_LFP_50percentDelithiated\Particle2_Stack2_4DSTEM_processing.h5';
% theta = '-159.92';

% particle 06
filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190302_LFP_50percentDelithiated\Particle6_4DSTEM_processing.h5';
theta = '-118.25031061363345';

% s.Groups(1).Groups(1).Groups(5).Groups.Name
% FP #1
filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190307_FP_fullyDelithiated\Particle1_4DSTEM_processing.h5';
theta = '-145.28837047269';
% FP #3
filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190307_FP_fullyDelithiated\Particle3_4DSTEM_processing.h5';
theta = '-100.66684656035851';

% s.Groups(1).Groups(1).Groups(5).Groups.Name
% LFP #1
filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190307_LFP_fullyLithiated\Particle1_4DSTEM_processing.h5';
theta = '-143.6114543872342';
% LFP #2
filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190307_LFP_fullyLithiated\Particle2_4DSTEM_processing.h5';
theta = '-141.8057000424374';
% LFP #3
filename = 'N:\Data\ToyotaResearchInstitute\FP_LFP_processed\20190307_LFP_fullyLithiated\Particle3_4DSTEM_processing.h5';
theta = '-46.94607641566786';


sCompare.filename = filename;

% Mask
mask = h5read(filename,...
    '/4DSTEM_experiment/data/realslices/mask_realspace/realslice');
% mask = h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/mask_realspace/data');

N = size(mask);
sCompare.STEM4D_mask = false(N);
for ax = 1:N(1)
    for ay = 1:N(2)
        if strcmp(mask{ax,ay},'TRUE') == true
            sCompare.STEM4D_mask(ax,ay) = true;
        end
    end
end


% % % % Get some of the virtual images
% % % sCompare.STEM4D_BF_0_0 =  h5read(filename,...
% % %     ['/4DSTEM_experiment/data/realslices' ...
% % %     '/virtual_dark_field_apertureradius=45/0_0']);
% % % 
% % % sCompare.STEM4D_BF_0_1 =  h5read(filename,...
% % %     ['/4DSTEM_experiment/data/realslices' ...
% % %     '/virtual_dark_field_apertureradius=45/0_1']);
% % % sCompare.STEM4D_BF_0_n1 = h5read(filename,...
% % %     ['/4DSTEM_experiment/data/realslices' ...
% % %     '/virtual_dark_field_apertureradius=45/0_-1']);
% % % sCompare.STEM4D_BF_1_0 =  h5read(filename,...
% % %     ['/4DSTEM_experiment/data/realslices' ...
% % %     '/virtual_dark_field_apertureradius=45/1_0']);
% % % sCompare.STEM4D_BF_n1_0 =  h5read(filename,...
% % %     ['/4DSTEM_experiment/data/realslices' ...
% % %     '/virtual_dark_field_apertureradius=45/-1_0']);

% % Get 4DSTEM dark field
sCompare.STEM4D_DF = h5read(filename,...
    '/4DSTEM_experiment/data/realslices/DF_image/realslice');
% % Get 4DSTEM dark field
% sCompare.STEM4D_DF = h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/DF_image/data');
% sCompare.STEM4D_DF = h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/0_0');

% sCompare.STEM4D_DF = ...
%     h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/1_0') ...
%     + h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/-1_0') ...
%     + h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/0_1') ...
%     + h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/0_-1') ...
%     ...
%         + h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/1_1') ...
% + h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/-1_1') ...
%     + h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/1_-1') ...
%     + h5read(filename,...
%     '/4DSTEM_experiment/data/realslices/virtual_dark_field_apertureradius=45/-1_-1');    


% Strain maps

sCompare.STEM4D_strain_exx = h5read(filename,...
    ['/4DSTEM_experiment/data/realslices' ...
    '/strain_map_rotated_by_' theta '/e_xx']);
sCompare.STEM4D_strain_eyy = h5read(filename,...
    ['/4DSTEM_experiment/data/realslices' ...
    '/strain_map_rotated_by_' theta '/e_yy']);
sCompare.STEM4D_strain_exy = h5read(filename,...
    ['/4DSTEM_experiment/data/realslices' ...
    '/strain_map_rotated_by_' theta '/e_xy']);
sCompare.STEM4D_strain_theta = h5read(filename,...
    ['/4DSTEM_experiment/data/realslices' ...
    '/strain_map_rotated_by_' theta '/theta']);

sCompare.STEM4D_lattice_param_u = h5read(filename,...
    ['/4DSTEM_experiment/data/realslices' ...
    '/lattice_parameters_Angs/u']);
sCompare.STEM4D_lattice_param_v = h5read(filename,...
    ['/4DSTEM_experiment/data/realslices' ...
    '/lattice_parameters_Angs/v']);

% sCompare.STEM4D_strainAll =  h5read(filename,...
%     ['/4DSTEM_experiment/data/realslices' ...
%     '/strain_map_rotated_by_' theta '/data']);
% sCompare.STEM4D_LatticeParamsAll =  h5read(filename,...
%     ['/4DSTEM_experiment/data/realslices' ...
%     '/lattice_parameters_Angs/data']);
% 
% sCompare.STEM4D_strainAll = permute(sCompare.STEM4D_strainAll,[2 3 1]);
% sCompare.STEM4D_strain_exx = sCompare.STEM4D_strainAll(:,:,1);
% sCompare.STEM4D_strain_eyy = sCompare.STEM4D_strainAll(:,:,2);
% sCompare.STEM4D_strain_exy = sCompare.STEM4D_strainAll(:,:,3);
% sCompare.STEM4D_strain_theta = sCompare.STEM4D_strainAll(:,:,4);
% 
% sCompare.STEM4D_LatticeParamsAll = permute(sCompare.STEM4D_LatticeParamsAll,[2 3 1]);
% sCompare.STEM4D_lattice_param_u = sCompare.STEM4D_LatticeParamsAll(:,:,1);
% sCompare.STEM4D_lattice_param_v = sCompare.STEM4D_LatticeParamsAll(:,:,2);





% s.Groups.Groups(1).Groups(5).Groups(7).Datasets.Name


% % Get 4DSTEM dark field
% sCompare.image_4DSTEM_DF = h5read(fname,...
%     '/4DSTEM_experiment/data/realslices/virtualdarkfield/realslice');
% 
% % Get 4DSTEM composition
% sCompare.image_4DSTEM_acRatio = h5read(fname,...
%     '/4DSTEM_experiment/data/realslices/ac_ratio/realslice');
%  
% % Get x-ray composition
% sCompare.image_Xray_comp = h5read(fname,...
%     '/4DSTEM_experiment/data/realslices/xray_composition/realslice');


end