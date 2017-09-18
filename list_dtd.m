clear all;
close all;

imagepath = 'E:\Review\DTD\dtd\images\';
filepath = 'E:\Review\DTD\dtd\labels\';
train_filename = 'train1.txt';
test_filename = 'test1.txt';
save_filename = 'Res\dtd_list.mat';

fileID = fopen([filepath train_filename]);
train_filenames = textscan(fileID,'%s %*[^\n]');
train_filenames = train_filenames{1};
fclose(fileID);
fileID = fopen([filepath test_filename]);
test_filenames = textscan(fileID,'%s %*[^\n]');
test_filenames = test_filenames{1};
fclose(fileID);

class_name = []
for i = 1 : size(train_filenames,1)
    str = train_filenames{i};
    C = strsplit(str, '/');
    class_name = [class_name, C(1)];
end
class_name = unique(class_name)

patch_width = -1; patch_height = -1;

no_classes = size(class_name, 2); %% Should be 61. This is the number of classes you are going to used during the modeling and classification phase
no_training_classes = no_classes; %% Should be 20. This is the number of classes you are going to used during the texton dictionary phase
training_classes = 1:no_classes;

total_images_per_class = size(train_filenames,1) / no_classes; %% Total number of images per texture class
training_per_class = total_images_per_class; %% Number of images used per texture to build histogram models
test_per_class = total_images_per_class; %% Number of images used per texture to be classified

training_images = cell(total_images_per_class, no_training_classes);
%% collect all training images 
'collect all training images'
for c=1:no_training_classes 
    prefix = class_name(c); 
    j = 1;
    for i = 1 : size(train_filenames,1)
        str = train_filenames{i};
        C = strsplit(str, '/');
        filename = strrep(train_filenames(i), '/', '\');
        if strcmp(prefix, C{1})
            training_images(j,c) = cellstr([imagepath, filename{1}]);
            j = j+1;
        end
    end
end

test_images = cell(total_images_per_class, no_training_classes);
%% collect all test images 
'collect all test images'
for c=1:no_training_classes 
    prefix = class_name(c); 
    j = 1;
    for i = 1 : size(test_filenames,1)
        str = test_filenames{i};
        C = strsplit(str, '/');
        filename = strrep(test_filenames(i), '/', '\');
        if strcmp(prefix, C{1})
            test_images(j,c) = cellstr([imagepath, filename{1}]);
            j = j+1;
        end
    end
end

save(save_filename)