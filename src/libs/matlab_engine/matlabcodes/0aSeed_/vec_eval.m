
function [rate1,rate0]=vec_eval(vec_ci,grid_ci,pair1_poi,pair0_poi)
sim_ci=squareform(pdist(vec_ci,'cosine'));
[pair1_ci,pair0_ci]=findpair(sim_ci,grid_ci);

rate1=length(intersect(pair1_ci,pair1_poi,'rows'))/length(pair1_ci);
rate0=length(intersect(pair0_ci,pair0_poi,'rows'))/length(pair0_ci);
end