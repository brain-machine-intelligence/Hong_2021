% perfom SVM and return AUCs


function [aucs, xs, ys, tf] = svmAUC (indata, outdata, crossN)

t = templateSVM('BoxConstraint', 1, 'KernelFunction', 'gaussian', 'KernelScale', 3.3, 'Standardize',1); % 2.8 in the app
CVMdl = fitcecoc(indata, outdata, 'Learners', t, 'Kfold', crossN); % 'FitPosterior', 1, needed for posterior compute in kfoldPredict 

n = length(CVMdl.ClassNames);
n = n*(n-1)/2;

aucs=[]; xs={}; ys={};  tf={};
for i=1:crossN
    partlist = find(CVMdl.ModelParameters.Generator.UseObsForIter(:,i)==0); 
    s =0;
    for j=1:n
        x = find(CVMdl.Trained{i,1}.CodingMatrix(:,j)==1);
        x = CVMdl.ClassNames(x);
        y = find(CVMdl.Trained{i,1}.CodingMatrix(:,j)== -1);
        y = CVMdl.ClassNames(y);
        z = find(CVMdl.Y==x | CVMdl.Y==y); % <-to consider x and y classes only,
        z = intersect(partlist, z);
        [label, score] = predict(CVMdl.Trained{i,1}, CVMdl.X(z,:));
        [xj,yj,tj,aucj] = perfcurve(CVMdl.Y(z),score(:,2),1);

        s = s+aucj;
        xs{(i-1)*n+j,1} = xj; 
        ys{(i-1)*n+j,1} = yj; 
        
        trueY = CVMdl.Y(z,:);
        tnj = 0; tpj = 0; fnj = 0; fpj = 0;
        for k=1:length(label)
            if label(k)==0
                if trueY(k)== 0
                    tnj = tnj + 1;
                elseif trueY(k)==1
                    fpj = fpj + 1;
                end
            elseif label(k)==1
                if trueY(k)== 0
                    fnj = fnj + 1;
                elseif trueY(k)==1
                    tpj = tpj + 1;
                end
            end
        end
        
        tnjr = tnj/length(trueY); 
        tpjr = tpj/length(trueY); 
        fnjr = fnj/length(trueY); 
        fpjr = fpj/length(trueY);  
        
        tf.tnj{i,j} = [tnj tnjr];
        tf.tpj{i,j} = [tpj tpjr];
        tf.fnj{i,j} = [fnj fnjr];
        tf.fpj{i,j} = [fpj fpjr];
        
        tf.accuracy{i,j} = (tnj+tpj) / (tnj+tpj+fnj+fpj);         
        tf.sensi{i,j} = tpj / (fnj+tpj); 
        tf.speci{i,j} = tnj /(tnj+fpj);              
    end
    
    
    
    s = s/n;
    aucs = [aucs; s];    
end 
% from Hand & Till 2001 eq7. often referred. also check "an introduction to ROC Analysis 2006 Fawcett"
