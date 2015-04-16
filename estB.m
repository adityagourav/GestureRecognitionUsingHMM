function [B_est] = estB(gamma,X)
    
    % INPUT :: GAMMA, TxS
    % OUTPUT :: B_EST, TxS
    
    S = size(gamma,2);
    B_est = zeros(20,S);
    
    for s = 1:S
        tempSum = sum(gamma(:,s),1);
        for t = 1:20
            B_est(t,s) = sum(gamma(X==t,s),1)/tempSum;
        end
    end
end