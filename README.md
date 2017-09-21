
Texture Classification Hand-crafted Feature
-----------------------------------------------------------------

This repos provides an implementation for these following papers:
[Representing and Recognizing the Visual Appearance of
Materials using Three-dimensional Textons](https://people.eecs.berkeley.edu/~malik/papers/LM-3dtexton.pdf)
[Statistical Approach to Texture Classification from Single Images](http://manikvarma.org/pubs/varma05.pdf)
[ Texture classification: Are filter banks necessary?](http://www.robots.ox.ac.uk/~vgg/publications/papers/varma03.pdf)

The filters (RFS, LM, S) used in this repos are from [this link](http://www.robots.ox.ac.uk/~vgg/research/texclass/filters.html)

Libraries
---------
To be able to run this code, you need to download the following libraries
 - [VLFeat open source library](http://www.vlfeat.org/)
 - [Classification toolbox for MATLAB, by Milano Chemometrics and QSAR Research Group](http://michem.disat.unimib.it/chm/download/softwares/help_classification/web.htm). 
 
 VLFeat Library is used to calculate K-means (vl_kmeans) and the distance between new  nodes and pre-computed centroids (vl_alldist).
 Classification toolbox is used to find the nearest neighbor during the classification phase.

Setup
-----

 1. Download the code.
 2. Download the [Classification toolbox for 
 3. MATLAB, by Milano Chemometrics and QSAR Research Group](http://michem.disat.unimib.it/chm/download/softwares/help_classification/web.htm). 
 3. Update the knn_calc_dist.m file with the file inside this repos, to support chi-square distance
 4. Update the filepath etc. variable in list_dtd.m to point to dataset folder on your machine.
 5. Run list_dtd.m and train_test.m to test the performance over texture dataset.
