function [accuracy,macrof1]=crossvalidation(vec_ci,grps,n)
%input data:embedding vectors of checkin (vec_ci)each row is an observation
%baseline: using the clustering results of 1-fold as the
%baseline (grps)
%5-fold corss validation:n=5
indices=crossvalind('Kfold',vec_ci,n);
accuracy=zeros(n,1);
macrof1=zeors(n,1);
for k=1:n
    test_data=vec_ci((indices==k),:);
    train_data=vec_ci(~(indices==k),:);
    mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',1);
    predict_label=predict(mdl, test_data);
    test_label=grps(indices==k);
    accuracy(k)=length(find(predict_label == test_label))/length(test_label)*100;
    macrof1(k)=compf1(test_label,predict_label);
end
end
%-----------------------------subfunction---------------------------------%
function macrof1=compf1(test,predict)
label=unique(test);
num_label=length(label);
f1=zeros(num_label,1);
for i=1:num_label
    tp=sum(intersect(find(test==label(i)),find(predict==label(i))));
    f=length(predict)-sum(test==predict);
    f1(i)=tp/(2*tp+f);
end
macrof1=mean(f1);
end