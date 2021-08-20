% used in SampleNplot.m 
% This code was obtained from the following link
% https://www.mathworks.com/matlabcentral/answers/467330-how-to-plot-the-roc-curve-for-the-average-of-10-fold-cross-validation-using-matlab#answer_402596

function x= adjust_unique_points(Xroc)
    x= zeros(1, length(Xroc));
    aux= 0.00001;
    for i=1: length(Xroc)
        if i~=1
            x(i)= Xroc(i)+aux;
            aux= aux+0.00001;
        end
        
    end
end