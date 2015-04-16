% addpath(genpath('train/'));
function wave = dataClean(fpath)
%% read data from text
clear X;
fid = fopen(fpath);
%fid = fopen('train/wave/wave07.txt');
% fid = fopen('train/circle/circle18.txt');
% fid = fopen('train/eight/eight08.txt');
% fid = fopen('train/inf/inf13.txt');
% fid = fopen('train/wave/wave01.txt');
X = fscanf(fid, '%d %f %f %f %f %f %f', [7, Inf])';
fclose(fid);

% %% mean center data
X(:, 2:7) = X(:, 2:7) - repmat(mean(X(:, 2:7)), size(X,1),1);
% 
% %% filter: lpf
% % butterworth equiripple lpf with fc = 200Hz | order 131
% X_lpf = X;
% load lpf_200
% X_lpf(:, 2:7) = filter(lpf_220, 1, X_lpf(:, 2:7), [], 1);

%% #2 filter: sgolay
X_sg = X;
X_sg(:, 2:7) = sgolayfilt(X(:, 2:7), 3, 31, [], 1);

% %% #2 filter: wiener
% % adaptive filter might not be a good choice since we need the periodicity
% % maintained to learn the sequential periodic states. 
% X_wiener = X;
% for i = 2:7
%     X_wiener(:, i) = wiener2(X(:, i));
% end

%% trim data

% FX = gradient(mean(X(:,2:7), 2));
dx = mean(diff(X_sg(:, 2:end),1,1), 2);
% figure(3),
% plot(dx);
start = max([find(abs(dx)>0.04, 1) - 50, 1]);
stop = min([find(abs(dx)>0.04, 1, 'last') + 50, size(X,1)]);


% wave = [wave; X_sg(start:stop,:)];
% size(wave);
wave =  X_sg(start:stop,:);
% plot
% figure(1),
% subplot(2,1,1)
% plot(1:size(X,1), X(:, 2:4));
% subplot(2,1,2), hold on,
% plot(1:size(X,1), X_sg(:, 2:4));
% plot([start, start], [min(min(X_sg(:, 2:4))), max(max(X_sg(:, 2:4)))], '-k', 'linewidth', 1.5)
% plot([stop, stop], [min(min(X_sg(:, 2:4))), max(max(X_sg(:, 2:4)))], '-k', 'linewidth', 1.5)
% hold off;

% figure(2),
% subplot(2,1,1), plot(1:size(X,1), X(:, 5:7));
% subplot(2,1,2), plot(1:size(X,1), X_sg(:, 5:7));






