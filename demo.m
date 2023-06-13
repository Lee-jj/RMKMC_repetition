clear all;
clc;

% addpath([pwd, '/funs']);
% addpath([pwd, '/datasets']);

%% load Dataset
datasetName = 'MSRC';
load([datasetName, '.mat']);

num_v = length(X);

%% Data preprocessing
% Select a data preprocessing method, or no data preprocessing
%% Data pre-processing A
% disp('------Data preprocessing------');
% tic
% for v=1:num_V
%     a = max(X{v}(:));
%     X{v} = double(X{v}./a);
% end
% toc

%% Data pre-processing B
% disp('------Data preprocessing------');
% tic
% for v=1:num_V
%     XX = X{v};
% for n=1:size(XX,1)
%     XX(n,:) = XX(n,:)./norm(XX(n,:),'fro');
% end
% X{v} = double(XX);
% end
% toc

%% Data pre-processing C
% for v=1:num_V
%     X{v} = ( X{v} - mean(X{v},2) )./ std( X{v},0,2);
% end

%% file
file_dir = [datasetName, '.txt'];
fid = fopen(file_dir,'a');

%% parameter initialization
for v = 1:num_v
    Xs{v} = X{v}';
end
n_iter = 100;
k = length(unique(Y));
for gamma = 0.1:2:0.2
    %% clustering
    [G, ~, ~] = RMKMC(Xs,k,gamma,n_iter);
    [~, Y_pre] = max(G, [], 2);
    my_result = ClusteringMeasure1(Y, Y_pre);
    fprintf(fid, 'gamma:%f ', gamma);
    fprintf(fid, '%g %g %g %g %g %g %g\n',my_result');
end
fclose(fid);
