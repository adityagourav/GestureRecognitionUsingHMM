% for gesture = 1:6
%     temp = quantizedObs(gesture).AllObs{1,1};
%      quantizedObs(gesture).X_gesture2{1,1} = mypca(temp,2);
%       [quantizedObs(gesture).X_gesture_quant2{1,1},quantizedObs(gesture).centroids2{1,1}]...
%             = kmeans(quantizedObs(gesture).X_gesture2{1,1},20,'MaxIter',500);
%      quantizedObs(gesture).X_gesture3{1,1} = mypca(temp,3);
%         [quantizedObs(gesture).X_gesture_quant3{1,1},quantizedObs(gesture).centroids3{1,1}]...
%             = kmeans(quantizedObs(gesture).X_gesture3{1,1},20,'MaxIter',500);
% %     for i = 1:5
% %         quantizedObs(gesture).X_gesture2{i,1} = mypca(temp,2);
% %         quantizedObs(gesture).X_gesture3{i,1} = mypca(temp,3);
% %         [quantizedObs(gesture).X_gesture_quant2{i,1},quantizedObs(gesture).centroids2{i,1}]...
% %             = kmeans(quantizedObs(gesture).X_gesture2{i,1},20,'MaxIter',500);
% %         [quantizedObs(gesture).X_gesture_quant3{i,1},quantizedObs(gesture).centroids3{i,1}]...
% %             = kmeans(quantizedObs(gesture).X_gesture3{i,1},20,'MaxIter',500);
% %     end
% end

%%
% for gesture = 1:6
%     temp = [];
%     for i = 1:5
%         temp = [ temp ; quantizedObs(gesture).X_gesture{i,1}];
%     end
%     quantizedObs(gesture).AllObs{1,1} = temp;
% end

%%
for gesture = 1:6
    temp2 = quantizedObs(gesture).X_gesture2{1,1};
    temp3 = quantizedObs(gesture).X_gesture3{1,1};
    temp2quant = quantizedObs(gesture).X_gesture_quant2{1,1};
    temp3quant = quantizedObs(gesture).X_gesture_quant3{1,1};
    for i = 1:5
        l = size(quantizedObs(gesture).X_gesture{i,1},1);
        quantizedObs(gesture).X_gesture2{i,1} = temp2(1:l,:);
        quantizedObs(gesture).X_gesture3{i,1} = temp3(1:l,:);
        quantizedObs(gesture).X_gesture_quant2{i,1} = temp2quant(1:l,:);
        quantizedObs(gesture).X_gesture_quant3{i,1} = temp3quant(1:l,:);
        temp2(1:l,:) = [];
        temp3(1:l,:) = [];
        temp2quant(1:l,:) = [];
        temp3quant(1:l,:) = [];
    end
end

%%
for gesture = 1:6
    quantizedObs(gesture).centroids3 = quantizedObs(gesture).centroids3{1,1};
    quantizedObs(gesture).centroids2 = quantizedObs(gesture).centroids2{1,1};
end
    
    



        