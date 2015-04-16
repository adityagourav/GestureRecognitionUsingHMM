function [beta_hat] = backward(A,B,c,X)
    % INPUT :: A(SxS) ,B(TxS)
    % OUTPUT :: beta is TxS
    % A :: SUM ALONG COLUMNS = 1 
    % B :: SUM ALONG ROWS = 1
    
    S = size(A,1);  % number of states
    T = size(X,1);  % timesteps
    beta = zeros(T,S);
    beta_hat = zeros(T,S);
    
%     assert(sum(sum(A,1),2) == S);
%     assert(sum(sum(B,1),2) == S);
    
    beta(T,:) = ones(1,S);
    beta_hat(T,:) = c(T,1)*ones(1,S);       % MIT
%     beta_hat(T,:) = ones(1,S);       % UIUC
    
    for t = T-1:-1:1
       for i = 1:S
          beta(t,i) = nansum(bsxfun(@times,bsxfun(@times,A(i,:),B(X(t+1,1),:)),beta_hat(t+1,:)),2);
       end
       beta_hat(t,:) = c(t,1)*beta(t,:);    % MIT
%        beta_hat(t,:) = c(t+1,1)*beta(t,:);  % UIUC
    end
end