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
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\EXP_epmean\EXP_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\EXP_epmean\EXPs_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\EXP_epmean\EXP_DEP_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\EXP_epmean\EXPs_DEP_em.mat';

load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\OFFSET_epmean\OFFSET_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\OFFSET_epmean\OFFSETs_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\OFFSET_epmean\OFFSET_DEP_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\OFFSET_epmean\OFFSETs_DEP_em.mat';


% Caricamento matrice SUBJ-BDI e ottenimento matrici BDI per PAT e per HC
% (un BDI>13 indica la presenza di depressione, un BDI<8 ne indica
% l'assenza)
load 'D:\Ricerca\Ricerca3_Comparison\BDI.mat';
BDIdep = BDI(BDI(:,2)>13,2); 
BDIhc = BDI(BDI(:,2)<8,2);

nzones = 5;
nzones_s = 4; %No central ROIs
%seguire prima lettera, per le aree seguire zones (fare macro aree), per la
%zona centrale fare solo sullo scalpo



loc = size(OFFSET_HC,2);     % number of channels
loc_s = size(OFFSETs_HC,2);  % number of ROI
P_o = zeros(1,nzones);  % matrice di significatività per lo scalpo
Ps_o = zeros(1,nzones_s);  % matrice di significatività per le sorgenti
P_e = P_o;
Ps_e = Ps_o;


% conservatività (nzones/nzones_s o 1)
cons = nzones;               % conservatività per lo scalpo
cons_s = nzones_s;           % conservatività per le sorgenti

ROI = {'caudalanteriorcingulate L', 'caudalanteriorcingulate R', 'caudalmiddlefrontal L', 'caudalmiddlefrontal R', 'cuneus L', 'cuneus R', 'frontalpole L', 'frontalpole R', 'fusiform L', 'fusiform R', 'inferiorparietal L', 'inferiorparietal R', 'inferiortemporal L', 'inferiortemporal R', 'insula L', 'insula R', 'isthmuscingulate L', 'isthmuscingulate R', 'lateraloccipital L', 'lateraloccipital R', 'lateralorbitofrontal L', 'lateralorbitofrontal R', 'lingual R', 'lingual L', 'medialorbitofrontal L', 'medialorbitofrontal R', 'middletemporal L', 'middletemporal R', 'parahippocampal L', 'parahippocampal R', 'parsopercularis L', 'parsopercularis R', 'parsorbitalis L', 'parsorbitalis R', 'parstriangularis L', 'parstriangularis R', 'posteriorcingulate L', 'posteriorcingulate R', 'precuneus L', 'precuneus R', 'rostralanteriorcingulate L', 'rostralanteriorcingulate R', 'rostralmiddlefrontal L', 'rostralmiddlefrontal R', 'superiorfrontal L', 'superiorfrontal R', 'superiorparietal L', 'superiorparietal R', 'superiortemporal L', 'superiortemporal R', 'supramarginal L', 'supramarginal R'};
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

OFFSET_zone_HC=zeros(size(OFFSET_HC,1), nzones);
OFFSET_zone_HC(:,1)=mean(OFFSET_HC(:,FrontalCh),2);
OFFSET_zone_HC(:,2)=mean(OFFSET_HC(:,TemporalCh),2);
OFFSET_zone_HC(:,3)=mean(OFFSET_HC(:,CentralCh),2);
OFFSET_zone_HC(:,4)=mean(OFFSET_HC(:,ParietalCh),2);
OFFSET_zone_HC(:,5)=mean(OFFSET_HC(:,OccipitalCh),2);

OFFSET_zone_DEP=zeros(size(OFFSET_DEP,1),nzones);
OFFSET_zone_DEP(:,1)=mean(OFFSET_DEP(:,FrontalCh),2);
OFFSET_zone_DEP(:,2)=mean(OFFSET_DEP(:,TemporalCh),2);
OFFSET_zone_DEP(:,3)=mean(OFFSET_DEP(:,CentralCh),2);
OFFSET_zone_DEP(:,4)=mean(OFFSET_DEP(:,ParietalCh),2);
OFFSET_zone_DEP(:,5)=mean(OFFSET_DEP(:,OccipitalCh),2);

OFFSETs_zone_HC=zeros(size(OFFSETs_HC,1), nzones_s);
OFFSETs_zone_HC(:,1)=mean(OFFSETs_HC(:,FrontalROI),2);
OFFSETs_zone_HC(:,2)=mean(OFFSETs_HC(:,TemporalROI),2);
OFFSETs_zone_HC(:,3)=mean(OFFSETs_HC(:,ParietalROI),2);
OFFSETs_zone_HC(:,4)=mean(OFFSETs_HC(:,OccipitalROI),2);

OFFSETs_zone_DEP=zeros(size(OFFSETs_DEP,1), nzones_s);
OFFSETs_zone_DEP(:,1)=mean(OFFSETs_DEP(:,FrontalROI),2);
OFFSETs_zone_DEP(:,2)=mean(OFFSETs_DEP(:,TemporalROI),2);
OFFSETs_zone_DEP(:,3)=mean(OFFSETs_DEP(:,ParietalROI),2);
OFFSETs_zone_DEP(:,4)=mean(OFFSETs_DEP(:,OccipitalROI),2);

EXP_zone_HC=zeros(size(EXP_HC,1), nzones);
EXP_zone_HC(:,1)=mean(EXP_HC(:,FrontalROI),2);
EXP_zone_HC(:,2)=mean(EXP_HC(:,TemporalROI),2);
EXP_zone_HC(:,3)=mean(EXP_HC(:,CentralCh),2);
EXP_zone_HC(:,3)=mean(EXP_HC(:,ParietalROI),2);
EXP_zone_HC(:,4)=mean(EXP_HC(:,OccipitalROI),2);

EXP_zone_DEP=zeros(size(EXP_DEP,1), nzones);
EXP_zone_DEP(:,1)=mean(EXP_DEP(:,FrontalROI),2);
EXP_zone_DEP(:,2)=mean(EXP_DEP(:,TemporalROI),2);
EXP_zone_DEP(:,3)=mean(EXP_DEP(:,CentralCh),2);
EXP_zone_DEP(:,3)=mean(EXP_DEP(:,ParietalROI),2);
EXP_zone_DEP(:,4)=mean(EXP_DEP(:,OccipitalROI),2);

EXPs_zone_HC=zeros(size(EXPs_HC,1), nzones_s);
EXPs_zone_HC(:,1)=mean(EXPs_HC(:,FrontalROI),2);
EXPs_zone_HC(:,2)=mean(EXPs_HC(:,TemporalROI),2);
EXPs_zone_HC(:,3)=mean(EXPs_HC(:,ParietalROI),2);
EXPs_zone_HC(:,4)=mean(EXPs_HC(:,OccipitalROI),2);

EXPs_zone_DEP=zeros(size(EXPs_DEP,1), nzones_s);
EXPs_zone_DEP(:,1)=mean(EXPs_DEP(:,FrontalROI),2);
EXPs_zone_DEP(:,2)=mean(EXPs_DEP(:,TemporalROI),2);
EXPs_zone_DEP(:,3)=mean(EXPs_DEP(:,ParietalROI),2);
EXPs_zone_DEP(:,4)=mean(EXPs_DEP(:,OccipitalROI),2);

%% T test

% Scalpo
for j = 1:nzones
    P_o(1,j) = ranksum(OFFSET_zone_HC(:,j),OFFSET_zone_DEP(:,j));
    P_e(1,j) = ranksum(EXP_zone_HC(:,j),EXP_zone_DEP(:,j));
end


% Sorgenti
for j = 1:nzones_s
    Ps_o(1,j) = ranksum(OFFSETs_zone_HC(:,j),OFFSETs_zone_DEP(:,j));
    Ps_e(1,j) = ranksum(EXPs_zone_HC(:,j),EXPs_zone_DEP(:,j));
end


%% Ricerca di valori significativi

% Scalpo
sig_o={'Zone','meanPAT-meanHC'};
sig_e=sig_o;
for j = 1:nzones
	if P_o(1,j)<0.05/cons
        sig_o=[sig_o; zones(1,j), mean(OFFSET_zone_DEP(:,j),1)-mean(OFFSET_zone_HC(:,j),1)];        
    end
    if P_e(1,j)<0.05/cons
        sig_e=[sig_e; zones(1,j), mean(EXP_zone_DEP(:,j),1)-mean(EXP_zone_HC(:,j),1)];        
    end
end
sig_e=sig_e(2:end,:);
sig_o=sig_o(2:end,:);

% Sorgenti
sig_s_o={'ROI','meanPAT-meanHC'};
sig_s_e=sig_s_o;
for j = 1:nzones_s
    if Ps_o(1,j)<0.05/cons_s
        sig_s_o=[sig_s_o; zones_s(1,j), mean(OFFSETs_zone_DEP(:,j),1)-mean(OFFSETs_zone_HC(:,j),1)];
    end
    if Ps_e(1,j)<0.05/cons_s
        sig_s_e=[sig_s_e; zones_s(1,j), mean(EXPs_zone_DEP(:,j),1)-mean(EXPs_zone_HC(:,j),1)];
    end
end
sig_s_o=sig_s_o(2:end,:);
sig_s_e=sig_s_e(2:end,:);


%% Correlazione

% Scalpo
rho_o=zeros(1,nzones);
pval_o=rho_o;
rho_e=rho_o;
pval_e=pval_o;
for j = 1:nzones
	[rho_o(1,j), pval_o(1,j)]=corr(BDIdep,OFFSET_zone_DEP(:,j),'type','Spearman');
    [rho_e(1,j), pval_e(1,j)]=corr(BDIdep,EXP_zone_DEP(:,j),'type','Spearman');
end

[x,y]=find(pval_o<(0.05/cons));
correlated_o=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_o=[correlated_o; zones(y(k)),rho_o(1,y(k))];
        figure
        scatter(BDIdep,OFFSET_zone_DEP(:,y(k)))
        title(strcat('offset-',zones(y(k))))
    end
end

[x,y]=find(pval_e<(0.05/cons));
correlated_e=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_e=[correlated_e; zones(y(k)),rho_e(1,y(k))];
        figure
        scatter(BDIdep,EXP_zone_DEP(:,y(k)))
        title(strcat('exponent-',zones(y(k))))
    end
end


% Sorgenti
rho_s_o=zeros(1,nzones_s);
pval_s_o=rho_s_o;
rho_s_e=rho_s_o;
pval_s_e=pval_s_o;
for j = 1:nzones_s
        [rho_s_o(1,j), pval_s_o(1,j)]=corr(BDIdep,OFFSETs_zone_DEP(:,j),'type','Spearman');
        [rho_s_e(1,j), pval_s_e(1,j)]=corr(BDIdep,EXPs_zone_DEP(:,j),'type','Spearman');
end

[x,y]=find(pval_s_o<(0.05/cons_s));
correlated_s_o=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_s_o=[correlated_s_o; zones_s(y(k)),rho_s_o(1,y(k))];
        figure
        scatter(BDIdep,OFFSETs_zone_DEP(:,y(k)))
        title(strcat('offset-',zones_s(y(k))))
    end
end

[x,y]=find(pval_s_e<(0.05/cons_s));
correlated_s_e=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_s_e=[correlated_s_e; zones_s(y(k)),rho_s_e(1,y(k))];
        figure
        scatter(BDIdep,EXPs_zone_DEP(:,y(k)))
        title(strcat('exponential-',zones_s(y(k))))
    end
end
