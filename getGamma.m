function [gamma] = getGamma(alpha,beta)

% INPUT alpha :: TxS, beta :: TxS
% OUTPUT :: TxS
% getGamma(alpha,beta)

T = size(alpha,1);
S = size(alpha,2);
gamma = zeros(T,S);
    for t = 1:T
        gamma(t,:) = bsxfun(@times,alpha(t,:),beta(t,:));
        gamma(t,:) = gamma(t,:)/sum(gamma(t,:),2);
    end
end

