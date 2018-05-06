function [x,f] = gauss_smooth(E)
% gauss smooth of eigvalue
% Input :
%      E - eigvalue
% Output :
%      x,f - f is distribution function
% Checking ...
% 
[~,n] = min(E);
E(n) = 0;
if max(E) > 2.000001
    error(' Wrong Eigvalue');
end
% smoothing ...
n = length(E);
sigma = 0.015;
step = 0.001;
x = 0:step:2;
f = zeros(1,length(x));
for i = 1 : length(x)
    f(i) = sum((exp(-((x(i)-E).^2)./(2*sigma^2)))./(sqrt(2*pi*(sigma^2))));
end
f = 1000*f./(sum(f));
plot(x,f,'r.-');
% set(gca,'FontWeight','bold');
% set(gca,'Fontangle','italic');
set(gcf,'color','w');
xlabel('Eig Value','fontsize',12);
ylabel('frequency','fontsize',12);
axis([0 2 0 6]);
end