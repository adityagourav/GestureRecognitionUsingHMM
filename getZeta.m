function [zeta] = getZeta(A,B,alpha_hat,beta_hat,c,X)
    
    % INPUT :: A(SxS) ,B(TxS). alpha(TxS), beta(TxS)
    % OUTPUT :: zeta is SxSxT
    % USAGE :: getZeta(A,B,alpha,beta)
    % A :: SUM ALONG COLUMNS = 1 
    % B :: SUM ALONG ROWS = 1
    
    S = size(A,1);
    T = size(alpha_hat,1);
    zeta = zeros(S,S,T);
    
%     assert(sum(sum(A,1),2) == S);
%     assert(sum(sum(B,1),2) == S);

    for t = 1:T-1
        for s = 1:S
            zeta(s,:,t) = bsxfun(@times,bsxfun(@times,A(s,:),B(X(t+1,1),:)),beta_hat(t+1,:))...
                *alpha_hat(t,s)*c(t,1);
        end
        zeta(:,:,t) = zeta(:,:,t)/sum(bsxfun(@times,alpha_hat(t,:),beta_hat(t,:)),2);
    end
    
    
    
end