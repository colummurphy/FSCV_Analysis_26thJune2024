function filtered = CM_filterDisplay(app, samplesperscan, fc, data)
 

imageFilter = app.getImageFilter();

samplesperscan = size(data,1);

if (strcmp(imageFilter, "Gaussian"))
    disp('Gaussian Filter');

    % samplesperscan=size(data,1);

    switch samplesperscan
        case 175
            %ff = fspecial('gaussian', [2.5 2], 1);
            if exist('imgaussfilt')>0
                    %if is function, not function  in Matlab 2013 and earlier
                    %versions                
                filtered = imgaussfilt(data,[2 .75]);             %fo r 4 channel %changed from 2 to 3.5 08/14/2017
             
            else
                sigy=2.5;
                sigx=1;
                %sizey=2*ceil(2*sigy)+1;
                %sizex=2*ceil(2*sigx)+1;
                sizey=20;
                sizex=7;
                sig=(sizey-1)/2;
                ff = fspecial('gaussian', [sizey sizex], 2);    
                filtered = filter2(ff, data);
            end
        case 500
            filtered = imgaussfilt(data,[8 2]);         %for 2 channel %changed from 10 08/16/2017
        case 1000
            filtered = imgaussfilt(data,[16 2]);  %changed from 20 08/16/2017 for 1 channel
        otherwise
            % original code
            filtered = imgaussfilt(data,[2 .75]);       %default%changed 08/14/2017 %changed from 4 08/16/2017, for rodent, 214 samples
    end


elseif (strcmp(imageFilter, "Low Pass"))
    
    
    disp('Low Pass Filter');
    
    % sampling frequency for 4 channel system
    if (app.getNumOfChannels() == 4)
        if samplesperscan == 175
            fs = 20490;
        elseif samplesperscan == 500
            fs = 58820;
        end    

    % sampling frequency for 16 channel system    
    % default - 25KHz
    % updates on new file read
    else
        fs = app.getSampleFrequency();
    end    
        
    fc = 2000;          % cut-off frequency (Hz)
    n_order = 2;        % equivalent to 4th order, filtfilt doubles order

    % butterworth - create filter coefficients
    [b, a] = butter(n_order, fc/(fs/2));  


    % New Code    
    [samplesPerScan, numberOfScans] = size(data);
    filtered = zeros(samplesPerScan, numberOfScans);

    for i = 1 : numberOfScans
      % get a scan + flip so first sample at top
      oneScan = flipud(data(:, i));

      % apply filter to data, need zero phase filtering - filtfilt
      filteredScan = filtfilt(b, a, oneScan);

      % re-flip filtered scan
      filtered(:, i) = flipud(filteredScan);
    end


else 

    disp('Filter Off');
    filtered=data;
end    

end