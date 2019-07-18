clear all
close all

fil='*.mat'; 
fs=500; 
n_bands=5; 
dt=fs*8;
n_epochs=6;
tstart=6*fs+1;  % I primi 6s e gli ultimi 6s non considerati

inDir='D:\Ricerca\Ricerca3_Comparison\Sources_mat\';
outDir_o='D:\Ricerca\Ricerca3_Comparison\FOOOF\offset_Sources\';
outDir_e='D:\Ricerca\Ricerca3_Comparison\FOOOF\exp_Sources\';
cases=dir(fullfile(inDir,fil));

% initial setting
settings = struct();
load(strcat(inDir,cases(1).name));
if exist('EEG','var')~=1
    EEG=EEGs;
end
EEG=EEG(:,tstart:end);
data=squeeze(EEG(1,1:dt));           
[pxx,w]=pwelch(data,[],0,[],fs);
sup=[find(w>1,1),find(w>1,1)-1];
[x,y]=min([w(find(w>1,1))-1,1-w(find(w>1,1)-1)]);
inferior=sup(y);
sup=[find(w>40,1),find(w>40,1)-1];
[x,y]=min([w(find(w>40,1))-1,1-w(find(w>40,1)-1)]);
superior=sup(y);
%spect = superior-inferior;
f_range=[inferior superior];
s_rate=fs;



   
for i=1:length(cases)
    load(strcat(inDir,cases(i).name));
    if exist('EEG','var')~=1
        EEG=EEGs;
    end
    EEG=EEG(:,tstart:end);
    offset = zeros(n_epochs, size(EEG,1));   %epochs * locations
    exp = offset;
    for k = 1:n_epochs
        for j=1:size(EEG,1)
            data=squeeze(EEG(j,dt*(k-1)+1:k*dt));           
            [pxx,w]=pwelch(data,[],0,[],fs);

            psds=pxx;
            freqs=w';
            fooof_results = fooof(freqs, psds, f_range, settings, 1);
            offset(k,j) = fooof_results.background_params(1);
            exp(k,j) = fooof_results.background_params(2);
                
        end
    end
    clear EEG
    filename_o=strcat(outDir_o,strtok(cases(i).name,'.'),'_OFFSET.mat');    
    save(filename_o,'offset'); 
    filename_e=strcat(outDir_e,strtok(cases(i).name,'.'),'_EXP.mat');  
    save(filename_e,'exp');
    i
    k 
    j      
end
