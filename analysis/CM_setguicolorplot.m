function [] = CM_setguicolorplot(app, axPlot,cData,plotnum, ...
                        allColorPlots, colorMap, colorScale)
global plotParam parameters


%{
  Input Parameters

  axPlot = hgui.hfig{chX}               Color plot handle
  cData = processed.Isub(chX).data      Channel data after filtering
                                        and background subtraction
  plotnum = chX                         Channel number 
  Note: chX = 1 or 2 or 3 or 4.  

  Function is run for each channel (1 to 4);   

  plotParam.map (233 * 3)
  Create a custom colormap by defining a three-column 
  matrix of values between 0.0 and 1.0. 
  Each row defines a three-element RGB triplet.

  Color map (plotParam.map) is assigned in getplotsettings.m
  Calculated in setColorScale.m
  [plotParam.map, plotParam.cmin]=setColorScale(plotParam.cmax);

%}

% default font size
fontsize=12;

% firstplot = 1
firstplot=plotParam.firstplot;

% if channel data is available
if ~isempty(cData)
    
    % fontsize = 8
    fontsize=plotParam.fontsize;   
    
    % events = events table
    % First column contains the eventsToDisplay (vertical columns).
    % Remaining columns contain the time indexes (1-601) of those events
    events=plotParam.events;
    
    % default sampling_freq = 10
    sampling_freq=10;
    
    % parameters has a 'samplingrate' = 10, 
    if isfield(parameters,'samplingFreq')
        sampling_freq=parameters.samplingFreq;
    end
    
    % t_start = 1, t_end = 601, overritten below
    t_end=plotParam.t_end;
    t_start=plotParam.t_start;
    
    %ignore plotParam, define data size by t_start t_end before
    %inputting to this script now
    
    % t_start = 1, t_end = 601 (no change)
    t_start=1;
    t_end=size(cData,2);

    % set the color map for the plot
    colormap(axPlot,colorMap);

    % axPlot - handle to our current plot
    % Set the colormap for the axPlot figure to cMap
    if firstplot
        
        % toggle plotParam.firstplot = 0 after it is run with the first
        % channel
        plotParam.firstplot=0;
    end
    
    % 1 < 1, False, t_start=1 (no change)
    if t_start<1
        t_start=1;
    end


    % 601 > 601, False
    if t_end>size(cData,2)
        image(axPlot,cData(:,(t_start:size(cData,2))),'cdatamapping','scaled')

    % True, run this one    
    else
        % Displays the data in cData as an image.
        % Each element of cData specifies the color for 1 pixel of the image.
        % image is an m-by-n grid of pixels,(m = num rows, n = num cols of cData)
        % 
        % Scale the values to the full range of the current colormap
        % i.e. Use the full range of colors
        
        % image(fig/subplot, dataMatrix, 'name', 'value')
        image(axPlot,cData(:,(t_start:t_end)),'cdatamapping','scaled')
    end
    
    
    % Set the color limits (clim) for the plot 
    % cScale = [-0.6667, 1]
    % ax.CLim(1) - color bar bottom value. 
    % ax.Clim(2) - color bar top value.
    % 'clim' automatically computed from the range of the data being plotted.
    % Setting 'clim' changes the way the color is scaled from the data values.
    set(axPlot,'clim', colorScale)


    % True for channel 1
    % plot the events onto the color plot
    if plotnum==1
        
        % if events table is not empty, True
        if ~isempty(events)
            % Copy of events
            % First column contains the eventsToDisplay (vertical column).
            % Remaining columns contain the time indexes (1-601) of those
            % events.
            events2=events;
            
            % Subtract start from the time indices of the events
            events2(:,2:end)=events(:,2:end)-t_start;
            
            % Event time indices, with 1 subtracted, 
            % eventsToDisplay column removed.
            events3=events2(:,2:end);
            
            % row + column indices of non-zero values
            % searches col 1 first then, col 2, ...
            [rowEvent,colEvent]=find(events3 >= 0);
            

            % clear events data
            cla(app.EventsAxes);

            app.EventsAxes.XLim = [0 size(cData,2)]; % set limit of axes
            app.EventsAxes.YLim = [0 2];             % set limit of axes
            numEvents = size(rowEvent,1);
            disp(strcat('number of events: ', num2str(numEvents)));
            
            eventPosY = 0;              % initialize y position

            for i = 1 : numEvents
                
                if (eventPosY >= 1.6)
                    eventPosY = 0.4;  
                else
                    eventPosY = eventPosY + 0.4; 
                end  

                event = events(rowEvent(i),1);
                timeSlot = events3(rowEvent(i), colEvent(i));
            
                text(app.EventsAxes, timeSlot, eventPosY, num2str(event), ...
                'HorizontalAlignment', 'center');
            end 
        end
    end
 

    % plot event data for 16 channel system
    if ((plotnum == 1) && (app.getNumOfChannels() == 16))

        % clear events data
        cla(app.EventsAxes);

        % plot event data
        CM_plotEventData(app);
    end

    
    % show time labels (x-axis) for the last plot
    showTimeLabels = false;
    if (plotnum == 1 & showTimeLabels)     
        lastColorPlotIndex = app.getLastColorPlotIndex();
        lastColorPlot = allColorPlots(lastColorPlotIndex);
        
        firstTickIndex = 1;
        lastTickIndex = size(cData,2);
        firstTimeLabel = 0;
        lastTimeLabel = lastTickIndex / sampling_freq;

        lastColorPlot.XTick = [firstTickIndex, lastTickIndex];
        lastColorPlot.XTickLabel = num2str([firstTimeLabel; lastTimeLabel]);
    end

    % Add yticks to color plots
    ysize=size(cData,1);
    set(axPlot,'ytick',[1; floor(ysize/2); ysize],'tickdir','out');

    if (app.getNumOfChannels() == 4)
        
        anodalLimit = "+1.3";
        cathodalLimit = "-0.4";
        axPlot.YTickLabel = [cathodalLimit; anodalLimit; cathodalLimit];
    else

        anodalLimit = app.getAnodalLimitText();
        cathodalLimit = app.getCathodalLimitText();
        axPlot.YTickLabel = [cathodalLimit; anodalLimit; cathodalLimit];
    end    

end
    
    colorBarAxes = app.getColorBarAxes();
    % colormap(colorBarAxes, plotParam.map);
    colormap(colorBarAxes, colorMap);
    set(colorBarAxes,'clim', colorScale)
    colorbar(colorBarAxes, 'Location', 'eastoutside');

    set(axPlot,'box','off')
    set(axPlot,'ycolor',[0 0 0]);    
    set(findall(axPlot,'-property','FontSize'),'FontSize',fontsize)

end
