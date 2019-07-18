%% PSD Multiple T test (Mann-Whitney/Wilcoxon) & Spearman correlation
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

nbands = size(PSD_HC,2);  % number of frequency bands
loc = size(PSD_HC,3);     % number of channels
loc_s = size(PSDs_HC,3);  % number of ROI
P = zeros(nbands, loc);  % matrice di significatività per lo scalpo
Ps = zeros(nbands,loc_s);  % matrice di significatività per le sorgenti

% conservatività (loc*nbands, loc o 1)
cons = 1;               % conservatività per lo scalpo
cons_s = 1;           % conservatività per le sorgenti

ROI = {'caudalanteriorcingulate L', 'caudalanteriorcingulate R', 'caudalmiddlefrontal L', 'caudalmiddlefrontal R', 'cuneus L', 'cuneus R', 'frontalpole L', 'frontalpole R', 'fusiform L', 'fusiform R', 'inferiorparietal L', 'inferiorparietal R', 'inferiortemporal L', 'inferiortemporal R', 'insula L', 'insula R', 'isthmuscingulate L', 'isthmuscingulate R', 'lateraloccipital L', 'lateraloccipital R', 'lateralorbitofrontal L', 'lateralorbitofrontal R', 'lingual R', 'lingual L', 'medialorbitofrontal L', 'medialorbitofrontal R', 'middletemporal L', 'middletemporal R', 'parahippocampal L', 'parahippocampal R', 'parsopercularis L', 'parsopercularis R', 'parsorbitalis L', 'parsorbitalis R', 'parstriangularis L', 'parstriangularis R', 'posteriorcingulate L', 'posteriorcingulate R', 'precuneus L', 'precuneus R', 'rostralanteriorcingulate L', 'rostralanteriorcingulate R', 'rostralmiddlefrontal L', 'rostralmiddlefrontal R', 'superiorfrontal L', 'superiorfrontal R', 'superiorparietal L', 'superiorparietal R', 'superiortemporal L', 'superiortemporal R', 'supramarginal L', 'supramarginal R'};
bands = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
channels = {'FP1','FPZ','FP2','AF3','AF4','F7','F5','F3','F1','FZ','F2','F4','F6','F8','FT7','FC5','FC3','FC1','FCZ','FC2','FC4','FC6','FT8','T7','C5','C3','C1','CZ','C2','C4','C6','T8','TP7','CP5','CP3','CP1','CPZ','CP2','CP4','CP6','TP8','P7','P5','P3','P1','PZ','P2','P4','P6','P8','PO7','PO3','POZ','PO4','PO8','O1','OZ','O2'};


%% T test

% Scalpo
for i = 1:nbands
    for j = 1:loc
        P(i,j) = ranksum(PSD_HC(:,i,j),PSD_DEP(:,i,j));
    end
end

% Sorgenti
for i = 1:nbands
    for j = 1:loc_s
        Ps(i,j) = ranksum(PSDs_HC(:,i,j),PSDs_DEP(:,i,j));
    end
end


%% Ricerca di valori significativi

% Scalpo
sig={'Band', 'Channel','meanPAT-meanHC'};
for i = 1:nbands
    for j = 1:loc
        if P(i,j)<0.05/cons
            sig=[sig; bands(1,i), channels(1,j), mean(PSD_DEP(:,i,j),1)-mean(PSD_HC(:,i,j),1)];

            %figure
            
            %scatter(BDIdep, PSD_DEP(:,i,j),'r')
            %hold on
            %scatter(BDIhc, PSD_HC(:,i,j),'b')
            %title(strcat(bands(1,i),'-',channels(1,j)))
        end
    end
end
sig=sig(2:end,:);

% Sorgenti
sig_s={'Band', 'ROI','meanPAT-meanHC'};
for i = 1:nbands
    for j = 1:loc_s
        if Ps(i,j)<0.05/cons_s
            sig_s=[sig_s; bands(1,i), ROI(1,j), mean(PSDs_DEP(:,i,j),1)-mean(PSDs_HC(:,i,j),1)];
        end
    end
end
sig_s=sig_s(2:end,:);


%% Correlazione

% Scalpo
rho=zeros(nbands,loc);
pval=rho;
for i = 1:nbands
    for j = 1:loc
        [rho(i,j), pval(i,j)]=corr(BDIdep,PSD_DEP(:,i,j),'type','Spearman');
    end
end

[x,y]=find(pval<(0.05/cons));
correlated=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated=[correlated; bands(x(k)),channels(y(k)),rho(x(k),y(k))];
        figure
        scatter(BDIdep,PSD_DEP(:,x(k),y(k)))
        title(strcat(bands(x(k)),'-',channels(y(k))))
    end
end


% Sorgenti
rho_s=zeros(nbands,loc_s);
pval_s=rho_s;
for i = 1:nbands
    for j = 1:loc_s
        [rho_s(i,j), pval_s(i,j)]=corr(BDIdep,PSDs_DEP(:,i,j),'type','Spearman');
    end
end

[x,y]=find(pval_s<(0.05/cons_s));
correlated_s=[];
if isempty(x)==0
    for k=1:max(size(x))
        correlated_s=[correlated_s; bands(x(k)),ROI(y(k)),rho_s(x(k),y(k))];
        figure
        scatter(BDIdep,PSDs_DEP(:,x(k),y(k)))
        title(strcat(bands(x(k)),'-',ROI(y(k))))
    end
end
