
fil='*.mat';
fs=500;  %frequenza di campionamento
n_ch=64; %numero di canali
inDir='D:\Ricerca\Ricerca3_Comparison\OneDrive_2019-05-01\Depression Rest\Matlab Files\';
addpath 'C:\Users\simon\Desktop\eeglab14_1_2b';
cases=dir(fullfile(inDir,fil));
QC=["paziente", "quality check"];
eeglab

%% Indice
% Caso dal quale iniziare (numero del caso, non id del paziente)
idx=64;
%idx=1;

%% Checking
for i=idx:length(cases)
    n=cases(i).name(1:3);
    EEG = pop_importdata('dataformat','matlab','nbchan',n_ch,'data',strcat(inDir,cases(i).name),'setname',n,'srate',fs,'pnts',0,'xmin',0);
    EEG=EEG.data;
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
    %EEG = pop_eegfiltnew(EEG, 1,40,826,0,[],1);
    EEG = eeg_checkset( EEG );
    n
    pop_eegplot( EEG, 1, 1, 1);
    x=[string(n), string(input('Quality check\n','s'))];
    QC=[QC; x];    
end

save('QC_R3.mat','QC')
