function D = knn_calc_dist(X,Xnew,dist_type)

% calculation of distances between samples of X and Xnew
% dist_type:    'euclidean' Euclidean distance
%               'mahalanobis' Mahalanobis distance
%               'cityblock' City Block metric
%               'minkowski' Minkowski metric
%               'sm' sokal-michener for binary data
%               'rt' rogers-tanimoto for binary data
%               'jt' jaccard-tanimoto for binary data
%               'gle' gleason-dice sorenson for binary data
%               'ct4' consonni todeschini for binary data
%               'ac' austin colwell for binary data
%
% The main routine is class_gui
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Classification toolbox for MATLAB
% version 4.0 - October 2015
% Davide Ballabioabout
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

% fast euclidean distance
% D_squares_x = (sum(Xnew'.^2))'*ones(1,size(X,1));
% D_squares_w = ones(1,size(Xnew,1))'*sum(X'.^2);
% D_product   = - 2*(Xnew*X');
% D = (D_squares_x2 + D_squares_w2 + D_product2).^0.5;

if strcmp(dist_type,'mahalanobis')
    inv_covX = pinv(cov(X));
end
for i=1:size(Xnew,1)
    if strcmp(dist_type,'euclidean')
        x_in = Xnew(i,:);
        D_squares_x = (sum(x_in'.^2))'*ones(1,size(X,1));
        D_squares_w = sum(X'.^2);
        D_product   = - 2*(x_in*X');
        D(i,:) = (D_squares_x + D_squares_w + D_product).^0.5; 
    elseif strcmp(dist_type,'chi')
        for j=1:size(X,1)
            D(i,j) = chi2dist(Xnew',X(j,:)');
        end
        %D2 = chi_square_statistics_fast(Xnew',X(:,:)');
    else
        for j=1:size(X,1)
            x = Xnew(i,:);
            y = X(j,:);
            if strcmp(dist_type,'mahalanobis')
                D(i,j) = ((x - y)*inv_covX*(x - y)')^0.5;
            elseif strcmp(dist_type,'cityblock')
                D(i,j) = sum(abs(x - y));
            elseif strcmp(dist_type,'minkowski')
                p = 2;
                D(i,j) = (sum((abs(x - y)).^p))^(1/p);
            else
                [a,bc,d,p] = calcbinary(x,y);
                if strcmp(dist_type,'sm')
                    D(i,j)=1-((a+d)/p);
                elseif strcmp(dist_type,'rt')
                    D(i,j)=1-((a+d)/(p+bc));
                elseif strcmp(dist_type,'jt')
                    D(i,j)=1-(a/(a+bc));
                elseif strcmp(dist_type,'gle')
                    D(i,j)=1-(2*a/(2*a+bc));
                elseif strcmp(dist_type,'ct4')
                    D(i,j)=1-(log2(1+a)/log2(1+a+bc));
                elseif strcmp(dist_type,'ac')
                    D(i,j)=1-((2/pi)*asin(sqrt((a+d)/p)));
                end
            end
        end
    end
end

% ------------------------------------------------
function [a,bc,d,p] = calcbinary(x,y)
p = length(x);
s = sum([x; y]);
a = length(find(s==2));
bc = length(find(s==1));
d = length(find(s==0));