function [G,Fs,aa] = RMKMC(Xs,k,gamma,n_iter)
%RMKMC 此处显示有关此函数的摘要
%   Parameters
%     ----------
%     Xs: a list of matrices. For each of them, the dimention is
%     (n_samples, n_features), so every row correpsonds to a data point. (cell:dv * n * V)
%     k: the expected number of clusters.
%     gamma: the parameter controling the weights. It needs to be strictly larger than 1.
%     n_iter: maximum number of iterations, default is 300.
% 
%     Returns
%     -------
%     G: common indicator matrix of dimension (n_samples, k).
%     Fs: a list of cluster centroids matrices, each of dimention (k, n_features).
%     aa: 1darray of weights for the views.

    num_v = length(Xs); % view
    num_n = length(Xs{1});   % sample
    
    if num_v == 0
        error('Error: No data.');
    end
    if k <= 1
        error('Error: cluster less than 1.');
    end
    if gamma == 1
        error('Error: gamma can not be 1.');
    end
    
    %% initialization
    for v = 1:num_v
        Ds{v} = eye(num_n);
        tildeDs{v} = zeros(num_n, num_n);
    end
    G = zeros(num_n, k);
    aa = repmat(1/num_v, 1, num_v);
    rng(1,'twister');
    hot = ceil(rand(1, num_n) * k);
    G = onehot(hot, k);

    %% iterations
    t = 0;
    while t < n_iter
  
        for v =1:num_v
            %% Calculate tildeD for each view
            tildeDs{v} = (aa(v) ^ gamma) * Ds{v};
            
            %% Update the centroids matrix F for each view
            temp = G' * tildeDs{v} * G;
            Fs{v} = Xs{v} * tildeDs{v} * G / temp;
        end
        
        %% Update G by finding the best label for each data point
        label = [];
        for n = 1:num_n
            cur_min = intmax;
            cur_idx = 1;
            for kk = 1:k
                cur_sum = 0;
                for v = 1:num_v
                    cur_diff = Xs{v}(:,n) - Fs{v}(:,kk);
                    twoNorm = norm(cur_diff, 2);
                    cur_sum = cur_sum + tildeDs{v}(n,n) * twoNorm ^ 2;
                end
                if cur_sum <= cur_min
                    cur_min = cur_sum;
                    cur_idx = kk;
                end
            end
            label = [label cur_idx];
        end
        G = onehot(label, k);
        
        %% Update D for each view
        for v = 1:num_v
            for n = 1:num_n
                cur_diff1 = Xs{v}' - G * Fs{v}';
                Ds{v}(n, n) = 0.5 / norm(cur_diff1(n,:), 2);
            end
        end
        
        %% Update weights aa
        for v = 1:num_v
            numerator(v) = gamma * norm21(Xs{v}' - G * Fs{v}') ^ (1/(1-gamma));
        end
        denominator = sum(numerator);
        for v = 1:num_v
            aa(v) = numerator(v) / denominator;
        end
        
        t = t + 1;
    end
    
end


function res = norm21(X)
    res = 0;
    for row = 1:length(X(:,1))
        res = res + norm(X(row,:), 2);
    end
end

function G = onehot(label, k)
    num_n = length(label);
    G = zeros(num_n, k);
    for n = 1:num_n
        G(n, label(n)) = 1;
    end
end

