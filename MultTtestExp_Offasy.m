
clear all

load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\EXP_epmean\EXP_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\EXP_epmean\EXPs_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\EXP_epmean\EXP_DEP_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\EXP_epmean\EXPs_DEP_em.mat';

load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\OFFSET_epmean\OFFSET_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\OFFSET_epmean\OFFSETs_HC_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\OFFSET_epmean\OFFSET_DEP_em.mat';
load 'D:\Ricerca\Ricerca3_Comparison\FOOOF\OFFSET_epmean\OFFSETs_DEP_em.mat';

load 'D:\Ricerca\Ricerca3_Comparison\BDI.mat';
BDIdep = BDI(BDI(:,2)>13,2); 
BDIhc = BDI(BDI(:,2)<8,2);

nhemi = 2;
loc = size(OFFSET_HC,2);     % number of channels
loc_s = size(OFFSETs_HC,2);  % number of ROI

% conservatività (nhemi*nbands, nhemi o 1)
cons = 1%nhemi;               % conservatività per lo scalpo e per le sorgenti

ROI = {'caudalanteriorcingulate L', 'caudalanteriorcingulate R', 'caudalmiddlefrontal L', 'caudalmiddlefrontal R', 'cuneus L', 'cuneus R', 'frontalpole L', 'frontalpole R', 'fusiform L', 'fusiform R', 'inferiorparietal L', 'inferiorparietal R', 'inferiortemporal L', 'inferiortemporal R', 'insula L', 'insula R', 'isthmuscingulate L', 'isthmuscingulate R', 'lateraloccipital L', 'lateraloccipital R', 'lateralorbitofrontal L', 'lateralorbitofrontal R', 'lingual R', 'lingual L', 'medialorbitofrontal L', 'medialorbitofrontal R', 'middletemporal L', 'middletemporal R', 'parahippocampal L', 'parahippocampal R', 'parsopercularis L', 'parsopercularis R', 'parsorbitalis L', 'parsorbitalis R', 'parstriangularis L', 'parstriangularis R', 'posteriorcingulate L', 'posteriorcingulate R', 'precuneus L', 'precuneus R', 'rostralanteriorcingulate L', 'rostralanteriorcingulate R', 'rostralmiddlefrontal L', 'rostralmiddlefrontal R', 'superiorfrontal L', 'superiorfrontal R', 'superiorparietal L', 'superiorparietal R', 'superiortemporal L', 'superiortemporal R', 'supramarginal L', 'supramarginal R'};
channels = {'FP1','FPZ','FP2','AF3','AF4','F7','F5','F3','F1','FZ','F2','F4','F6','F8','FT7','FC5','FC3','FC1','FCZ','FC2','FC4','FC6','FT8','T7','C5','C3','C1','CZ','C2','C4','C6','T8','TP7','CP5','CP3','CP1','CPZ','CP2','CP4','CP6','TP8','P7','P5','P3','P1','PZ','P2','P4','P6','P8','PO7','PO3','POZ','PO4','PO8','O1','OZ','O2'};
hemispheres={'Right', 'Left'};

RightCh=[3, 5, 11:14, 20:23, 29:32, 38:41, 47:50, 54, 55, 58];
LeftCh=[1, 4, 6:9, 15:18, 24:27, 33:36, 42:45, 51, 52, 56];

RightROI=[2:2:52];
LeftROI=[1:2:52];

OFFSET_asy_HC=zeros(size(OFFSET_HC,1), nhemi);
OFFSET_asy_HC(:,1)=mean(OFFSET_HC(:,RightCh),2);
OFFSET_asy_HC(:,2)=mean(OFFSET_HC(:,LeftCh),2);

OFFSET_asy_DEP=zeros(size(OFFSET_DEP,1), nhemi);
OFFSET_asy_DEP(:,1)=mean(OFFSET_DEP(:,RightCh),2);
OFFSET_asy_DEP(:,2)=mean(OFFSET_DEP(:,LeftCh),2);

OFFSETs_asy_HC=zeros(size(OFFSETs_HC,1), nhemi);
OFFSETs_asy_HC(:,1)=mean(OFFSETs_HC(:,RightROI),2);
OFFSETs_asy_HC(:,2)=mean(OFFSETs_HC(:,LeftROI),2);

OFFSETs_asy_DEP=zeros(size(OFFSETs_DEP,1), nhemi);
OFFSETs_asy_DEP(:,1)=mean(OFFSETs_DEP(:,RightROI),2);
OFFSETs_asy_DEP(:,2)=mean(OFFSETs_DEP(:,LeftROI),2);


EXP_asy_HC=zeros(size(EXP_HC,1), nhemi);
EXP_asy_HC(:,1)=mean(EXP_HC(:,RightCh),2);
EXP_asy_HC(:,2)=mean(EXP_HC(:,LeftCh),2);

EXP_asy_DEP=zeros(size(EXP_DEP,1), nhemi);
EXP_asy_DEP(:,1)=mean(EXP_DEP(:,RightCh),2);
EXP_asy_DEP(:,2)=mean(EXP_DEP(:,LeftCh),2);

EXPs_asy_HC=zeros(size(EXPs_HC,1), nhemi);
EXPs_asy_HC(:,1)=mean(EXPs_HC(:,RightROI),2);
EXPs_asy_HC(:,2)=mean(EXPs_HC(:,LeftROI),2);

EXPs_asy_DEP=zeros(size(EXPs_DEP,1), nhemi);
EXPs_asy_DEP(:,1)=mean(EXPs_DEP(:,RightROI),2);
EXPs_asy_DEP(:,2)=mean(EXPs_DEP(:,LeftROI),2);


%% T test

% Scalpo
P_o = ranksum(abs(OFFSET_asy_HC(:,1)-OFFSET_asy_HC(:,2)),abs(OFFSET_asy_DEP(:,1)-OFFSET_asy_DEP(:,2)));
P_e = ranksum(abs(EXP_asy_HC(:,1)-EXP_asy_HC(:,2)),abs(EXP_asy_DEP(:,1)-EXP_asy_DEP(:,2)));


% Sorgenti

Ps_o = ranksum(abs(OFFSETs_asy_HC(:,1)-OFFSETs_asy_HC(:,2)),abs(OFFSETs_asy_DEP(:,1)-OFFSETs_asy_DEP(:,2)));
Ps_e = ranksum(abs(EXPs_asy_HC(:,1)-EXPs_asy_HC(:,2)),abs(EXPs_asy_DEP(:,1)-EXPs_asy_DEP(:,2)));

%% Ricerca di valori significativi

% Scalpo
if P_o<0.05/cons
    asyHC=abs(mean(OFFSET_asy_HC(:,1)-OFFSET_asy_HC(:,2)));
    asyDEP=abs(mean(OFFSET_asy_DEP(:,1)-OFFSET_asy_DEP(:,2)));
    asyDiff=asyDEP-asyHC;
    if asyDiff>0
        type='DEP';
    else
        type='HC';
    end
    sig_o=[asyDiff, type];
end

if P_e<0.05/cons
    asyHC=abs(mean(EXP_asy_HC(:,1)-EXP_asy_HC(:,2)));
    asyDEP=abs(mean(EXP_asy_DEP(:,1)-EXP_asy_DEP(:,2)));
    asyDiff=asyDEP-asyHC;
    if asyDiff>0
        type='DEP';
    else
        type='HC';
    end
    sig_e=[asyDiff, type];
end


% Sorgenti
if Ps_o<0.05/cons
    asyHCs=abs(mean(OFFSETs_asy_HC(:,1)-OFFSETs_asy_HC(:,2)));
    asyDEPs=abs(mean(OFFSETs_asy_DEP(:,1)-OFFSETs_asy_DEP(:,2)));
    asyDiffs=asyDEPs-asyHCs;
    if asyDiff>0
        type='DEP';
    else
        type='HC';
    end
    sig_s_o=[asyDiffs, type];            
end

if Ps_e<0.05/cons
    asyHCs=abs(mean(EXPs_asy_HC(:,1)-EXPs_asy_HC(:,2)));
    asyDEPs=abs(mean(EXPs_asy_DEP(:,1)-EXPs_asy_DEP(:,2)));
    asyDiffs=asyDEPs-asyHCs;
    if asyDiff>0
        type='DEP';
    else
        type='HC';
    end
    sig_s_e=[asyDiffs, type];            
end



%% Correlazione

% Scalpo
[rho_o, pval_o]=corr(BDIdep,abs(OFFSET_DEP(:,1)-OFFSET_DEP(:,2)),'type','Spearman');
[rho_e, pval_e]=corr(BDIdep,abs(EXP_DEP(:,1)-EXP_DEP(:,2)),'type','Spearman');

if pval_o<(0.05/cons)
	figure
	scatter(BDIdep,abs(OFFSET_asy_DEP(:,1)-OFFSET_asy_DEP(:,2)))
	title('offset-scalp')
end

if pval_e<(0.05/cons)
	figure
	scatter(BDIdep,abs(EXP_asy_DEP(:,1)-EXP_asy_DEP(:,2)))
	title('exponent-scalp')
end


% Sorgenti
[rho_s_o, pval_s_o]=corr(BDIdep,abs(OFFSETs_DEP(:,1)-OFFSETs_DEP(:,2)),'type','Spearman');
[rho_s_e, pval_s_e]=corr(BDIdep,abs(EXPs_DEP(:,1)-EXPs_DEP(:,2)),'type','Spearman');

if pval_s_o<(0.05/cons)
	figure
	scatter(BDIdep,abs(OFFSETs_asy_DEP(:,1)-OFFSETs_asy_DEP(:,2)))
	title('offset-sources')
end

if pval_s_e<(0.05/cons)
	figure
	scatter(BDIdep,abs(EXPs_asy_DEP(:,1)-EXPs_asy_DEP(:,2)))
	title('exponent-sources')
end
