%% AREA PSD
% sig contiene banda, canale e differenza tra le medie tra le PSD relative
% tra PAT e HC (scalpo)
% sig_s contiene banda, ROI e differenza tra le medie tra le PSD relative
% tra PAT e HC (sorgenti)
% correlated contiene banda, canale e correlazione tra PSD relativa e BDI
% con p-value < 0.05 (scalpo)
% correlated_s contiene banda, ROI e correlazione tra PSD relativa e BDI
% con p-value < 0.05 (sorgenti)

clear all

% Caricamento delle matrici psd relative soggetti x bande x canali/ROI:
% PSD_DEP  : sullo scalpo dei PAT
% PSDs_DEP : sulle sorgenti dei PAT
% PSD_HC   : sullo scalpo degli HC
% PSDs_HC  : sulle sorgenti degli HC
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

nzones = 5;
nzones_s = 4; %No central ROIs
nbands = size(PSD_HC,2);  % number of frequency bands
%seguire prima lettera, per le aree seguire zones (fare macro aree), per la
%zona centrale fare solo sullo scalpo



loc = size(PSD_HC,3);     % number of channels
loc_s = size(PSDs_HC,3);  % number of ROI
P = zeros(nbands, nzones);  % matrice di significatività per lo scalpo
Ps = zeros(nbands,nzones_s);  % matrice di significatività per le sorgenti


% conservatività (nzones/nzones_s*nbands, nzones/nzones_s o 1)
cons = 1%nzones*nbands;               % conservatività per lo scalpo
cons_s = 1%nzones_s*nbands;           % conservatività per le sorgenti

ROI = {'caudalanteriorcingulate L', 'caudalanteriorcingulate R', 'caudalmiddlefrontal L', 'caudalmiddlefrontal R', 'cuneus L', 'cuneus R', 'frontalpole L', 'frontalpole R', 'fusiform L', 'fusiform R', 'inferiorparietal L', 'inferiorparietal R', 'inferiortemporal L', 'inferiortemporal R', 'insula L', 'insula R', 'isthmuscingulate L', 'isthmuscingulate R', 'lateraloccipital L', 'lateraloccipital R', 'lateralorbitofrontal L', 'lateralorbitofrontal R', 'lingual R', 'lingual L', 'medialorbitofrontal L', 'medialorbitofrontal R', 'middletemporal L', 'middletemporal R', 'parahippocampal L', 'parahippocampal R', 'parsopercularis L', 'parsopercularis R', 'parsorbitalis L', 'parsorbitalis R', 'parstriangularis L', 'parstriangularis R', 'posteriorcingulate L', 'posteriorcingulate R', 'precuneus L', 'precuneus R', 'rostralanteriorcingulate L', 'rostralanteriorcingulate R', 'rostralmiddlefrontal L', 'rostralmiddlefrontal R', 'superiorfrontal L', 'superiorfrontal R', 'superiorparietal L', 'superiorparietal R', 'superiortemporal L', 'superiortemporal R', 'supramarginal L', 'supramarginal R'};
bands = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
channels = {'FP1','FPZ','FP2','AF3','AF4','F7','F5','F3','F1','FZ','F2','F4','F6','F8','FT7','FC5','FC3','FC1','FCZ','FC2','FC4','FC6','FT8','T7','C5','C3','C1','CZ','C2','C4','C6','T8','TP7','CP5','CP3','CP1','CPZ','CP2','CP4','CP6','TP8','P7','P5','P3','P1','PZ','P2','P4','P6','P8','PO7','PO3','POZ','PO4','PO8','O1','OZ','O2'};
zones={'Frontal', 'Temporal', 'Central', 'Parietal', 'Occipital'};
zones_s={'Frontal', 'Temporal', 'Parietal', 'Occipital'};

FrontalCh=[6:23];
TemporalCh=[4, 32, 33, 41];
CentralCh=[25:31, 34:40];
ParietalCh=[42:55];
OccipitalCh=[56:58];

%Caudal Middle Frontal, Frontal Pole, Lateral Orbitofrontal, Medial
%Orbitofrontal, Pars Opercularis, Pars Orbitalis, Pars Triangularis, 
%Rostral Middle Frontal, Superior Frontal
FrontalROI=[3, 4, 7, 8, 21, 22, 25, 26, 31:36, 43:46]; 

%Inferior Temporal, Middle Temporal, Parahippocampal, Superior Temporal
TemporalROI=[13, 14, 27, 28, 29, 30, 49, 50];

% No Central ROIs

%Inferior Parietal, Precuneus, Superior Parietal, Supramarginal
ParietalROI=[11, 12, 39, 40, 47, 48, 51, 52];

%Cuneus, Lateral Occipital, Lingual
OccipitalROI=[5, 6, 19, 20, 23, 24];

PSD_zone_HC=zeros(size(PSD_HC,1),size(PSD_HC,2), nzones);
PSD_zone_HC(:,:,1)=mean(PSD_HC(:,:,FrontalCh),3);
PSD_zone_HC(:,:,2)=mean(PSD_HC(:,:,TemporalCh),3);
PSD_zone_HC(:,:,3)=mean(PSD_HC(:,:,CentralCh),3);
PSD_zone_HC(:,:,4)=mean(PSD_HC(:,:,ParietalCh),3);
PSD_zone_HC(:,:,5)=mean(PSD_HC(:,:,OccipitalCh),3);

PSD_zone_DEP=zeros(size(PSD_DEP,1),size(PSD_DEP,2), nzones);
PSD_zone_DEP(:,:,1)=mean(PSD_DEP(:,:,FrontalCh),3);
PSD_zone_DEP(:,:,2)=mean(PSD_DEP(:,:,TemporalCh),3);
PSD_zone_DEP(:,:,3)=mean(PSD_DEP(:,:,CentralCh),3);
PSD_zone_DEP(:,:,4)=mean(PSD_DEP(:,:,ParietalCh),3);
PSD_zone_DEP(:,:,5)=mean(PSD_DEP(:,:,OccipitalCh),3);

PSDs_zone_HC=zeros(size(PSDs_HC,1),size(PSDs_HC,2), nzones_s);
PSDs_zone_HC(:,:,1)=mean(PSDs_HC(:,:,FrontalROI),3);
PSDs_zone_HC(:,:,2)=mean(PSDs_HC(:,:,TemporalROI),3);
PSDs_zone_HC(:,:,3)=mean(PSDs_HC(:,:,ParietalROI),3);
PSDs_zone_HC(:,:,4)=mean(PSDs_HC(:,:,OccipitalROI),3);

PSDs_zone_DEP=zeros(size(PSDs_DEP,1),size(PSDs_DEP,2), nzones_s);
PSDs_zone_DEP(:,:,1)=mean(PSDs_DEP(:,:,FrontalROI),3);
PSDs_zone_DEP(:,:,2)=mean(PSDs_DEP(:,:,TemporalROI),3);
PSDs_zone_DEP(:,:,3)=mean(PSDs_DEP(:,:,ParietalROI),3);
PSDs_zone_DEP(:,:,4)=mean(PSDs_DEP(:,:,OccipitalROI),3);

%% T test

% Scalpo
for i = 1:nbands
    for j = 1:nzones
        P(i,j) = ranksum(PSD_zone_HC(:,i,j),PSD_zone_DEP(:,i,j));
    end
end

% Sorgenti
for i = 1:nbands
    for j = 1:nzones_s
        Ps(i,j) = ranksum(PSDs_zone_HC(:,i,j),PSDs_zone_DEP(:,i,j));
    end
end


%% Ricerca di valori significativi

% Scalpo
sig={'Band', 'Zone','meanPAT-meanHC'};
for i = 1:nbands
    for j = 1:nzones
        if P(i,j)<0.05/cons
            sig=[sig; bands(1,i), zones(1,j), mean(PSD_zone_DEP(:,i,j),1)-mean(PSD_zone_HC(:,i,j),1)];
        end
    end
end
sig=sig(2:end,:);

% Sorgenti
sig_s={'Band', 'ROI','meanPAT-meanHC'};
for i = 1:nbands
    for j = 1:nzones_s
        if Ps(i,j)<0.05/cons_s
            sig_s=[sig_s; bands(1,i), zones_s(1,j), mean(PSDs_zone_DEP(:,i,j),1)-mean(PSDs_zone_HC(:,i,j),1)];
        end
    end
end
sig_s=sig_s(2:end,:);


%% Correlazione

% Scalpo
rho=zeros(nbands,nzones);
pval=rho;
for i = 1:nbands
    for j = 1:nzones
        [rho(i,j), pval(i,j)]=corr(BDIdep,PSD_zone_DEP(:,i,j),'type','Spearman');
    end
end

[x,y]=find(pval<(0.05/cons));
correlated=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated=[correlated; bands(x(k)),zones(y(k)),rho(x(k),y(k))];
        figure
        scatter(BDIdep,PSD_zone_DEP(:,x(k),y(k)))
        title(strcat(bands(x(k)),'-',zones(y(k))))
    end
end


% Sorgenti
rho_s=zeros(nbands,nzones_s);
pval_s=rho_s;
for i = 1:nbands
    for j = 1:nzones_s
        [rho_s(i,j), pval_s(i,j)]=corr(BDIdep,PSDs_zone_DEP(:,i,j),'type','Spearman');
    end
end

[x,y]=find(pval_s<(0.05/cons_s));
correlated_s=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_s=[correlated_s; bands(x(k)),zones_s(y(k)),rho_s(x(k),y(k))];
        figure
        scatter(BDIdep,PSDs_zone_DEP(:,x(k),y(k)))
        title(strcat(bands(x(k)),'-',zones_s(y(k))))
    end
end
