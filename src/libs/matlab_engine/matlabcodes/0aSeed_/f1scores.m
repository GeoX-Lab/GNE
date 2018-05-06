function [macrof1,microf1]=f1scores(baseline,grps)
% @Lin, 2017/12/4
grps=bestMap(baseline,grps)
%grps=match(baseline,gprs) %»ÙbestMapŒﬁ–ß
conmat=confusionmat(baseline,grps);

tp=diag(conmat);
fp=sum(conmat)'-tp;
tn=sum(conmat,2)-tp;
fn=length(baseline)-tp-fp-tn;

%compute micro-F1
precision=sum(tp)/sum(tp+fp);
recall=sum(tp)/sum(tp+fn);
microf1=2*precision*recall/(precision+recall);

%compute macro-F1
precisionA=tp./(tp+fp);
recallA=tp./(tp+fn);
f1A=2*precisionA.*recallA./(precisionA+recallA);
macrof1=sum(f1A)/length(conmat);

end