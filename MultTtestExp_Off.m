%% FOOOF Multiple T test (Mann-Whitney/Wilcoxon) & Spearman correlation
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

hc = 58;
dep = 29;
loc = size(EXP_HC,2);     % number of channels
loc_s = size(EXPs_HC,2);  % number of ROI
P_exp = zeros(1,loc);     % matrice di significatività dell'esponente per lo scalpo
Ps_exp = zeros(1,loc_s);  % matrice di significatività dell'esponente per le sorgenti
P_offset = P_exp;         % matrice di significatività dell'offset per lo scalpo
Ps_offset = P_offset;     % matrice di significatività dell'offset per le sorgenti

% conservatività (loc/loc_s o 1)
cons = 1;               % conservatività per lo scalpo
cons_s = 1;           % conservatività per le sorgenti

ROI = {'caudalanteriorcingulate L', 'caudalanteriorcingulate R', 'caudalmiddlefrontal L', 'caudalmiddlefrontal R', 'cuneus L', 'cuneus R', 'frontalpole L', 'frontalpole R', 'fusiform L', 'fusiform R', 'inferiorparietal L', 'inferiorparietal R', 'inferiortemporal L', 'inferiortemporal R', 'insula L', 'insula R', 'isthmuscingulate L', 'isthmuscingulate R', 'lateraloccipital L', 'lateraloccipital R', 'lateralorbitofrontal L', 'lateralorbitofrontal R', 'lingual R', 'lingual L', 'medialorbitofrontal L', 'medialorbitofrontal R', 'middletemporal L', 'middletemporal R', 'parahippocampal L', 'parahippocampal R', 'parsopercularis L', 'parsopercularis R', 'parsorbitalis L', 'parsorbitalis R', 'parstriangularis L', 'parstriangularis R', 'posteriorcingulate L', 'posteriorcingulate R', 'precuneus L', 'precuneus R', 'rostralanteriorcingulate L', 'rostralanteriorcingulate R', 'rostralmiddlefrontal L', 'rostralmiddlefrontal R', 'superiorfrontal L', 'superiorfrontal R', 'superiorparietal L', 'superiorparietal R', 'superiortemporal L', 'superiortemporal R', 'supramarginal L', 'supramarginal R'};
channels = {'FP1','FPZ','FP2','AF3','AF4','F7','F5','F3','F1','FZ','F2','F4','F6','F8','FT7','FC5','FC3','FC1','FCZ','FC2','FC4','FC6','FT8','T7','C5','C3','C1','CZ','C2','C4','C6','T8','TP7','CP5','CP3','CP1','CPZ','CP2','CP4','CP6','TP8','P7','P5','P3','P1','PZ','P2','P4','P6','P8','PO7','PO3','POZ','PO4','PO8','O1','OZ','O2'};

%% T test

% Scalpo
for j = 1:loc
	P_exp(1,j) = ranksum(EXP_HC(:,j),EXP_DEP(:,j));
    P_offset(1,j) = ranksum(OFFSET_HC(:,j),OFFSET_DEP(:,j));
end

% Sorgenti
for j = 1:loc_s
	Ps_exp(1,j) = ranksum(EXPs_HC(:,j),EXPs_DEP(:,j));
    Ps_offset(1,j) = ranksum(OFFSET_HC(:,j),OFFSET_DEP(:,j));
end


%% Ricerca di valori significativi dell'esponente

% Scalpo
sig_e={'Channel','meanPAT-meanHC'};
for j = 1:loc
    if P_exp(1,j)<0.05/cons
        sig_e=[sig_e; channels(j), mean(EXP_DEP(:,j),1)-mean(EXP_HC(:,j),1)];
    end
end
sig_e=sig_e(2:end,:);

% Sorgenti
sig_s_e={'ROI','meanPAT-meanHC'};
for j = 1:loc_s
    if Ps_exp(1,j)<0.05/cons_s
        sig_s_e=[sig_s_e; ROI(j), mean(EXPs_DEP(:,j),1)-mean(EXPs_HC(:,j),1)];
    end
end
sig_s_e=sig_s_e(2:end,:);

%% Ricerca di valori significativi dell'offset

% Scalpo
sig_o={'Channel','meanPAT-meanHC'};
for j = 1:loc
    if P_offset(1,j)<0.05/cons
        sig_o=[sig_o; channels(j), mean(OFFSET_DEP(:,j),1)-mean(OFFSET_HC(:,j),1)];
    end
end
sig_o=sig_o(2:end,:);

% Sorgenti
sig_s_o={'ROI','meanPAT-meanHC'};
for j = 1:loc_s
    if Ps_offset(1,j)<0.05/cons_s
        sig_s_o=[sig_s_o; ROI(j), mean(OFFSETs_DEP(:,j),1)-mean(OFFSETs_HC(:,j),1)];
    end
end
sig_s_o=sig_s_o(2:end,:);


%% Correlazione

% Scalpo
rho_e=zeros(1,loc);
pval_e=rho_e;
rho_o=rho_e;
pval_o=pval_e;
for j = 1:loc
    [rho_e(1,j), pval_e(1,j)]=corr(BDIdep,EXP_DEP(:,j),'type','Spearman');
    [rho_o(1,j), pval_o(1,j)]=corr(BDIdep,OFFSET_DEP(:,j),'type','Spearman');
end

[x,y]=find(pval_e<(0.05/cons));
correlated_e=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_e=[correlated_e; channels(1,y(k)),rho_e(1,y(k))];
        figure
        scatter(BDIdep,EXP_DEP(:,y(k)))
        title(strcat('exponent-',channels(y(k))))
    end
end

[x,y]=find(pval_o<(0.05/cons));
correlated_o=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_o=[correlated_o; channels(1,y(k)),rho_o(1,y(k))];
        figure
        scatter(BDIdep,OFFSET_DEP(:,y(k)))
        title(strcat('offset-',channels(y(k))))
    end
end


% Sorgenti
rho_s_e=zeros(1,loc_s);
pval_s_e=rho_s_e;
rho_s_o=rho_s_e;
pval_s_o=pval_s_e;
for j = 1:loc_s
    [rho_s_e(1,j), pval_s_e(1,j)]=corr(BDIdep,EXPs_DEP(:,j),'type','Spearman');
    [rho_s_o(1,j), pval_s_o(1,j)]=corr(BDIdep,OFFSETs_DEP(:,j),'type','Spearman');
end

[x,y]=find(pval_s_e<(0.05/cons_s));
correlated_s_e=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_s_e=[correlated_s_e; ROI(1,y(k)),rho_s_e(1,y(k))];
        figure
        scatter(BDIdep,EXPs_DEP(:,y(k)))
        title(strcat('exponent-',ROI(y(k))))
    end
end

[x,y]=find(pval_s_o<(0.05/cons_s));
correlated_s_o=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_s_o=[correlated_s_o; ROI(1,y(k)),rho_s_o(1,y(k))];
        figure
        scatter(BDIdep,OFFSETs_DEP(:,y(k)))
        title(strcat('offset-',ROI(y(k))))
    end
end

