clear all


load 'D:\Ricerca\Ricerca3_Comparison\PSD\PSD_epmean\PSD_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\PSD\PSD_epmean\PSDs_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\PSD\PSD_epmean\PSD_DEP_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\PSD\PSD_epmean\PSDs_DEP_em.mat';

% Caricamento matrice SUBJ-BDI e ottenimento matrici BDI per PAT e per HC
% (un BDI>13 indica la presenza di depressione, un BDI<8 ne indica
% l'assenza)
load 'D:\Ricerca\Ricerca3_Comparison\BDI.mat';
BDIdep = BDI(BDI(:,2)>13,2); 
BDIhc = BDI(BDI(:,2)<8,2);

nhemi = 2;
nbands = size(PSD_HC,2);  % number of frequency bands
loc = size(PSD_HC,3);     % number of channels
loc_s = size(PSDs_HC,3);  % number of ROI
P = zeros(nbands,1);  % matrice di significatività per lo scalpo
Ps = zeros(nbands,1);  % matrice di significatività per le sorgenti

% conservatività (nhemi*nbands, nhemi o 1)
cons = 1%nhemi*nbands;               % conservatività per lo scalpo e per le sorgenti

ROI = {'caudalanteriorcingulate L', 'caudalanteriorcingulate R', 'caudalmiddlefrontal L', 'caudalmiddlefrontal R', 'cuneus L', 'cuneus R', 'frontalpole L', 'frontalpole R', 'fusiform L', 'fusiform R', 'inferiorparietal L', 'inferiorparietal R', 'inferiortemporal L', 'inferiortemporal R', 'insula L', 'insula R', 'isthmuscingulate L', 'isthmuscingulate R', 'lateraloccipital L', 'lateraloccipital R', 'lateralorbitofrontal L', 'lateralorbitofrontal R', 'lingual R', 'lingual L', 'medialorbitofrontal L', 'medialorbitofrontal R', 'middletemporal L', 'middletemporal R', 'parahippocampal L', 'parahippocampal R', 'parsopercularis L', 'parsopercularis R', 'parsorbitalis L', 'parsorbitalis R', 'parstriangularis L', 'parstriangularis R', 'posteriorcingulate L', 'posteriorcingulate R', 'precuneus L', 'precuneus R', 'rostralanteriorcingulate L', 'rostralanteriorcingulate R', 'rostralmiddlefrontal L', 'rostralmiddlefrontal R', 'superiorfrontal L', 'superiorfrontal R', 'superiorparietal L', 'superiorparietal R', 'superiortemporal L', 'superiortemporal R', 'supramarginal L', 'supramarginal R'};
bands = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
channels = {'FP1','FPZ','FP2','AF3','AF4','F7','F5','F3','F1','FZ','F2','F4','F6','F8','FT7','FC5','FC3','FC1','FCZ','FC2','FC4','FC6','FT8','T7','C5','C3','C1','CZ','C2','C4','C6','T8','TP7','CP5','CP3','CP1','CPZ','CP2','CP4','CP6','TP8','P7','P5','P3','P1','PZ','P2','P4','P6','P8','PO7','PO3','POZ','PO4','PO8','O1','OZ','O2'};
hemispheres={'Right', 'Left'};

RightCh=[3, 5, 11:14, 20:23, 29:32, 38:41, 47:50, 54, 55, 58];
LeftCh=[1, 4, 6:9, 15:18, 24:27, 33:36, 42:45, 51, 52, 56];

RightROI=[2:2:52];
LeftROI=[1:2:52];

PSD_asy_HC=zeros(size(PSD_HC,1),size(PSD_HC,2), 2);
PSD_asy_HC(:,:,1)=mean(PSD_HC(:,:,RightCh),3);
PSD_asy_HC(:,:,2)=mean(PSD_HC(:,:,LeftCh),3);

PSD_asy_DEP=zeros(size(PSD_DEP,1),size(PSD_DEP,2), 2);
PSD_asy_DEP(:,:,1)=mean(PSD_DEP(:,:,RightCh),3);
PSD_asy_DEP(:,:,2)=mean(PSD_DEP(:,:,LeftCh),3);

PSDs_asy_HC=zeros(size(PSDs_HC,1),size(PSDs_HC,2), 2);
PSDs_asy_HC(:,:,1)=mean(PSDs_HC(:,:,RightROI),3);
PSDs_asy_HC(:,:,2)=mean(PSDs_HC(:,:,LeftROI),3);

PSDs_asy_DEP=zeros(size(PSDs_DEP,1),size(PSDs_DEP,2), 2);
PSDs_asy_DEP(:,:,1)=mean(PSDs_DEP(:,:,RightROI),3);
PSDs_asy_DEP(:,:,2)=mean(PSDs_DEP(:,:,LeftROI),3);

%% T test

% Scalpo
for i = 1:nbands
        P(i,1) = ranksum(abs(PSD_asy_HC(:,i,1)-PSD_asy_HC(:,i,2)),abs(PSD_asy_DEP(:,i,1)-PSD_asy_DEP(:,i,2)));
end

% Sorgenti
for i = 1:nbands
        Ps(i,1) = ranksum(abs(PSDs_asy_HC(:,i,1)-PSDs_asy_HC(:,i,2)),abs(PSDs_asy_DEP(:,i,1)-PSDs_asy_DEP(:,i,2)));
end


%% Ricerca di valori significativi

% Scalpo
sig={'Band','meanPAT-meanHC', 'more in'};
for i = 1:nbands
    if P(i,1)<0.05/cons
        asyHC=abs(mean(PSD_asy_HC(:,i,1)-PSD_asy_HC(:,i,2)));
        asyDEP=abs(mean(PSD_asy_DEP(:,i,1)-PSD_asy_DEP(:,i,2)));
        asyDiff=asyDEP-asyHC;
        if asyDiff>0
            type='DEP';
        else
            type='HC';
        end
        sig=[sig; bands(1,i), asyDiff, type];
    end
end
sig=sig(2:end,:);

% Sorgenti
sig_s={'Band', 'meanPAT-meanHC','type'};
for i = 1:nbands
        if Ps(i,1)<0.05/cons
            asyHCs=abs(mean(PSDs_asy_HC(:,i,1)-PSDs_asy_HC(:,i,2)));
            asyDEPs=abs(mean(PSDs_asy_DEP(:,i,1)-PSDs_asy_DEP(:,i,2)));
            asyDiffs=asyDEPs-asyHCs;
            if asyDiff>0
                type='DEP';
            else
                type='HC';
            end
            sig_s=[sig_s; bands(1,i), asyDiffs, type];            
    end
end

sig_s=sig_s(2:end,:);


%% Correlazione

% Scalpo
rho=zeros(nbands,1);
pval=rho;
for i = 1:nbands
        [rho(i,1), pval(i,1)]=corr(BDIdep,abs(PSD_asy_DEP(:,i,1)-PSD_asy_DEP(:,i,2)),'type','Spearman');
end

[x,y]=find(pval<(0.05/cons));
correlated=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated=[correlated; bands(x(k)),rho(x(k),y(k))];
        figure
        scatter(BDIdep,abs(PSD_asy_DEP(:,x(k),1)-PSD_asy_DEP(:,x(k),2)))
        title(strcat(bands(x(k)),'-scalp'))
    end
end


% Sorgenti
rho_s=zeros(nbands,1);
pval_s=rho_s;
for i = 1:nbands
        [rho_s(i,1), pval_s(i,1)]=corr(BDIdep,abs(PSDs_asy_DEP(:,i,1)-PSDs_asy_DEP(:,i,2)),'type','Spearman');
end

[x,y]=find(pval_s<(0.05/cons));
correlated_s=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_s=[correlated_s; bands(x(k)),rho_s(x(k),y(k))];
        figure
        scatter(BDIdep,abs(PSDs_asy_DEP(:,x(k),1)-PSDs_asy_DEP(:,x(k),2)))
        title(strcat(bands(x(k)),'-sources'))
    end
end
