%Patra map pinout CSC channels to electrode names
%PCR_srcdir='C:\Users\putamen\Documents\Matlab\fscv\analysis\pcr_templates\';
%05/2022 Add all possible event id's for each event (e.g. ig reward should
%be 18, 19 or 45) especially because 18 or 19 usually comes before 45 when
%it does appear [18 = reward start, 19= reward end, 45 = reward cue with
%delay] see 1dr_helen_biased.c in cleo folder and encodes_helen.h

% CM - Use relative path
% PCR_srcdir=fullfile('Users','colum','Documents','MATLAB','fscv','analysis','pcr_templates');
% PCR_srcdir=[PCR_srcdir filesep];

% get current path and filename
pathAndFile = mfilename('fullpath');

% find the indexes of the file seperators in the path
% sepIndex = strfind(pathAndFile, ("/"|"\") );
sepIndex = [strfind(pathAndFile, '/'), strfind(pathAndFile, '\')];

% get path to pcr_templates
analysisFolderPath = pathAndFile(1 : sepIndex(end-1));
PCR_srcdir = [analysisFolderPath 'pcr_templates' filesep];

PCR_template='patra_clean_mscaledred_da_ph_m_bg.mat';     %2/9/2019, scaled m Cts coeff to match second hump rather than domiannt m hump, reduced # of M components to > 16 to 9 or 10


% left - CSC channels
% right - electrode/site names

csc_map={
    '2'     'p1' ...
    '3'     'p2' ...
    '4'     'p3' ...
    '203'   'p1-p2'...
    '204'   'p1-p3' ...
    '304'   'p2-p3' ...
    '5'     'p5' ...
    '405'   'p3-p5' ...
    '305'   'p2-p5' ...
    '205'   'p1-p5'...
    '7'     'pm3' ...
    '8'     'pl1' ...
    '9'     'pl2' ...
    '809'   'pl1-pl2'...
    '802'   'pl1-p1' ...    
    '803'   'pl1-p2'...
    '804'   'pl1-p3'...
    '902'   'pl2-p1'...
    '903'   'pl2-p2'...
    '904'   'pl2-p3'...
    '805'   'pl1-p5'...
    '905'   'pl2-p5'...
    '10'    'pl3'   ...
    '9010'  'pl2-pl3'...
    '8010'  'pl1-pl3'...
    '9010'  'p5-pl3'...
    '4010'        'p3-pl3'...
    '3010'        'p2-pl3'...
    '2010'        'p1-pl3'...
    '11'        'cl1'   ...
    '12'        'cl3'   ...
    '11012'     'cl1-cl3' ...
    '12014'     'cl3-cl4'   ...
    '14'        'cl4'   ...
    '11014'    'cl1-cl4'   ...
    '15'        'cl5'       ...
    '14015'    'cl4-cl5'   ...      
    '11015'     'cl1-cl5'...
    '12015'     'cl3-cl5'   ...
    '23'        'g3'    ...
    '24'        'g2'    ...
    '25'        'g1'    ...
    '26'        'cl6'   ...
    '14026'     'cl4-cl6'   ...
    '15026'     'cl5-cl6'   ...  
    '12026'     'cl3-cl6'...
    '27'    's6'    ...
    '28'    's5'    ...
    '27028'    's6-s5'   ...
    '29'    's4'    ...
    '28029'    's5-s4'   ...
    '29030'     's4-s3' ...
    '30'    's3'    ...
    '31'    's2'    ...
    '30031'    's3-s2'   ...
    '32'    's1'    ... 
    '31032' 's2-s1' ...
    '33'    'eyed'   ...
    '34'    'eyex'  ...
    '35'    'eyey'  ...
    '37'    'oldlick'   ...
    '38'    'oldlick2'   ...
    '39'    'lickx' ...
    '40'    'licky' ...
    '41'    'lickz' ...
    '42'    'pulse' ...
    };
%{
%Pre 2022, sort of misleading as 18/19 can come before 45 
event_codes={
    '4'     'display_fix' ...
    '5'     'start_fix' ...
    '6'     'break_fix' ...
    '10'    'display_target' ...
    '11'    'start_target'  ...
    '12'    'break_target'  ...
    '14'    'error' ...
    '29'    'left_condition'    ...
    '30'    'right_condition'   ...
    '45'    'reward_big'    ...
    '46'    'reward_small'  ...
    };
%}
eventcodes={
    '4'     'display_fix' ...
    '5'     'start_fix' ...
    '6'     'break_fix' ...
    '10'    'display_target' ...
    '11'    'start_target'  ...
    '12'    'break_target'  ...
    '14'    'error' ...
    '29'    'left_condition'    ...
    '30'    'right_condition'   ...
    '45'    'reward_big'    ...
    '18'    'reward_big'...
    '19'    'reward_big'...
    '46'    'reward_small'  ...
    '22'    'reward_small'...
    '23'    'reward_small'...
    };
%07/27/2018 - found out left-condition/right_condition not proper fix spot
%on, need to use "display_fix" instead

%error_trial means fixation break, target fixation break, or something else
%ie # error > fix or target breaks
%but error < fix + target breaks + no enter trials (37)
%# correct trials (ie. id = 13) = = # 45 + #46
%however if we calculate total  trials based on #3 start trial cue) - successful
%trials(#13), get # error trials (14)
%If use #4 (fixspot on) as indicating total trials then this is equal to
%#37 (no enter) + #13 (correct) + #14 (error)
%29 & 30 presented at same as 4 NOO


if exist('sessionnum','var')
    if sessionnum>=137 && sessionnum<=146
        csc_map={
        '2'     'p1' ...
        '3'     'p2' ...
        '4'     'p3' ...
        '203'   'p1-p2'...
        '204'   'p1-p3' ...
        '304'   'p2-p3' ...
        '5'     'p4' ...
        '405'   'p3-p4' ...
        '305'   'p2-p4' ...
        '205'   'p1-p4'...
        '5023'  'p4-p6'...
        '4023'  'p3-p6'...
        '23'     'p6' ...
        '8'     'pl1' ...
        '9'     'pl2' ...
        '809'   'pl1-pl2'...
        '802'   'pl1-p1' ...
        '902'   'pl2-p1'...
        '805'   'pl1-p4'...
        '905'   'pl2-p4'...
        '10'    'pl3'   ...
        '9010'  'pl2-pl3'...
        '8010'  'pl1-pl3'...
        '3010'        'p2-pl3'...
        '2010'        'p1-pl3'...
        '11'    'cl1'   ...
        '12'    'cl3'   ...
        '12014' 'cl3-cl4'   ...
        '14'    'cl4'   ...
        '11014'    'cl1-cl4'   ...
        '15'    'cl5'       ...
        '14015'    'cl4-cl5'   ...      
        '11015'     'cl1-cl5'...
        '12015' 'cl3-cl5'   ...
        '24'    'g2'    ...
        '25'    'g1'    ...
        '26'    'cl6'   ...
        '14026' 'cl4-cl6'   ...
        '15026'    'cl5-cl6'   ...  
        '12026'     'cl3-cl6'...
        '27'    's6'    ...
        '28'    's5'    ...
        '27028'    's6-s5'   ...
        '29'    's4'    ...
        '28029'    's5-s4'   ...
        '29030'     's4-s3' ...
        '30'    's3'    ...
        '31'    's2'    ...
        '30031'    's3-s2'   ...
        '32'    's1'    ... 
        '31032' 's2-s1' ...
        '33'    'eyed'   ...
        '34'    'eyex'  ...
        '35'    'eyey'  ...
        '37'    'oldlick'   ...
        '38'    'oldlick2'   ...
        '39'    'lickx' ...
        '40'    'licky' ...
        '41'    'lickz' ...
        '42'    'pulse' ...
        };

    end
    if sessionnum>=147 && sessionnum<=151
        csc_map={
        '2'     'p1' ...
        '3'     'p2' ...
        '4'     'p3' ...
        '203'   'p1-p2'...
        '204'   'p1-p3' ...
        '304'   'p2-p3' ...
        '5'     'p4' ...
        '405'   'p3-p4' ...
        '305'   'p2-p4' ...
        '205'   'p1-p4'...
        '507'   'p4-p6'...
        '407'   'p3-p6'...        
        '7'     'p6' ...
        '8'     'pl1' ...
        '9'     'pl2' ...
        '809'   'pl1-pl2'...
        '802'   'pl1-p1' ...
        '902'   'pl2-p1'...
        '805'   'pl1-p4'...
        '905'   'pl2-p4'...
        '10'    'pl3'   ...
        '9010'  'pl2-pl3'...
        '8010'  'pl1-pl3'...
        '3010'        'p2-pl3'...
        '2010'        'p1-pl3'...
        '11'    'cl1'   ...
        '12'    'cl3'   ...
        '12014' 'cl3-cl4'   ...
        '14'    'cl4'   ...
        '11014'    'cl1-cl4'   ...
        '15'    'cl5'       ...
        '14015'    'cl4-cl5'   ...      
        '11015'     'cl1-cl5'...
                '12015' 'cl3-cl5'   ...
        '24'    'g2'    ...
        '25'    'g1'    ...
        '26'    'cl6'   ...
        '14026' 'cl4-cl6'   ...
        '15026'    'cl5-cl6'   ...  
        '12026'     'cl3-cl6'...
        '27'    's6'    ...
        '28'    's5'    ...
        '27028'    's6-s5'   ...
        '29'    's4'    ...
        '28029'    's5-s4'   ...
        '29030'     's4-s3' ...
        '30'    's3'    ...
        '31'    's2'    ...
        '30031'    's3-s2'   ...
        '32'    's1'    ... 
        '31032' 's2-s1' ...
        '33'    'eyed'   ...
        '34'    'eyex'  ...
        '35'    'eyey'  ...
        '37'    'oldlick'   ...
        '38'    'oldlick2'   ...
        '39'    'lickx' ...
        '40'    'licky' ...
        '41'    'lickz' ...
        '42'    'pulse' ...
        };

    end 
    if sessionnum>=174 
        %pm3 p6 connection differs
        csc_map={
    '2'     'p1' ...
    '3'     'p2' ...
    '4'     'p3' ...
    '203'   'p1-p2'...
    '204'   'p1-p3' ...
    '304'   'p2-p3' ...
    '5'     'p5' ...
    '405'   'p3-p5' ...
    '305'   'p2-p5' ...
    '205'   'p1-p5'...
    '7'     'p6' ...
    '8'     'pl1' ...
    '9'     'pl2' ...
    '809'   'pl1-pl2'...
    '802'   'pl1-p1' ...    
    '803'   'pl1-p2'...
    '804'   'pl1-p3'...
    '902'   'pl2-p1'...
    '903'   'pl2-p2'...
    '904'   'pl2-p3'...
    '805'   'pl1-p5'...
    '905'   'pl2-p5'...
    '10'    'pm3'   ...
    '9010'  'pl2-pm3'...
    '8010'  'pl1-pm3'...
    '4010'        'p3-pm3'...
    '3010'        'p2-pm3'...
    '2010'        'p1-pm3'...
    '5010'          'p5-pm3'...
    '507'           'p5-p6'...
    '407'       'p3-p6'...
    '11'        'cl1'   ...
    '12'        'cl3'   ...
    '11012'     'cl1-cl3' ...
    '12014'     'cl3-cl4'   ...
    '14'        'cl4'   ...
    '11014'    'cl1-cl4'   ...
    '15'        'cl5'       ...
    '14015'    'cl4-cl5'   ...      
    '11015'     'cl1-cl5'...
    '12015'     'cl3-cl5'   ...
    '23'        'g3'    ...
    '24'        'g2'    ...
    '25'        'g1'    ...
    '26'        'cl6'   ...
    '14026'     'cl4-cl6'   ...
    '15026'     'cl5-cl6'   ...  
    '12026'     'cl3-cl6'...
    '27'    's6'    ...
    '28'    's5'    ...
    '27028'    's6-s5'   ...
    '29'    's4'    ...
    '28029'    's5-s4'   ...
    '29030'     's4-s3' ...
    '30'    's3'    ...
    '31'    's2'    ...
    '30031'    's3-s2'   ...
    '32'    's1'    ... 
    '31032' 's2-s1' ...
    '33'    'eyed'   ...
    '34'    'eyex'  ...
    '35'    'eyey'  ...
    '37'    'oldlick'   ...
    '38'    'oldlick2'   ...
    '39'    'lickx' ...
    '40'    'licky' ...
    '41'    'lickz' ...
    '42'    'pulse' ...
    };
    end
end
