% generate data for svm analysis 
% return the average between colum a and colum b in inmtx
% if c and d are nonzero, it also returns the average between colum c and colum d in inmtx

function [mtx] = svmdata (inmtx, a, b, c, d)
mtx = [];

if c*d ~=0
    for i=1:size(inmtx,1)
        mtx(i,:) = [mean(inmtx(i,a:b)) mean(inmtx(i,c:d))];
    end
else
    for i=1:size(inmtx,1)
        mtx(i,:) = [mean(inmtx(i,a:b))];
    end
end

    
    