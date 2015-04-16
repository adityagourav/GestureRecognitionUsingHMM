function [] = checkZero(X)

for gesture = 1:6
    for sequence = 1:5
        for i = 1:20
            if (sum(X(gesture).X_gesture_quant{sequence,1}==i) == 0)
                fprintf('GESTURE :: %d, SEQUENCE :: %d, CLUSTER :: %d\n',gesture,sequence,i);
            end
        end
    end
end
