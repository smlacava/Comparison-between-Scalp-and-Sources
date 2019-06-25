fil='*.mat'; 
fs=500; 
n_bands=5; 
dt=fs*8;
n_epochs=6;
tstart=6*fs+1;  % I primi 6s e gli ultimi 6s non considerati


inDir='D:\Ricerca\Ricerca3_Comparison\Sources_mat\';
outDir='D:\Ricerca\Ricerca3_Comparison\PSD\PSD_Sources\';
cases=dir(fullfile(inDir,fil));
   
for i=1:length(cases)
    i
    load(strcat(inDir,cases(i).name));
    EEG=EEGs;
    EEG=EEG(:,tstart:end);
    psd=zeros(n_bands, n_epochs, size(EEG,1));   % epoche x canali x bande
    for k = 1:n_epochs
        
        for j=1:size(EEG,1)
            data=squeeze(EEG(j,dt*(k-1)+1:k*dt));           
            [pxx,w]=pwelch(data,[],0,[],fs);          
            deltaPower=sum(pxx(2:5));         %1-4 hz      
            thetaPower=sum(pxx(5:9));         %4-8 hz          
            alphaPower=sum(pxx(9:14));        %8-13 hz            
            betaPower=sum(pxx(14:32));        %13-30 hz      
            gammaPower=sum(pxx(32:42));       %30-40 hz       
            totalPower=sum(pxx(2:42));        %1-40 hz             

            psd(1,k,j)=deltaPower/totalPower;             
            psd(2,k,j)=thetaPower/totalPower;            
            psd(3,k,j)=alphaPower/totalPower;             
            psd(4,k,j)=betaPower/totalPower;            
            psd(5,k,j)=gammaPower/totalPower;         
        end
    end
    
    filename=strcat(outDir,strtok(cases(i).name,'.'),'_PSD.mat');
    
    save(filename,'psd'); 
       
end
