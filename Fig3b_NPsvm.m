clear all;  

% 1 sec = 30 units
% ME onset occurred at 180. 
% c1: time windows 'until' ME onset with different length
% c2: time windows 'after' ME onset with different length
c1 = [121 180; 136 180; 151 180]; 
c2 = [181 240; 181 225; 181 210]; 
c = [c1 c2]; 

load('riNPrnr.mat'); load('rrNPrnr.mat')
% crossN: # of cross-validation 
% sampleN: # of subsampling 
crossN = 4; repeatN = 1; sampleN = 400; 


%% RR reward or not

rrRw={};
for i=1:size(c,1)
    t = c(i,:); 
    aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={}; k=0; 
    
    for s=1:sampleN
        % RR NP NoRw 174, Rw 3035; balancing data 
        r = randperm(3035,174);
        r = rr_0npn(r,:);
        [r] = svmdata(r, t(1), t(2), t(3), t(4));
        n = svmdata (rr_0npr, t(1), t(2), t(3), t(4));
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
rrRwNP = rrRw;
save rrRwNP rrRwNP


%% RI rewarded or not
aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={};
rrRw={};
for i=1:size(c,1)
    t = c(i,:);
    aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={}; k=0; 
    for s=1:sampleN
        % RI NP NoRw 1045, Rw 64; balancing data 
        n = randperm(1045,64);
        n = ri_0npn(n,:);
        n = svmdata (n, t(1), t(2), t(3), t(4));
        r = svmdata (ri_0npr, t(1), t(2), t(3), t(4));
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
riRwNP = rrRw;
save riRwNP riRwNP


%% RI or RR

rrRw={};
for i=1:size(c,1)
    t = c(i,:);
    aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={}; k=0; 
    for s=1:sampleN
        rin = svmdata (ri_znpn, t(1), t(2), t(3), t(4));
        rir = svmdata (ri_znpr, t(1), t(2), t(3), t(4));
        
        rrr = svmdata (rr_znpr, t(1), t(2), t(3), t(4));
        
        % RI NP NoRw 1045, Rw 64 => total 1109
        % RR NP NoRw 174, Rw 3035 => larger than 1109
        % balancing data including (RR NP NoRw 174) 
        % 1109-174 = 935
        rrn = randperm(3035,935);
        rrn = rr_znpn(rrn,:);
        rrn = svmdata (rrn, t(1), t(2), t(3), t(4));
        
        % svm
        % indata = [frn; frr; rrn; rrr; rin; rir];
        indata = [rrn; rrr; rin; rir];
        x = ones(1109,1);
        x2 = zeros(1109,1);
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
rirrNP_matchTn = rrRw;
save rirrNP_matchTn rirrNP_matchTn


%% ri or rr 
rrRw={};
for i=1:size(c,1)
    t = c(i,:);
    aucs=[];accs=[];specs=[]; senss=[]; xxs={}; yys={}; k=0; 
    for s=1:sampleN
        % RI NP NoRw 1045, Rw 64 => total 1109
        % RR NP NoRw 174, Rw 3035 => larger than 1109
        % min data size is 64 (RI Rw); balancing data
        rrn = randperm(3035,64);
        rrn = rr_0npn(rrn,:);
        rrn = svmdata (rrn, t(1), t(2), t(3), t(4));
        
        rrr = randperm(174,64);
        rrr = rr_0npr(rrr,:);
        rrr = svmdata (rrr, t(1), t(2), t(3), t(4));
        
        rir = svmdata (ri_0npr, t(1), t(2), t(3), t(4));
        
        rin = randperm(1045,64);
        rin = ri_0npn(rin,:);
        rin = svmdata (rin, t(1), t(2), t(3), t(4));
        
        % svm
        indata = [rrn; rrr; rin; rir];
        r = [zeros(64,1); ones(64,1); zeros(64,1); ones(64,1)];
        indata = [indata r];
        
        x = ones(128,1);
        x2 = zeros(128,1);
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
rirrNP = rrRw;
save rirrNP_matchRwTn rirrNP

