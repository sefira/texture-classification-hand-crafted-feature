
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
