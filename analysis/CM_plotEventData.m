function [] = CM_plotEventData(app)

  cla(app.EventsAxes);

  % get events array
  eventsData = app.getEventData();
  displayEvents = app.getDisplayEvents();
  scanFrequency = app.getScanFrequency16Ch();
  fileLengthInSecs = app.getFileLengthInSecs();
  eventColIndex = 1;
  timeSlotColIndex = 4;

  % eventSlotLimit = 600 - 10 slots per second
  eventSlotLimit = fileLengthInSecs .* scanFrequency;                   
  app.EventsAxes.XLim = [0 eventSlotLimit];     % set limit of axes
  app.EventsAxes.YLim = [0 2];                  % set limit of axes
 
  [numEvents, ~] = size(eventsData);  
  disp(strcat('number of events: ', num2str(numEvents)));

  eventPosY = 0;                    % initialize y position
  
  for i = 1 : numEvents
    event = eventsData(i, eventColIndex);
    
    if (eventPosY >= 1.6)
        eventPosY = 0.4;  
    else
        eventPosY = eventPosY + 0.4; 
    end    

    if (ismember(event, displayEvents))
      timeSlot = eventsData(i, timeSlotColIndex);

      text(app.EventsAxes, timeSlot, eventPosY, num2str(event), ...
      'HorizontalAlignment', 'center');
    end
  end 
end