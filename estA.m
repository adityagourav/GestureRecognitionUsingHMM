function [A_est] = estA(zeta)
    
    % INPUT ZETA :: SxSxT
    % OUTPUT A_EST :: SxS
    
    A_est = zeros(size(zeta,1));
    temp = sum(zeta,3);
    zeta(:,:,end) = [];
    
    for i = 1:size(zeta,1)
        A_est(i,:) = temp(i,:)/sum(temp(i,:),2);
    end
    
%     assert(sum(sum(A_est,1),2) == size(zeta,1));
end