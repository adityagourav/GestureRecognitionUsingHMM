
load data1.mat;
pattern = beat4;
K = 20;
[id, centroid] = kmeans(pattern(:,2:7),K,'MaxIter',500);
indices = crossvalind('Kfold',size(pattern,1),10);

trainX = [id(indices~=10,:) pattern(indices~=10,2:7) ];
testX = [id(indices==10,:) pattern(indices==10,2:7) ];
%% visualize
pattern_pca = mypca(pattern(:,2:7),2);
% gscatter(pattern_pca(:,1),pattern_pca(:,2),id);
c = ['r','g','b','k','y','m','c'];
for i=1:K
    X = pattern_pca((id == i),:);
    scatter(X(:,1),X(:,2),c(mod(i,7)+1));
    hold on;
end

%%


