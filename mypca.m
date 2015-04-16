function [X_pca] = mypca(X,k) 
    Xc = bsxfun(@minus,X,mean(X,1));
    [~,~,V] = svd(Xc);
    X_pca = Xc*V(:,1:k);
end
