function [macrof1,microf1]=multilabel(emb,baseline,percent)
%using svm multi-label classifier
% @Lin,2017/12/4

%emb:ovbservations=rows

%training data&labels
order=randperm(length(baseline));
num=round(length(order)*percent);
train_ind=order(1:num);
train=emb(train_ind,:);
label=baseline(train_ind);

%training
mdl=fitcecoc(train,label);

%predicting data
pre_ind=setdiff(order,train_ind);
pre=emb(pre_ind,:);
label_pre=predict(mdl,pre);

%compute macro-f1%micro-f1
label_real=baseline(pre_ind);
[macrof1,microf1]=f1score(label_real,label_pre);