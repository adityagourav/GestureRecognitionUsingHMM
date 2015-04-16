function [alpha_hat, term_prob, c] = forward(A,B,pinit,X)
    % INPUT :: A(SxS) ,B(TxS) , PINIT(1,S)
    % OUTPUT :: alpha is TxS
    % A :: SUM ALONG COLUMNS = 1 
    % B :: SUM ALONG ROWS = 1
    
    S = size(A,1);  % number of states
    T = size(X,1);  % timesteps
    alpha = zeros(T,S);
    alpha_hat = zeros(T,S);
    c = zeros(T,1);
    
%     assert(sum(sum(A,1),2) == S);
%     assert(sum(sum(B,1),2) == S);
%     assert(sum(pinit,2) == 1);
    
    alpha(1,:) = bsxfun(@times,pinit,B(X(1,1),:));
    c(1,1) = 1/sum(alpha(1,:),2);
%     if (c(1,1) == inf)
%         c(1,1) = 0;
%     end
    alpha_hat(1,:) = alpha(1,:)*c(1,1);
    
    for t = 2:T
        for j = 1:S
            alpha(t,j) = nansum(bsxfun(@times,alpha_hat(t-1,:),A(:,j)'),2)*B(X(t,1),j);
        end
        c(t,1) = 1/sum(alpha(t,:),2);
%         if (c(t,1) == inf)
%             c(t,1) = 0;
%         end
        alpha_hat(t,:) = alpha(t,:)*c(t,1);
    end
    
    term_prob = -sum(log(c),1);

end
