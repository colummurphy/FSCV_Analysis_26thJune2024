function plotxbehmultsess(xinfos,binfos,plotparam,varargin)
%2/17/2019 pre, now updated xinfos so not arrayed by sess num, all in one
%chart
argnum=1;
datype='dapos';
evts={};
sestypes={};
while argnum<=length(varargin)
    switch varargin{argnum}
        case 'daneg'
            datype='daneg';
        case 'dareb'
            datype='dareb';
        case 'daall'
            datype='daall';
        case 'evts'
            argnum=argnum+1;
            evts=varargin{argnum};
        case 'sestypes'
            %if "reward', then big and small reward
            argnum=argnum+1;
            sestypes=varargin{argnum};           
    end
    argnum=argnum+1;
end
fontsize=9;
savepath=plotparam.savepath;
savepath=[savepath(1:end-1) 'beh' filesep];
        if ~isdir(savepath)
            mkdir(savepath);
        end
sessnums=plotparam.sessnums;
trialgrps=plotparam.trialgrps;
trialinfo=trialgrps(1).trialinfo;
lfpchs=plotparam.lfpchs;
%get lfp ch groups p & c
pgroup=find(contains(lfpchs,'p')==1);
cgroup=find(contains(lfpchs,'c')==1);
targdasites=plotparam.dasites;
figpos=[50,50,1400,900];
figsess=figure('position',figpos,'color',[1 1 1]);
set(0,'CurrentFigure',figsess);    %set figure handle to current figure
axa={};

binfo=binfos;
xinfo=xinfos;
eventrows={xinfo(1:end).event};
eventtypes=unique(eventrows);
if ~isempty(evts)
    eventtypes=evts;
end
sessionrows={xinfo(1:end).sessiontype};
sessiontypes=unique({xinfo(1:end).sessiontype});
if ~isempty(sestypes)
    sessiontypes=sestypes;
    if strcmp(sestypes{1},'reward')
        savepath=[savepath(1:end-1) 'rew' filesep];
        if ~isdir(savepath)
            mkdir(savepath);
        end
    end
end
params={'damax','damaxts','damin','damints','dafallts','darisets',...
    'lfpmax','lfpmaxts','lfpmin','lfpmints','lfprisets','lfpfallts',...
    'lfppostmax','lfppostmaxts'};
params_mag={'damax','damin',...
    'lfpmax','lfpmin','lfppostmax','zlagcoef'};
params_xcov={'maxprelagts',...
    'minprelagts','maxpostlagts','minpostlagts','maxprecoef',...
    'minprecoef','maxpostcoef','minpostcoef'};
params_timing_damax={'delt_lfpmin_damax','delt_lfprise_damax',...
    'delt_lfppostmax_damax','lfppostmaxts','damaxts','lfpmints'}; 

params=[params_mag params_timing_damax];   
ygrp={};
ynam={};
ygrp{1}=params_mag;
ygrp{2}=params_xcov;
ygrp{3}=params_timing_damax;
%ygrp{4}=params_timing_darise;
%ygrp{5}=params_timing_dafall;
%ygrp{6}=params_timing_damin;

ynam{1}='mag';
ynam{2}='xcov';
ynam{3}='timing_damax';
%ynam{4}='timing_darise';
%ynam{5}='timing_dafall';
%ynam{6}='timing_damin';

%bparams={'fix_rt','target_lrt','target_rrt','eyed','leyed','reyed',...
 %   'pulse','lickpre','lickpost'};
bparams=unique({binfo(1:end).sitelfp});
bparamtarg='lfpmax';    %get max amp of phys sig within targ period
axpos={};
axsiz=[750,320];
axoff=100;
mark=[0 .1 .9; 0 .5 .3; 0 .9 .1];
mark=[.7 0 0; 0.6 0 .7; 0 .7 .1];
mark=[0 0.1 .7; 0.8 0 .5; 0 .7 0;.7 0 0; 0.4 0 .7];

markr=[1 .5 .0; .3 .3 0; .9 .1 0];
typeoff=[-0.3 -0.15 0];
sessmark={'.','+','o','^','s','*','v','p','h','x'};
sessmarktxt={'.','+','o','\delta','sq','*','\nabla','p','h','x'};
sessmark={'o','sq','o','^','+','v','*','p','h','x','d','<','>','o','sq','o','^','+','v','*','p','h','x','d','<','>'};
sessmarktxt={'.',' sq','o','\Delta','+','\nabla','*','p','h','x','d','<','>','.',' sq','o','\Delta','+','\nabla','*','p','h','x','d','<','>'};
marksize=[50 200 150 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 50 200 150 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200];
cmapp=[1 .5 0;1 .55 0; 1 .6 0; 1 .65 0; 1 .7 0; 1 .75 0; 1 .8 0; 1 .85 0; 1 .9 0];
cmapc=[1 .5 0;1 .55 0; 1 .6 0; 1 .65 0; 1 .7 0; 1 .75 0; 1 .8 0; 1 .85 0; 1 .9 0];
cmap2=cool;
cmap1=hot;
markc=cmap1(1:5:end,:);
markp=cmap2(1:5:end,:);

%scroll da-lfp pairs, separate figures

%scroll sess type big/small/targ, separate axes

%scroll sess's, same ax, diff color
for ida=1:length(targdasites)
    %each da separate subplot  
    lfpsites={};
    daregion=contains(targdasites(ida),'c');     %1=='c'
    if daregion==1
        lfpsites=lfpchs(cgroup);
    else
        lfpsites=lfpchs(pgroup);
    end
for ilfp=1:length(lfpsites)    
for ievent=1:length(eventtypes)
for yid=1:length(ygrp)    
    %timing/magnitudes/xcov parameters to plot in diff figs    
    clf(figsess,'reset');
    set(figsess,'color',[1 1 1]);
    trialtypes=trialinfo(1); %get trial groups for session
    axpos={};
    xlines=[2 4 6 8];
    for ip=1:4
        axa{ip}=subplot(2,2,ip);   hold(axa{ip},'on');
        set(axa{ip},'units','pixels');
        axis('square')         
        set(axa{ip},'ytick',1:length(ygrp{yid}));
        set(axa{ip},'yticklabel',ygrp{yid});
        set(axa{ip},'ylim',[0 length(ygrp{yid})+.5]);
        set(axa{ip},'TickLabelInterpreter','none');
        set(axa{ip},'xtick',1:length(bparams));
        set(axa{ip},'xticklabel',bparams);
        set(axa{ip},'xlim',[0 length(bparams)+.5]);
        set(axa{ip},'xTickLabelRotation',90)
        axpos{ip}=get(axa{ip},'position');
        for iline=1:min(length(bparams),length(ygrp{yid}))
        aa=plot(axa{ip},[iline iline], ...
            [0 length(ygrp{yid})],'linewidth',1,'color',[0 0 0]);
        aa.Color(4)=.2;
        aa=plot(axa{ip},[0 length(bparams)], ...
            [iline iline],'linewidth',1,'color',[0 0 0]);
        aa.Color(4)=.2;
        end    
    end    
    labels={};
    titletext=[eventtypes{ievent} ' | ' targdasites{ida} ' x ' lfpsites{ilfp}];  
    set(axa{1},'units','pixels')
    text(axa{1},-30,axpos{1}(4)+30,titletext,'units','pixels','fontweight','bold');
    %set legend
    labelx={};
    for xleg=1:length(sessnums)
        labelx{xleg}=[num2str(sessnums(xleg))];  
        text(axa{1},100+xleg*50,axpos{1}(4)+30,labelx{xleg},'units','pixels','fontweight','bold','color',[0 0 0]);
    end
    curgrp=ygrp{yid};
    count=1;
    cc=1;
    cors={};
    plotdata=[];    
    sesslab=[];
    ransess={};     %random jitter for each sess
    for iran=1:length(sessnums)       
        ransess{iran}=rand(1,1)*.75;
    end
for itype=1:length(sessiontypes)
%separate ax big/small/targ
text(axa{itype},-100,axpos{itype}(4)+20,sessiontypes{itype},'units','pixels','fontweight','bold','color',[0 0 0]);

for ises=1:length(sessnums)
%same ax diff sessnums
targrow=find((contains({xinfo.siteda},targdasites(ida)) & ...
    contains({xinfo.sitelfp},lfpsites(ilfp)) & ...
    strcmp({xinfo.event},eventtypes(ievent))) & ...
    contains({xinfo.sessionid},num2str(sessnums(ises))) &...
    contains({xinfo.sessiontype},sessiontypes(itype))==1);
if ~isempty(targrow)

xdata=getfield(xinfo(targrow),datype);    %'dapos' or 'daneg' types
%trial ids for this data group for all/phase1/phase4..
trialtypes=trialgrps(ises).trialinfo(itype); %get trial groups for session

for iy=1:length(curgrp)
%scroll parameters for group (ie. all timing variables)
%curytrials=getfield(xdata,'trials');        %trial nums for cur y variable
%curydata=getfield(xdata,curgrp{iy});       %y data
%for 'reward', both big and small sess types
curydata=[];
curytrials=[];
tidx=0;
for iitype=1:length(targrow)
    xdata=getfield(xinfo(targrow(iitype)),datype);
    curydata=[curydata getfield(xdata,curgrp{iy})];
    curytrials=[curytrials tidx+getfield(xdata,'trials')];
    tidx=tidx+1000;
end
    for ib=1:length(bparams)
    %scroll b params (x var)
    %curbrow=find(strcmp({curbdata.sitelfp},bparams{ib}));
    %curbedata=getfield(curbdata(curbrow),datype);
    %curxdata=getfield(curbedata,bparamtarg);
    %for 'reward', both big and small sess types
    curxdata=[];
    curxtrials=[];
    tidx=0;
    targb=find(contains({binfo.siteda},targdasites(ida)) & ...
    (contains({binfo.sessiontype},sessiontypes(itype)) &...
    strcmp({binfo.event},eventtypes(ievent)))==1 & ...
    contains({binfo.sessionid},num2str(sessnums(ises))) &...
    strcmp({binfo.sitelfp},bparams{ib})==1);
    for iitype=1:length(targb)
        curbdata=binfo(targb(iitype));
        curbedata=getfield(curbdata,datype);
        curx=getfield(curbedata,bparamtarg);
        curxtrials=[curxtrials tidx+getfield(curbedata,'trials')];
        curxdata=[curxdata curx];
        tidx=tidx+1000;
    end
    %curxdata=getfield(curbdata,bparams{ib});
    xcordata=[];
    ycordata=[];
    if ~isempty(curxdata)       
        if length(curxdata)==length(curxtrials)
        xtrialsiny=find(ismember(curytrials,curxtrials)==1);
        ycordata=curydata(xtrialsiny);
        ytrialsinx=find(ismember(curxtrials,curytrials)==1);
        xcordata=curxdata(ytrialsinx);
        end
    end
    cors=setfield(cors,{cc},'ydata',ycordata);
    cors=setfield(cors,{cc},'yvar',curgrp{iy});
    cors=setfield(cors,{cc},bparams{ib},xcordata);
    cors=setfield(cors,{cc},'sessiontype',sessiontypes(itype));
    cors=setfield(cors,{cc},'event',eventtypes(ievent));
    cors=setfield(cors,{cc},'session',sessnums(ises));
    cors=setfield(cors,{cc},'seltrials',intersect(curxtrials,curytrials));        
    rcor=[];
    pcor=[];
    if ~isempty(ycordata) && ~isempty(xcordata)
        [rcor,pcor]=corr(xcordata',ycordata','rows','complete');
    end
    cors=setfield(cors,{cc},'rcor',rcor);
    cors=setfield(cors,{cc},'pcor',pcor);

    %plot if sig (p<=0.05)
    if pcor<=0.05
        m='+';
        c=mark(ises,:);
        fsize=40*log10(1/pcor);
        if rcor<0
            m='o';
        end
        a=scatter(axa{itype},ib-ransess{ises},iy-ransess{ises},...
            fsize,m,'markeredgecolor',c,'MarkerEdgeAlpha',.5,'linewidth',1.5);
    end
    cc=cc+1;
    end
end
end
end
end
        
save([savepath 'behcor_' ynam{yid} '_' datype '_'  eventtypes{ievent} ...
    '_' targdasites{ida} 'x' lfpsites{ilfp}],'cors');
savefig(figsess,[savepath 'behcor_' ynam{yid} '_' datype '_' eventtypes{ievent} '_' targdasites{ida} 'x' lfpsites{ilfp}]);
saveas(figsess,[savepath 'behcor_' ynam{yid} '_' datype '_' eventtypes{ievent} '_' targdasites{ida} 'x' lfpsites{ilfp}],'tif')
delete(findall(figsess,'type','text')) 
   
end
end
end
end

end