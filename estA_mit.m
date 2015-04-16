function [A_est] = estA_mit(alpha_hat,beta_hat,A,B,c,X)
    
    S = size(A,1);
    T = size(alpha_hat,1);
    A_est = zeros(S);
    
    for i = 1:S
        den(i,:) = bsxfun(@rdivide,bsxfun(@times,alpha_hat(1:T-1,i),beta_hat(1:T-1,i)),c(1:T-1,1));
        den(i,:) = nansum(tempSum,1)*ones(1:T,1);
        for j = 1:S
           num = bsxfun(@times,bsxfun(@times,alpha_hat(1:T-1,i),B(X(2:T,1),j)),beta_hat(2:T,j)); 
           num = num*A(i,j);
           num = sum(num,1);
        end
    end

end