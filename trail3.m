%% INIT
clc;
clear;
load quantized_observations2.mat;
% load inital_model;
S = 15;
gesture = 6;
convergence = false;
iter = 1;

N = S;
%%
% pinit{1,1} = zeros(N,1);
% pinit{1,1}(1) = 1;
% pinit{1,1} = pinit{1,1}';
A{1,1} = diag(rand(N,1)) + diag(rand(N-1,1),-1); % band diagonal
A{1,1}(1,N) = rand(1,1); % loop left-right
A{1,1} = A{1,1} ./ repmat(sum(A{1,1}), N,1); % normalize
A{1,1} = A{1,1}';

%%
% A{1,1} = rand(S);
% A{1,1} = bsxfun(@rdivide,A{1,1},sum(A{1,1},2));
% A{1,1} = eye(S);
% A{1,1}(1,S) = 1;
B{1,1} = rand(20,S);
B{1,1} = bsxfun(@rdivide,B{1,1},sum(B{1,1},1));
pinit{1,1} = (1/S)*ones(1,S);
f = zeros(39,1);
cond(1,1) = 0;

%%
while (iter<40 && ~convergence)
    fprintf('ITERATION :: %d\n',iter);
    
    % E STEP
    for i = 1:5
        X = quantizedObs(gesture).X_gesture_quant{i,1};
        T = size(X,1);
        % E STEP :: GET alpha,beta
        [alpha_hat{iter,i}, term_prob(iter,i), c{iter,i}] = ...
            forward(A{iter,1}, B{iter,1}, pinit{iter,1}, X);
        
        [beta_hat{iter,i}] = backward(A{iter,1}, B{iter,1}, c{iter,i},X);
    end
    
    % M STEP
    
    % A
    MAden = zeros(S,5);
    MAnum = zeros(S,S,5);
    

    for l = 1:5
        X = quantizedObs(gesture).X_gesture_quant{l,1};
        T = size(quantizedObs(gesture).X_gesture_quant{l,1},1);
        for i = 1:S
            MAden(i,l) = sum(bsxfun(@rdivide,bsxfun(@times,alpha_hat{iter,l}(1:T-1,i),beta_hat{iter,l}(1:T-1,i)),c{iter,l}(1:T-1,1)),1);
            for j = 1:S
                k = bsxfun(@times,alpha_hat{iter,l}(1:T-1,i),B{iter,1}(X(2:T,1),j));
                k = bsxfun(@times,k,beta_hat{iter,l}(2:T,j))*A{iter,1}(i,j);
                MAnum(i,j,l) = sum(k,1);
            end
        end
    end
    
    MAnum = sum(MAnum,3);
    MAden = sum(MAden,2);
    A_est{iter,1} = bsxfun(@rdivide,MAnum,MAden);
    
    % B
    MBnum = zeros(20,S,5);
    MBden = zeros(S,5);
    for l = 1:5
        X = quantizedObs(gesture).X_gesture_quant{l,1};
        T = size(quantizedObs(gesture).X_gesture_quant{l,1},1);
        for j = 1:S
            MBden(j,l) = sum(bsxfun(@rdivide,bsxfun(@times,alpha_hat{iter,l}(1:T,j),beta_hat{iter,l}(1:T,j)),c{iter,l}(1:T,1)),1);
            for k = 1:20
                ind = find(X==k);
                MBnum(k,j,l) = sum(bsxfun(@rdivide,bsxfun(@times,alpha_hat{iter,l}(ind,j),beta_hat{iter,l}(ind,j)),c{iter,l}(ind,1)),1); 
            end
        end
    end
    MBnum = sum(MBnum,3);
    MBden = sum(MBden,2);
    B_est{iter,1} = bsxfun(@rdivide,MBnum,MBden');

    % pi
    k = zeros(5,S);
    for l = 1:5
        k(l,:) = bsxfun(@times,alpha_hat{iter,l}(1,:),beta_hat{iter,l}(1,:));
    end
    pi_est{iter,1} = sum(k,1);
    pi_est{iter,1} = pi_est{iter,1}/sum(pi_est{iter,1});

    A{iter+1,1} = A_est{iter,1};
    B{iter+1,1} = B_est{iter,1};
    pinit{iter+1,1} = pi_est{iter,1};
    
    ll(iter,1) = sum(term_prob(iter,:));
    
    if (iter > 3)
       cond(iter,1) = abs(ll(iter,1)-ll(iter-1,1))/(1+abs(ll(iter-1,1)));
       fprintf('COND :: %d\n',cond(iter,1));
       if ((cond(iter-2,1)<5e-4 && cond(iter,1)<cond(iter-1,1) && cond(iter-1,1)<cond(iter-2,1)) ...
               || isnan(cond(iter,1)))
          convergence = true;
      end
    end
    
    iter = iter + 1;
end

subplot(2,1,1); plot(ll); title('Log-Likelihood');
subplot(2,1,2); plot(cond); title('Convergence Condition');
%%
g6A = A_est{iter-1,1};
g6B = B_est{iter-1,1};
g6pi = pi_est{iter-1,1};