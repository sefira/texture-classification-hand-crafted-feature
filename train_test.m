clear all;
close all;
run('../vlfeat-0.9.19/vlfeat-0.9.19/toolbox/vl_setup')
vl_version verbose

dataset_type = 'fmd'
filter_type = 'MR8'

switch dataset_type
    case 'dtd'
        load('Res/dtd_list.mat')
    case 'fmd'
        load('Res/fmd_list.mat')
    case 'kth'
        load('Res/kth_list.mat')
end

%% Specify the filter to be used.
switch filter_type
    case 'LM'
        filter_bank  = makeLMfilters; %%  to use LM Filter bank
        %% filter_bank = [49, 49, 48]
        training_options = 'LM'; %% To indicate that you are going to extract the MR-8 from RFS repos.
        classification_options = 'LM';
    case 'S'
        filter_bank  = makeSfilters; %%  to use S Filter bank
        %% filter_bank = [49, 49, 13]
        training_options = 'S'; %% To indicate that you are going to extract the MR-8 from RFS repos.
        classification_options = 'S';
    case 'MR8'
        filter_bank = makeRFSfilters; %%  to use RFS Filter bank
        %% filter_bank = [49, 49, 38]
        training_options = 'MR8'; %% To indicate that you are going to extract the MR-8 from RFS repos.
        classification_options = 'MR8';
    case 'patch33'
        filter_bank  = makePATCHfilters(3); %%  to use patch33 Filter bank
        %% filter_bank = [3, 3, 9]
        training_options = 'patch33'; %% To indicate that you are going to extract the MR-8 from RFS repos.
        classification_options = 'patch33';
    case 'patch77'
        filter_bank  = makePATCHfilters(7); %%  to use patch77 Filter bank
        %% filter_bank = [7, 7, 49]
        training_options = 'patch77'; %% To indicate that you are going to extract the MR-8 from RFS repos.
        classification_options = 'patch77';
end

numOfFilters = size(filter_bank,3); %% numOfFilters = 38
if strfind(training_options, 'MR8')
    numOfFilters = 8;
end


KNN = 1; %% for classify_images


numClustersPerClass = ceil(2048/no_classes);
NUM_BINS = numClustersPerClass * no_classes;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params = {};
params.numOfFilters = numOfFilters;
params.numClustersPerClass = numClustersPerClass;
params.no_training_classes = no_training_classes;
params.patch_width = patch_width;
params.patch_height = patch_height;
params.filter_bank = filter_bank;
params.training_options = training_options;
params.total_images_per_class = total_images_per_class;
params.total_images = training_images;

[ training_class_centroid ] = build_texton_dictionary( params );
save(['Res/', dataset_type, filter_type, 'texton_dictionary', '.mat'], ...
    'training_class_centroid')



params = {};
params.patch_width = patch_width;
params.patch_height = patch_height;
params.filter_bank = filter_bank;
params.training_options = training_options;
params.training_images = training_images;
params.training_class_centroid = training_class_centroid;
params.NUM_BINS = NUM_BINS;
params.training_per_class = training_per_class;
params.no_classes = no_classes;

[ training_histogram,training_classes ] = build_histogram_models( params);
save(['Res/', dataset_type, filter_type, 'histogram_models', '.mat'], ...
    'training_histogram','training_classes')


addpath(genpath('../classification_toolbox_5.0'))
params = {};
params.patch_width = patch_width;
params.patch_height = patch_height;
params.filter_bank = filter_bank;
params.classification_options = classification_options;
params.training_class_centroid = training_class_centroid;
params.NUM_BINS = NUM_BINS;
params.no_classes = no_classes;
params.training_histogram = training_histogram;
params.training_classes = training_classes;
params.test_images = test_images;
params.test_per_class = test_per_class;
params.KNN = KNN;
[test_histogram,test_classes, accuracy ] = classify_images( params );
save(['Res/', dataset_type, filter_type, 'classify_images', '.mat'], ...
    'test_histogram','test_classes','accuracy')



figure;imagesc(accuracy);
mean(diag(accuracy) * 100 / test_per_class)
per_class_accuracy = diag(accuracy) * 100 / test_per_class;