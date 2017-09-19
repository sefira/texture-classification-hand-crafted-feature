clear all;
close all;

imagepath = '../../FMD/image/';
filepath = '../../FMD/';
train_test_filename = 'fmd_ave.csv';
save_filename = 'Res/fmd_list.mat';

fileID = fopen([filepath train_test_filename]);
train_test_filenames = textscan(fileID,'%s%s%d%d', 'delimiter',',');
fclose(fileID);

class_name = unique(train_test_filenames{2})

patch_width = -1; patch_height = -1;

no_classes = size(class_name, 1); %% Should be 61. This is the number of classes you are going to used during the modeling and classification phase
no_training_classes = no_classes; %% Should be 20. This is the number of classes you are going to used during the texton dictionary phase
training_classes = 1:no_classes;

total_images_per_class = 33; %% Total number of images per texture class
training_per_class = 34; %% Number of images used per texture to build histogram models
test_per_class = 33; %% Number of images used per texture to be classified

training_images = cell(training_per_class, no_training_classes);
test_images = cell(test_per_class, no_training_classes);
%% collect all training test images 
'collect all training test images'

for i = 1 : size(train_test_filenames{1},1)
    filename = train_test_filenames{1}{i};
    c = train_test_filenames{3}(i);
    s = train_test_filenames{4}(i);
    if s == 1
        index = find(cellfun(@isempty,training_images(:,c)),1);
        training_images(index,c) = cellstr([imagepath, filename]);
    end
    if s == 3
        index = find(cellfun(@isempty,test_images(:,c)),1);
        test_images(index,c) = cellstr([imagepath, filename]);
    end
end

save(save_filename)