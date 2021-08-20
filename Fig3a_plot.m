% run Fig3b_**svm.m first
% and then run this code

load('rirrNP_matchTn.mat'); 
temp = rirrNP{5,1}; 
SampleNplot_Fig3a(temp, 1)

load('rirrME_matchTn.mat'); 
temp = rirrME{5,1}; 
SampleNplot_Fig3a(temp, 2)

load('rirrMX_matchTn.mat'); 
temp = rirrMX{5,1}; 
SampleNplot_Fig3a(temp, 3)



