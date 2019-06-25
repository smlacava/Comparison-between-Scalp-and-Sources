% La matrice Cases (Cases_tot.mat) contiene nella prima colonna l'id dei
% pazienti nella prima colonna e gli istanti di inizio dei blocchi da un
% minuto nelle colonne rappresentanti i vari stati (2,4,6 occhi chiusi,
% 3,5,7 occhi aperti)
load('D:\Ricerca\Ricerca3_Comparison\Cases_tot.mat')

Closed=Cases(:,1:2);
Closed(Closed(:,2)==0,2)=Cases(Closed(:,2)==0,4);
Closed(Closed(:,2)==0,2)=Cases(Closed(:,2)==0,6);
Closed(Closed(:,2)==0,:)=[];
save('D:\Ricerca\Ricerca3_Comparison\Cases_closed.mat','Closed')
% Closed (Cases_closed.mat) contiene l'id dei pazienti nella prima colonna e gli istanti di inizio
% dei blocchi da un minuto a occhi chiusi

Open=Cases(:,1:2:3);
Open(Open(:,2)==0,2)=Cases(Open(:,2)==0,4);
Open(Open(:,2)==0,2)=Cases(Open(:,2)==0,6);
Open(Open(:,2)==0,:)=[];
save('D:\Ricerca\Ricerca3_Comparison\Cases_open.mat','Open')
% B contiene l'id dei pazienti nella prima colonna e gli istanti di inizio
% dei blocchi da un minuto a occhi chiusi

% Exc(i,2)<8 CTRL => 0 // Exc(i,2)>13 DEP => 1
load('D:\Ricerca\Ricerca3_Comparison\DEP-CTRL.mat')
%Exc(Exc(:,2)>=8 & Exc(:,2)<=13,:)=[];
%Exc(Exc(:,2)<8,2)=0;
%Exc(Exc(:,2)>13,2)=1;
% La matrice Exc (DEP-CTRL.mat) ha l'id dei pazienti nella prima colonna e lo stato
% (0=CTRL, 1=DEP) nella seconda

ExcTOT=max(size(Exc));
% Open DEP & Open CTL
openCTL=0;
openTOT=max(size(Open));
for i=1:openTOT
    for j=1:ExcTOT
        if Exc(j,1)==Open(i,1) && Exc(j,2)==0
            openCTL=openCTL+1;
        end
    end
end
openDEP=openTOT-openCTL;

% Closed DEP & Closed CTL
closedCTL=0;
closedTOT=max(size(Closed));
for i=1:closedTOT
    for j=1:ExcTOT
        if Exc(j,1)==Closed(i,1) && Exc(j,2)==0
            closedCTL=closedCTL+1;
        end
    end
end
closedDEP=closedTOT-closedCTL;

% Creazione della matrice Sub [DA MODIFICARE]
closedCTL=0;
closedTOT=max(size(Closed));
Sub=[Closed, ones(closedTOT,1)];
for i=1:closedTOT
    for j=1:ExcTOT
        if Exc(j,1)==Closed(i,1) && Exc(j,2)==0
           Sub(i,3)=0;
        end
    end
end
closedDEP=closedTOT-closedCTL;