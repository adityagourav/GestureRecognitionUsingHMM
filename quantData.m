clc;
clear;
%% Quantize the observations: kmeans

% cluster all the observations
dirstruct = dir('train/');

quantizedObs = struct('Name', {}, 'X_gesture', {}, 'X_gesture_quant', {}, 'centroids', {});
ind = 1;
for i = 1:length(dirstruct)
    if (dirstruct(i).isdir && ~strcmp(dirstruct(i).name, '.') && ~strcmp(dirstruct(i).name, '..'))
        subdirstruct = dir(strcat('train/',dirstruct(i).name,'/*.txt'));
        fprintf('Gesture: %s \n',dirstruct(i).name);
        X_gesture_cat = [];
        X_gesture = cell(length(subdirstruct),1);
        X_gesture_quant = cell(length(subdirstruct),1);
        for j = 1:length(subdirstruct)
           fpath =  strcat('train/',dirstruct(i).name,'/',subdirstruct(j).name);
           X = dataClean(fpath);
           X_gesture_cat = cat(1, X_gesture_cat, X(:, 2:7));
           X_gesture{j} = X(:, 2:7); 
        end
        tic;
        [idx, centroids] = kmeans(X_gesture_cat, 20, 'MaxIter',500); 
        toc;
        % split idx into sequences
        for j = 1:length(subdirstruct)
            X_gesture_quant{j} = idx(1:size(X_gesture{j}, 1));
            idx(1:size(X_gesture{j}, 1)) = [];
        end
        
        quantizedObs(ind).Name = dirstruct(i).name;
        quantizedObs(ind).X_gesture = X_gesture;
        quantizedObs(ind).X_gesture_quant = X_gesture_quant;
        quantizedObs(ind).centroids = centroids;   
        ind = ind+1;
    end
end

save ('quantized_observations.mat', 'quantizedObs'); 
    
    
    