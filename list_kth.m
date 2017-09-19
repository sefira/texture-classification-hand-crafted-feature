clear all;
close all;

imagepath = '../../KTH-TIPS2/KTH-TIPS2-b/';
filepath = '../../KTH-TIPS2/';
train_test_filename = 'kth.csv';
save_filename = 'Res/kth_list.mat';

fileID = fopen([filepath train_test_filename]);
train_test_filenames = textscan(fileID,'%s%s%d%d', 'delimiter',',');
fclose(fileID);

class_name = unique(train_test_filenames{2})

patch_width = -1; patch_height = -1;

no_classes = size(class_name, 1); %% Should be 61. This is the number of classes you are going to used during the modeling and classification phase
no_training_classes = no_classes; %% Should be 20. This is the number of classes you are going to used during the texton dictionary phase
training_classes = 1:no_classes;

total_images_per_class = 108; %% Total number of images per texture class
training_per_class = 108; %% Number of images used per texture to build histogram models
test_per_class = 108*3; %% Number of images used per texture to be classified

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

% reduce data
total_images_per_class_temp = 40; %% Total number of images per texture class
training_per_class_temp = 40; %% Number of images used per texture to build histogram models
test_per_class_temp = 42; %% Number of images used per texture to be classified

training_images_temp = cell(training_per_class_temp, no_training_classes);
test_images_temp = cell(test_per_class_temp, no_training_classes);
%% collect all training test images 
'collect all training test images'

for c = 1 : no_classes
    perm = randperm(training_per_class);
    sel = perm(1:training_per_class_temp);
    training_images_temp(:,c) = training_images(sel,c);

    perm = randperm(test_per_class);
    sel = perm(1:test_per_class_temp);
    test_images_temp(:,c) = test_images(sel,c);
end

total_images_per_class = total_images_per_class_temp; %% Total number of images per texture class
training_per_class = training_per_class_temp; %% Number of images used per texture to build histogram models
test_per_class = test_per_class_temp; %% Number of images used per texture to be classified
training_images = training_images_temp;
test_images = test_images_temp;


save(save_filename)