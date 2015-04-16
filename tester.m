%% TESTING
% clc;
clear;
load dataNmodel.mat;
directory{1,1} = 'test/multiple/';
% directory{1,1} = 'train/inf/';
directory{2,1} = 'test/single/';
for dirLen = 1:2
    fprintf('Directory :: %s\n\n',directory{dirLen,1});
    dirstruct = dir(directory{dirLen,1});
    for i = 3:length(dirstruct)
        fpath = dirstruct(i).name;
        test = dataClean(fpath);
        p = zeros(6,1);
        for gesture = 1:6
            m = dataNmodel(gesture).model;
            d = pdist2(test(:,2:7),dataNmodel(gesture).centroids);
            [~, id] = min(d,[],2);
            [~,p(gesture,1),~] = forward(m.A,m.B,m.pi,id);
            %             fprintf('%s :: %d\n',dataNmodel(gesture).Name,p(gesture,1));
        end
        [~,ind] = max(p,[],1);
        fprintf('%s Most Likely Sequence :: %s\n',fpath,dataNmodel(ind).Name);
    end
    fprintf('\n\n');
end