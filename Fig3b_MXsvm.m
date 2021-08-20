clear all;  

% 1 sec = 30 units
% MX onset occurred at 180. 
% c1: time windows 'until' MX onset with different length
% c2: time windows 'after' MX onset with different length
c1 = [121 180; 136 180; 151 180]; 
c2 = [181 240; 181 225; 181 210]; 

load('ri.mat'); load('rr.mat')
% crossN: # of cross-validation 
% sampleN: # of subsampling 
crossN = 4; repeatN = 1; sampleN = 400; 


%% RR reward or not
i=0; rrRw={};
for ci=1:size(c1,1)
    for cj=1:size(c2,1)
        t = [c1(ci,1) c1(ci,2) c2(cj,1) c2(cj,2)];
        i = i+1;
        aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={}; k=0; 
        
        for s=1:sampleN
            % RR NoRw 120, Rw 170; balancing data
            r = randperm(170,120);
            r = rr0rx(r,:);            
            [r] = svmdata(r, t(1), t(2), t(3), t(4));
            n = svmdata (rr0nx, t(1), t(2), t(3), t(4));
            x = [n; r];
            y = [zeros(length(r),1); ones(length(n),1)];
            [auc, acc, spec, sens, xx, yy] = SampleNsvm (x, y, crossN, repeatN);
            
            aucs=[aucs; auc];
            accs=[accs; acc];
            specs=[specs; spec];
            senss=[senss; sens];
            
            for j=1:size(xx,1)
                k=k+1;
                xxs{k,1} = xx{j,1};
                yys{k,1} = yy{j,1};
            end
        end
        
        rrRw{i,1}.aucs = aucs;
        rrRw{i,1}.accs = accs;
        rrRw{i,1}.specs = specs;
        rrRw{i,1}.senss = senss;
        rrRw{i,1}.xxs = xxs;
        rrRw{i,1}.yys = yys;
        rrRw{i,1}.input = t;
    end
end
rrRwMX = rrRw;
save rrRwMX rrRwMX


%% RI rewarded or not
i=0; rrRw={};
for ci=1:size(c1,1)    
    for cj=1:size(c2,1)
        t = [c1(ci,1) c1(ci,2) c2(cj,1) c2(cj,2)];
        i = i+1;
        aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={}; k=0;
        
        for s=1:sampleN
            % RI NoRw 549, Rw 58; balancing data 
            n = randperm(549,58);
            n = ri0nx(n,:);
            n = svmdata (n, t(1), t(2), t(3), t(4));
            r = svmdata (ri0rx, t(1), t(2), t(3), t(4));
            x = [n; r];
            y = [zeros(length(n),1); ones(length(r),1)];
            [auc, acc, spec, sens, xx, yy] = SampleNsvm (x, y, crossN, repeatN);
            
            aucs=[aucs; auc];
            accs=[accs; acc];
            specs=[specs; spec];
            senss=[senss; sens];
            
            for j=1:size(xx,1)
                k=k+1;
                xxs{k,1} = xx{j,1};
                yys{k,1} = yy{j,1};
            end
        end
        
        rrRw{i,1}.aucs = aucs;
        rrRw{i,1}.accs = accs;
        rrRw{i,1}.specs = specs;
        rrRw{i,1}.senss = senss;
        rrRw{i,1}.xxs = xxs;
        rrRw{i,1}.yys = yys;
        rrRw{i,1}.input = t;        
    end
end
riRwMX = rrRw;
save riRwMX riRwMX


%% RI or RR 
i=0; rrRw={};
for ci=1:size(c1,1)
    ci
    for cj=1:size(c2,1)
        t = [c1(ci,1) c1(ci,2) c2(cj,1) c2(cj,2)];
        i = i+1;
        aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={}; k=0;
        
        for s=1:sampleN
            rrn = svmdata (rr0nx, t(1), t(2), t(3), t(4));            
            rrr = svmdata (rr0rx, t(1), t(2), t(3), t(4));
          
            rir = svmdata (ri0rx, t(1), t(2), t(3), t(4));

            % RR data size = 120 NoRw + 170 Rw = 290
            % RI data size = 549 NoRw + 58 Rw => larger than 290
            % balancing data (including RI Rw 58)
            % 290-58 = 232
            rin = randperm(549,232);
            rin = ri0nx(rin,:);
            rin = svmdata (rin, t(1), t(2), t(3), t(4));
            
            % svm            
            indata = [rrn; rrr; rin; rir];
            x = ones(290,1);
            x2 = zeros(290,1);
            outdata = [x; x2];
            [auc, acc, spec, sens, xx, yy] = SampleNsvm (indata, outdata, crossN, repeatN);            
            
            aucs=[aucs; auc];
            accs=[accs; acc];
            specs=[specs; spec];
            senss=[senss; sens];
            
            for j=1:size(xx,1)
                k=k+1;
                xxs{k,1} = xx{j,1};
                yys{k,1} = yy{j,1};
            end
        end
        
        rrRw{i,1}.aucs = aucs;
        rrRw{i,1}.accs = accs;
        rrRw{i,1}.specs = specs;
        rrRw{i,1}.senss = senss;
        rrRw{i,1}.xxs = xxs;
        rrRw{i,1}.yys = yys;
        rrRw{i,1}.input = t;        
    end
end
rirrMX = rrRw;
save rirrMX_matchTn rirrMX


%% RR or RI: stratify sampling by the label

i=0; rrRw={};
for ci=1:size(c1,1)
    ci
    for cj=1:size(c2,1)
        t = [c1(ci,1) c1(ci,2) c2(cj,1) c2(cj,2)];
        i = i+1;
        aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={}; k=0;
        
        for s=1:sampleN
            % RR data size = 120 NoRw + 170 Rw = 290            
            % RI data size = 549 NoRw + 58 Rw => larger than 290
            % min data size is 58 (RI Rw); balancing data 
            rrn = randperm(120,58);
            rrn = rr0nx(rrn,:);
            rrn = svmdata (rrn, t(1), t(2), t(3), t(4));
            
            rrr = randperm(170,58);
            rrr = rr0rx(rrr,:);
            rrr = svmdata (rrr, t(1), t(2), t(3), t(4));

            rir = svmdata (ri0rx, t(1), t(2), t(3), t(4));
            
            rin = randperm(549,58);
            rin = ri0nx(rin,:);
            rin = svmdata (rin, t(1), t(2), t(3), t(4));
            
            % svm            
            indata = [rrn; rrr; rin; rir];
            x = ones(116,1);
            x2 = zeros(116,1);
            outdata = [x; x2];
            [auc, acc, spec, sens, xx, yy] = SampleNsvm (indata, outdata, crossN, repeatN);
            
            aucs=[aucs; auc];
            accs=[accs; acc];
            specs=[specs; spec];
            senss=[senss; sens];
            
            for j=1:size(xx,1)
                k=k+1;
                xxs{k,1} = xx{j,1};
                yys{k,1} = yy{j,1};
            end
        end
        
        rrRw{i,1}.aucs = aucs;
        rrRw{i,1}.accs = accs;
        rrRw{i,1}.specs = specs;
        rrRw{i,1}.senss = senss;
        rrRw{i,1}.xxs = xxs;
        rrRw{i,1}.yys = yys;
        rrRw{i,1}.input = t;
    end
end
rirrMX_matchRwTn = rrRw;
save rirrMX_matchRwTn rirrMX_matchRwTn

