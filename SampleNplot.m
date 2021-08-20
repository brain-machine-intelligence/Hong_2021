

function [] = SampleNplot_Fig3a(temp, figN)

timez = temp.input; 
auc = temp.aucs; 
acc = temp.accs; 
spec = temp.specs; 
sens = temp.senss; 
xs = temp.xxs; 
ys = temp.yys; 

figure(figN); hold off; clf; 

intervals= linspace(0, 1, 1000);
mean_curve =[];

for j=1:size(xs,1)
    figure(figN);     plot(xs{j,1},ys{j,1}, '-b', 'LineWidth',0.1); hold on;
    
    x_adj= adjust_unique_points(xs{j,1}); %interp1 requires unique points
    if j==1 %if is the first fold
        mean_curve = (interp1(x_adj, ys{j,1}, intervals));
    else
        mean_curve = [mean_curve; (interp1(x_adj, ys{j,1}, intervals))];
    end
end

plot(intervals, mean(mean_curve), '-k', 'LineWidth', 3.0); hold on; 
ylabel('True positive rate'); xlabel('False positive rate');
plot(intervals, intervals, '-k', 'LineWidth', 0.1);

a1 = num2str(round(mean(auc, 'omitnan'),2));
a2 = num2str(round(mean(acc, 'omitnan'),2));
s1= num2str(round(mean(spec, 'omitnan'),2));
s2= num2str(round(mean(sens, 'omitnan'),2));

s = ['AUC: ' a1 '  Accuracy: ' a2 '  Specificity: ' s1 '  Sensitivity: ' s2];

timez = (timez-180)/30; timez = round(timez,1); 
formSpec = '%.1f'; 
s3 = ['input1: ' num2str(timezone(1), formSpec) '~'  num2str(timezone(2), formSpec) ...
    ' s;  input2: ' num2str(timezone(3), formSpec) '~'  num2str(timezone(4), formSpec) ' s'];
s = [s newline s3]; 
title(s);
