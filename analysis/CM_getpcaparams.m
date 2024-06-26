function params = CM_getpcaparams(app, parameters,pcrsrc_dir)
% Re export parameters based on input settings from settings_thuong file.m
% and indicated pcrsrc_dir where templates file is located
parameters.templatesrcdir=pcrsrc_dir;

%default fscv params
anodal_lim=1.3;
cathodal_lim=-0.4;
vlim=anodal_lim-cathodal_lim;
Vox=0.6;
sampling_freq=10;   %10 hz sampling freq 
offset=0;

load([parameters.templatesrcdir parameters.PCR_template]);      %loads Ats_mat & Cts_mat
[index1,~]=find(Cts_mat~=0); index_da=find(index1==1); index_ph=find(index1==2);
Cts_mat_DAPH=Cts_mat(1:2,1:index_ph(end)); CV_mat_DA=Ats_mat(:,index_da); CV_mat_pH=Ats_mat(:,index_ph);

% resample template if different length than 175 
samplesPerScan = app.getSamplesPerScan();
if (length(Ats_mat) ~= samplesPerScan)
    Ats_mat = resampleCV(Ats_mat,length(Ats_mat), samplesPerScan);       
end


parameters.DAcvs=CV_mat_DA;
parameters.Cts=Cts_mat;
parameters.CV=Ats_mat;

%calculate PCR parameters from templates
[Vc, F, Aproj, Qa]=generatePCR(Ats_mat,Cts_mat);
[VcDAPH, FDAPH, AprojDAPH, QaDAPH]=generatePCR([CV_mat_DA CV_mat_pH],Cts_mat_DAPH);
K=pinv(F*transpose(Vc));        %na/uM, ideal CV's for each analyte

parameters.Vc=Vc;  parameters.F=F;    parameters.Aproj=Aproj;    
parameters.Qa=Qa;  parameters.QaDAPH=QaDAPH;  parameters.K=K;

%default info about fscv data based on templates
sizeData=size(Ats_mat); 
samplesperscan=sizeData(1); 
stepsizeCV=((vlim-vlim/samplesperscan)*2/samplesperscan);
Vrange=(cathodal_lim:stepsizeCV:(anodal_lim-vlim*2/samplesperscan))+offset;
Vrange_cathodal=(anodal_lim:-stepsizeCV:(cathodal_lim+vlim*2/samplesperscan))+offset;
if (length(Vrange)+length(Vrange_cathodal))<samplesperscan
    Vrange=[Vrange 1.3+offset];
    Vrange_cathodal=(anodal_lim:-stepsizeCV:(cathodal_lim+vlim*2/samplesperscan))+offset;
end
Voxid=find(Vrange<=Vox+0.01); Voxid=Voxid(end);
Voxid=length(Vrange_cathodal)+length(Vrange)-Voxid;

parameters.Voxid=Voxid;
parameters.Vrange=Vrange;
parameters.Vrange_cathodal=Vrange_cathodal;



parameters.LFPterm='.ncs';
parameters.includeMovementThres=1;          %include this threshold to remove singals
parameters.samplesperscan=samplesperscan;
parameters.samplerate=sampling_freq;

params=parameters;


end
