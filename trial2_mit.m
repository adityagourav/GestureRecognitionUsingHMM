%% INIT
clc;
clear;
load quantized_observations2.mat
% load inital_model;
S = 15;
gesture = 3;
convergence = false;
iter = 1;

A{1,1} = rand(S);
A{1,1} = bsxfun(@rdivide,A{1,1},sum(A{1,1},2));
B{1,1} = rand(20,S);
B{1,1} = bsxfun(@rdivide,B{1,1},sum(B{1,1},1));
pinit{1,1} = (1/S)*ones(1,S);
f = zeros(49,1);
cond(1,1) = 0;

%%
while (iter<50 && ~convergence)
    fprintf('ITERATION :: %d\n',iter);
    
    for i = 1:5
        X = quantizedObs(gesture).X_gesture_quant{i,1};
        T = size(X,1);
        % E STEP :: GET alpha,beta
        [alpha_hat{iter,i}, term_prob(iter,i), c{iter,i}] = ...
            forward(A{iter,i}, B{iter,i}, pinit{iter,i}, X);
        
        [beta_hat{iter,i}] = backward(A{iter,i}, B{iter,i}, c{iter,i},X);
        
        % calculate gamma
        gamma{iter,i} = getGamma(alpha_hat{iter,i}, beta_hat{iter,i});
        % M STEP
        
        pi_est{iter,i} = gamma{iter,i}(1,:);
        A_est{iter,i} = estA_mit(alpha_hat{iter,i},beta_hat{iter,i},...
                        A{iter,i},B{iter,i},c{iter,i},X);
                    
        B_est{iter,i} = estB_mit(gamma{iter,i},X,c{iter,i});
   
        if (i ~= 5)
            A{iter,i+1} = A_est{iter,i};
            B{iter,i+1} = B_est{iter,i};
            pinit{iter,i+1} = pi_est{iter,i};
        end
        
    end
    
    % form the cumulative alpha,beta,pi of the iteration
    % A,B,pi from the M step of the 5th sequence becomes the input 
    % to the first sequence of the next iteration
    
    A_main{iter,1} = zeros(S,S);
    B_main{iter,1} = zeros(20,S);
    pi_main{iter,1} = zeros(1,S);
    
    for j = 1:5
        A_main{iter,1} = A_main{iter,1} + A_est{iter,j};
        B_main{iter,1} = B_main{iter,1} + B_est{iter,j};
        pi_main{iter,1} = pi_main{iter,1} + pi_est{iter,j};
    end
    
    A_main{iter,1} = A_main{iter,1}/5;
    B_main{iter,1} = B_main{iter,1}/5;
    pi_main{iter,1} = pi_main{iter,1}/5;

%     A_main{iter,1} = A_est{iter,1};
%     B_main{iter,1} = B_est{iter,1};
%     pi_main{iter,1} = pi_est{iter,1};

    A{iter+1,1} = A_main{iter,1};
    B{iter+1,1} = B_main{iter,1};
    pinit{iter+1,1} = pi_main{iter,1};
    
    ll(iter,1) = sum(term_prob(iter,:));
    
    if (iter > 1)
       cond(iter,1) = abs(ll(iter,1)-ll(iter-1,1))/(1+abs(ll(iter-1,1)));
       fprintf('COND :: %d\n',cond(iter,1));
       if (cond(iter,1)<5e-4 || isnan(cond(iter,1)))
          convergence = true;
      end
    end
    
%     if (iter>1)
%         f(iter-1,1) = norm(term_prob(iter,:)-term_prob(iter-1,:),'fro');
%         if (f(iter-1,1)<3)
%             convergence = true;
%         end
%     fprintf('NORM :: %d\n',f(iter-1,1));
%     end
    
    iter = iter + 1;
end

subplot(2,1,1); plot(ll); title('Log-Likelihood');
subplot(2,1,2); plot(cond); title('Convergence Condition');

%%
g4A = A_main{iter-1,1};
g4B = B_main{iter-1,1};
g4pi = pi_main{iter-1,1};