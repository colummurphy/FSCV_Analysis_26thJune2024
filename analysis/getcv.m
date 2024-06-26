function cvdata=getcv(Isub,parameters,plotParam)   
Vrange=[parameters.Vrange parameters.Vrange_cathodal];


% assignin('base', 'paramVrange', parameters.Vrange);
% assignin('base', 'paramVrangeCath', parameters.Vrange_cathodal);
% assignin('base', 'Vrange', Vrange);

xsel=plotParam.xsel;
CVavg=plotParam.CVavg;
xiCV=xsel-round(CVavg/2);
xeCV=xsel+round(CVavg/2);
if xiCV<1
    xiCV=1;
end
if xeCV>size(Isub,2)
    xeCV=size(Isub,2)
end
CVvectors=Isub(:,xiCV:xeCV); %average 5 time points taken
CVavgi=mean(CVvectors,2); 

ysize=size(Isub,1);

% assignin('base', 'ysize', ysize);



Irange_anodal=CVavgi(1:round(ysize/2));
Irange_cathodal=CVavgi(round(ysize/2+1):round(ysize));
Vrange_min_ind=find(Irange_anodal==min(Irange_anodal));

% assignin('base', 'Irange_anodal', Irange_anodal);
% assignin('base', 'Irange_cathodal', Irange_cathodal);
% assignin('base', 'Vrange_min_ind', Vrange_min_ind);

Vrange_min=Vrange(Vrange_min_ind);
Vrange_max_ind=find(Irange_cathodal==max(Irange_cathodal));
Irange_max=Irange_cathodal(Vrange_max_ind);
cvdata=[Irange_anodal; Irange_cathodal];
end