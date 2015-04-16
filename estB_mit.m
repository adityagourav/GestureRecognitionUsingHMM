function [B_est] = estB_mit(gamma,X,c)

    % INPUT :: GAMMA, TxS
    % OUTPUT :: B_EST, TxS
    
    S = size(gamma,2);
    B_est = zeros(20,S);
    
    for s = 1:S
        tempSum = bsxfun(@rdivide,gamma(:,s),c);
        tempSum = nansum(tempSum,1);
        for t = 1:20
            B_est(t,s) = sum(gamma(X==t,s),1)/tempSum;
        end
    end
end