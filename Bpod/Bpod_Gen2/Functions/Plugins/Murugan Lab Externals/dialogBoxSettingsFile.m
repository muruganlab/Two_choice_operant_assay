function dialogBoxSettingsFile
global BpodSystem S
%%
BpodSystem.ProtocolSettings = S;
%--- Define parameters
%%
screenSize = get(0,'ScreenSize');
ratioBox = [4,2];
additionalHeight=50;
[~,S.chosenDialogBoxSize,S.postionOfDialogBox,S.resolutionOfEachTick] = getScreenParamters(screenSize,ratioBox,additionalHeight);
BpodSystem.GUIHandles.ProtocolParameters = figure('Position',[S.postionOfDialogBox(1) S.postionOfDialogBox(2) S.chosenDialogBoxSize(1) S.chosenDialogBoxSize(2)+50],'name','Protocol Parameters','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
S.screenSize = screenSize;
set(gcf,'color','w');
ha = axes('units','normalized','position',[0 0 1 1]);
xlim([0,1]);
ylim([0,1]);
uistack(gca,'bottom');
axis off;
lmYpos = 0.95;
S.figureName = [BpodSystem.GUIData.ProtocolName,'.png'];
S.labLogo = imread(S.figureName);
resizeLogo = imresize(S.labLogo,[screenSize(3),screenSize(4)]);
startYVal = 0.57;
steps = 0.053;
if(strcmp(S.figureName,'TwoChoice.png'))
    image('XData',[0.21,0.79],'YData',[0.9,0.6],'CData',resizeLogo);
    text(0.32,startYVal-steps*8,'Social reward settings', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
    text(0.1,startYVal-steps*9,'Social gate open time (secs)', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
    BpodSystem.GUIHandles.GateOpenTimeSecs = uicontrol('Style', 'edit','Position', [6.7*S.resolutionOfEachTick(1) 0.75*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1) 0.37*S.resolutionOfEachTick(2)], 'String' ,'20', 'Callback', @getGateOpenTimeSecs, 'FontWeight', 'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4);
else
    image('XData',[0.35,0.65],'YData',[0.9,0.6],'CData',resizeLogo);
end
panelTitle = text(0.505,lmYpos,'Protocol parameters', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB, 'FontWeight','Bold', 'Color', [0 0 0]);
line([0.1 0.9], [lmYpos-0.02 lmYpos-0.02], 'Color', [0 0 0], 'LineWidth', 1);
set(panelTitle,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
text(0.39,startYVal,'Basic settings', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
text(0.1,startYVal-steps*1,'Choose recoding type', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
text(0.1,startYVal-steps*2,'Choose Bpod', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold','Color', [0 0 0]);
text(0.1,startYVal-steps*3,'Inter-trial interval (secs)', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
text(0.1,startYVal-steps*4,'Duration of behavior (mins)', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
text(0.33,startYVal-steps*5,'Sucrose reward settings', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
if(strcmp(S.figureName,'Operant.png'))
    text(0.1,startYVal-steps*6,'Reward indicator (secs)', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
else
    text(0.1,startYVal-steps*6,'Maximum reward latency (secs)', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);
end
text(0.1,startYVal-steps*7,'Sucrose reward amount (uL)', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold', 'Color', [0 0 0]);

BpodSystem.GUIHandles.RecordingType = uicontrol('Style', 'popupmenu','Position',[6.7*S.resolutionOfEachTick(1) 5.19*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)] , 'String', {'Behavior', 'Imaging','Opto'},'Callback',@getRecordingType, 'FontWeight', 'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4);
set(BpodSystem.GUIHandles.RecordingType,'Value',S.GUI.Basic.RecordingType);
BpodSystem.GUIHandles.BpodSelector = uicontrol('Style', 'popupmenu','Position',[6.7*S.resolutionOfEachTick(1) 4.6*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)] , 'String', {'Bpod1', 'Bpod2'}, 'Callback',@getBpodChamber, 'FontWeight', 'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4);
set(BpodSystem.GUIHandles.BpodSelector,'Value',S.GUI.Basic.BpodChamberNum);
BpodSystem.GUIHandles.ITI = uicontrol('Style', 'edit','Position', [6.7*S.resolutionOfEachTick(1) 4.17*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1) 0.37*S.resolutionOfEachTick(2)], 'String', '15','Callback',@getITI, 'FontWeight', 'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4);
set(BpodSystem.GUIHandles.ITI,'String',S.GUI.Settings.TrialIntervalSecs);
BpodSystem.GUIHandles.SessionLengthMins = uicontrol('Style', 'edit','Position', [6.7*S.resolutionOfEachTick(1) 3.62*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1) 0.37*S.resolutionOfEachTick(2)], 'String', '60','Callback',@getSessionLengthMins, 'FontWeight', 'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4);
set(BpodSystem.GUIHandles.SessionLengthMins,'String',S.GUI.Settings.SessionLengthMins);

BpodSystem.GUIHandles.RewardLatency = uicontrol('Style', 'edit','Position', [6.7*S.resolutionOfEachTick(1) 2.42*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1) 0.37*S.resolutionOfEachTick(2)], 'String', '8','Callback',@getRewardLatency, 'FontWeight', 'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4);
if(strcmp(S.figureName,'Operant.png'))
    set(BpodSystem.GUIHandles.RewardLatency,'String',S.GUI.Settings.RewardIndicatorSecs);    
else
    set(BpodSystem.GUIHandles.RewardLatency,'String',S.GUI.Settings.RewardTimeLimitSecs);
end
BpodSystem.GUIHandles.RewardAmountuL = uicontrol('Style', 'edit','Position', [6.7*S.resolutionOfEachTick(1) 1.87*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1) 0.37*S.resolutionOfEachTick(2)], 'String', '10','Callback',@getRewardAmountuL, 'FontWeight', 'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4);
set(BpodSystem.GUIHandles.RewardAmountuL,'String',S.GUI.Settings.RewardAmountuL);
BpodSystem.GUIHandles.NextButton = uicontrol('Position', [7.8*S.resolutionOfEachTick(1) 0.2*S.resolutionOfEachTick(2) 1.9*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)], 'Style', 'pushbutton', 'String', ['Next ' char(187)], 'Callback',@OptoImgCheck,'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB-1,'TooltipString', 'Launch Protocol','FontWeight','Bold', 'BackgroundColor', [1 1 1], 'ForegroundColor', [0,0,0]);
BpodSystem.GUIHandles.BackButton = uicontrol('Position', [0.3*S.resolutionOfEachTick(1) 0.2*S.resolutionOfEachTick(2) 1.9*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)], 'Style', 'pushbutton', 'String', [char(171) ' Back'], 'Callback',@GoBack,'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB-1,'TooltipString', 'Go back!','FontWeight','Bold', 'BackgroundColor', [1 1 1], 'ForegroundColor', [0,0,0]);
function GoBack(a,b)
global BpodSystem S
close(BpodSystem.GUIHandles.ProtocolParameters);
NewLaunchManager_Edited

function OptoImgCheck(a,b)
global BpodSystem S
close(BpodSystem.GUIHandles.ProtocolParameters);
if(S.GUI.Basic.RecordingType==3)
    PresetStimPath = fullfile(BpodSystem.Path.BpodRoot, '\Functions\Plugins\Murugan Lab Externals\Settings Files\Stimulation Files','*.mat');
    matFiles = dir(PresetStimPath);
    [~,S.GUI.StimulationfileName,~] = fileparts({matFiles.name});
    StimulationSettingsFile = load(S.GUI.StimulationfileName{1});
    S = getFlatStruct(S,StimulationSettingsFile);
    commandText = ['    ',S.GUI.StimulationfileName];
    BpodSystem.GUIHandles.OptoParameters = figure('Position',[S.postionOfDialogBox(1) S.postionOfDialogBox(2) S.chosenDialogBoxSize(1) S.chosenDialogBoxSize(2)],'name','Protocol Parameters','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
    set(gcf,'color','w');
    ha = axes('units','normalized','position',[0 0 1 1]);
    xlim([0,1]);
    ylim([0,1]);
    uistack(gca,'bottom');
    axis off;
    lmYpos = 0.95;
    resizeLogo = imresize(S.labLogo,[S.screenSize(3),S.screenSize(4)]);
    if(strcmp(S.figureName,'TwoChoice.png'))
        image('XData',[0.23,0.75],'YData',[0.9,0.6],'CData',resizeLogo);
    else
        image('XData',[0.33,0.63],'YData',[0.9,0.6],'CData',resizeLogo);
    end
    th = text(0.5,lmYpos,'Optogenetic Manipulation Parameters', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB, 'FontWeight','Bold', 'Color', [0 0 0]);
    line([0.1 0.9], [lmYpos-0.02 lmYpos-0.02], 'Color', [0 0 0], 'LineWidth', 1);
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle')
    text(0.1,0.55,'Preset stim condition', 'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB,'FontWeight','Bold','Color', [0 0 0]);
    BpodSystem.GUIHandles.PresetStimCondition = uicontrol('Style', 'popupmenu','Position',[5.5*S.resolutionOfEachTick(1) 5.15*S.resolutionOfEachTick(2) 3.5*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)] ,'Callback',@getPresetStimCondition, 'String',commandText, 'TooltipString','Choose from dropdown menu:','FontWeight', 'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4); 
    BpodSystem.GUIHandles.BackButton = uicontrol('Position', [0.3*S.resolutionOfEachTick(1) 0.3*S.resolutionOfEachTick(2) 1.9*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)], 'Style', 'pushbutton', 'String', [char(171) ' Back'], 'Callback',@GoBackOpto,'FontName', BpodSystem.GUIHandles.FontName, 'FontSize', BpodSystem.GUIHandles.fontsizeDB-1,'TooltipString', 'Go back!','FontWeight','Bold', 'BackgroundColor', [1 1 1], 'ForegroundColor', [0,0,0]);

elseif(S.GUI.Basic.RecordingType==2)
    S.GUI.OnDurationMS = 100000; %Duration in milliseconds that the timer is on (turns on laser)
    S.GUI.WaveOffDurationMS = 0; %Duration in milliseconds that the timer is off (turns off laser)
    S.GUI.MaxPulseDurationSecs = S.GUI.Settings.SessionLengthMins*60; %Maximum duration this on-off cycling can occur for the PokePrimeStim state, after which PokePrimePostStim occurs
    S.GUI.OptoTrialPercentage = 0;
    closeDialogBox;
else
    S.GUI.StimulationParameters.OptoTrialPercentage = 0;
    closeDialogBox;
end

function getRecordingType(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.RecordingType, 'Value');
GUIVal = get(BpodSystem.GUIHandles.RecordingType, 'String');
S.GUI.Basic.RecordingType = GUIParam;
S.GUI.Basic.RecordingTypeName = GUIVal{GUIParam};

function getBpodChamber(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.BpodSelector, 'Value');
GUIVal = get(BpodSystem.GUIHandles.BpodSelector, 'String');
S.GUI.Basic.BpodChamberNum = GUIParam;
S.GUI.Settings.BpodChamber = GUIVal{GUIParam};

function getRewardLatency(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.RewardLatency, 'String');
if(strcmp(S.figureName,'Operant.png'))
    S.GUI.Settings.RewardIndicatorSecs = str2num(GUIParam);
else
    S.GUI.Settings.RewardTimeLimitSecs = str2num(GUIParam);
end

function getITI(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.ITI, 'String');
S.GUI.Settings.TrialIntervalSecs = str2num(GUIParam);

function getRewardAmountuL(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.RewardAmountuL, 'String');
S.GUI.Settings.RewardAmountuL = str2num(GUIParam);

function getSessionLengthMins(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.SessionLengthMins, 'String');
S.GUI.Settings.SessionLengthMins = str2num(GUIParam);

function getGateOpenTimeSecs(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.GateOpenTimeSecs, 'String');
S.GUI.Settings.GateOpenTimeSecs = str2num(GUIParam);

function GoBackOpto(a,b)
global BpodSystem S
close(BpodSystem.GUIHandles.OptoParameters);
dialogBoxSettingsFile;

function GoBackDialog(a,b)
global BpodSystem S
close(BpodSystem.GUIHandles.inProgressFig);
dialogBoxSettingsFile;   

function getOnDurationMS(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.OnDurationMS, 'String');
S.GUI.StimulationParameters.OnDurationMS = str2num(GUIParam);

function getStimulationFrequency(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.OnDurationMS, 'String');
S.GUI.StimulationParameters.StimulationFrequency = str2num(GUIParam);

function getMaxPulseDurationSecs(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.MaxPulseDurationSecs, 'String');
S.GUI.StimulationParameters.MaxPulseDurationSecs = str2num(GUIParam);

function getOptoTrialPercentage(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.OptoTrialPercentage, 'String');
S.GUI.StimulationParameters.OptoTrialPercentage = str2num(GUIParam);

function getPresetStimCondition(a,b)
global BpodSystem S
GUIParam = get(BpodSystem.GUIHandles.PresetStimCondition, 'Value');
if(GUIParam>1)
    StimulationSettingsFile = load(S.GUI.StimulationfileName{GUIParam-1});    
    S = getFlatStruct(S,StimulationSettingsFile);        
    text(0.1,0.35,'Opto trial percentage', 'FontName', ...
    BpodSystem.GUIHandles.FontName, 'FontSize', ...
    BpodSystem.GUIHandles.fontsizeDB,'FontWeight',...
    'Bold', 'Color', [0 0 0],'Tag','OptoPar');
    BpodSystem.GUIHandles.OptoTrialPercentage = uicontrol('Style', ...
        'edit','Position',...
        [6.2*S.resolutionOfEachTick(1) 3.23*S.resolutionOfEachTick(2) ...
        2*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)],...
        'Callback',@getOptoTrialPercentage, 'String',...
        S.GUI.StimulationParameters.OptoTrialPercentage,...
        'FontWeight', 'bold', 'FontSize',...
        BpodSystem.GUIHandles.fontsizeDB-4,'Tag','OptoPar');
    set(BpodSystem.GUIHandles.OptoTrialPercentage,'Value',...
        S.GUI.StimulationParameters.OptoTrialPercentage);
    text(0.1,0.45,'Max pulse duration (secs)', 'FontName',...
        BpodSystem.GUIHandles.FontName, 'FontSize',...
        BpodSystem.GUIHandles.fontsizeDB,'FontWeight',...
        'Bold', 'Color', [0 0 0],'Tag','OptoPar');
    BpodSystem.GUIHandles.MaxPulseDurationSecs = uicontrol('Style',...
        'edit','Position', [6.2*S.resolutionOfEachTick(1) ...
        4.23*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1)...
        0.5*S.resolutionOfEachTick(2)],'Callback',...
        @getMaxPulseDurationSecs, 'String',...
        S.GUI.StimulationParameters.MaxPulseDurationSecs,...
        'FontWeight', 'bold', 'FontSize',...
        BpodSystem.GUIHandles.fontsizeDB-4,'Tag','OptoPar');
    if(GUIParam~=3)
        text(0.1,0.15,'On duration (ms)', 'FontName',...
            BpodSystem.GUIHandles.FontName, 'FontSize',...
            BpodSystem.GUIHandles.fontsizeDB,'FontWeight',...
            'Bold','Color', [0 0 0],'Tag','OnText');
        BpodSystem.GUIHandles.OnDurationMS = uicontrol('Style', 'edit',...
            'Position',[6.2*S.resolutionOfEachTick(1)...
            1.23*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1)...
            0.5*S.resolutionOfEachTick(2)] ,'Callback',@getOnDurationMS,...
            'String',S.GUI.StimulationParameters.OnDurationMS,...
            'FontWeight', 'bold', 'FontSize',...
            BpodSystem.GUIHandles.fontsizeDB-4,'Tag','OptoPar');
    else
        delete(BpodSystem.GUIHandles.OnDurationMS);
        delete(findall(gcf,'Tag','OnText'));
    end
    text(0.1,0.25,'Stimulation frequency (hz)', 'FontName', ...
        BpodSystem.GUIHandles.FontName, 'FontSize', ...
        BpodSystem.GUIHandles.fontsizeDB,'FontWeight',...
        'Bold', 'Color', [0 0 0],'Tag','OptoPar');
    BpodSystem.GUIHandles.StimulationFrequency = uicontrol('Style',...
        'edit','Position',[6.2*S.resolutionOfEachTick(1) ...
        2.23*S.resolutionOfEachTick(2) 2*S.resolutionOfEachTick(1) ...
        0.5*S.resolutionOfEachTick(2)] ,'Callback', ...
        @getStimulationFrequency, 'String',...
        S.GUI.StimulationParameters.StimulationFrequency, 'FontWeight',...
        'bold', 'FontSize', BpodSystem.GUIHandles.fontsizeDB-4,...
        'Tag','OptoPar');
    BpodSystem.GUIHandles.NextButton = uicontrol('Position', ...
        [7.8*S.resolutionOfEachTick(1) 0.3*S.resolutionOfEachTick(2)...
        2*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)],...
        'Style', 'pushbutton', 'String', ['Next ' char(187)],...
        'Callback',@closeDialogBox,'FontName',...
        BpodSystem.GUIHandles.FontName, 'FontSize',...
        BpodSystem.GUIHandles.fontsizeDB-1,'TooltipString',...
        'Launch Protocol','FontWeight','Bold', 'BackgroundColor',...
        [1 1 1], 'ForegroundColor', [0,0,0],'Tag','OptoPar');
else
    delete(findall(gcf,'Tag','OptoPar'));
    delete(findall(gcf,'Tag','OnText'));
end

function closeDialogBox(a,b)
global BpodSystem S
if(S.GUI.Basic.RecordingType==3)
    close(BpodSystem.GUIHandles.OptoParameters);
end
%Figure to confirm settings or go back and change some
ratioBox = [2.5,1.2];
[~,chosenDialogBoxSize,postionOfDialogBox,~] = getScreenParamters(S.screenSize,ratioBox);
BpodSystem.GUIHandles.inProgressFig = figure('Position',[postionOfDialogBox(1)+200 postionOfDialogBox(2) chosenDialogBoxSize(1) chosenDialogBoxSize(2)],'name','Running progress','numbertitle','off');%,'MenuBar', 'none', 'Resize', 'off');
thisFig = BpodSystem.GUIHandles.inProgressFig;
set(gcf,'color','w');
axis('off');
titleString = ["Subject: "+BpodSystem.GUIData.SubjectName+" , Protocol: "+BpodSystem.GUIData.ProtocolName+" , Recoding type: "+S.GUI.Basic.RecordingTypeName];
annotation(thisFig,'line', [0.02, 0.02], [0.02, 0.98], 'LineWidth', 1, 'Color', 'k');
annotation(thisFig,'line', [0.98, 0.98], [0.02, 0.98], 'LineWidth', 1, 'Color', 'k');
annotation(thisFig,'line', [0.02, 0.98], [0.02, 0.02], 'LineWidth', 1, 'Color', 'k');
annotation(thisFig,'line', [0.98, 0.02], [0.98, 0.98], 'LineWidth', 1, 'Color', 'k'); hold on;
annotation(thisFig,'textbox',[0.1,0.75,0.1,0.1],'string','Recording settings','EdgeColor','None','Color','k','FontSize',...
    BpodSystem.GUIHandles.fontsizeDB-1,'FontName',BpodSystem.GUIHandles.FontName,...
    'FontWeight','Bold');
annotation(thisFig,'textbox',[0.63,0.75,0.1,0.1],'string','In-progress results','EdgeColor','None','Color','k','FontSize',...
    BpodSystem.GUIHandles.fontsizeDB-1,'FontName',BpodSystem.GUIHandles.FontName,...
    'FontWeight','Bold');
annotationBox = annotation(thisFig,'textbox',[0.5,0.88, 0.1, 0.1],'string',...
    titleString,'EdgeColor','None','Color','k','FontSize',...
    BpodSystem.GUIHandles.fontsizeDB, 'FontWeight','Bold','Interpreter',...
    'tex',...
    'HorizontalAlignment', 'center', ...  
    'VerticalAlignment', 'middle', ...    
    'FitBoxToText', 'on');
pos = annotationBox.Position;
newX = 0.5 - pos(3) / 2; 
annotationBox.Position = [newX, pos(2), pos(3), pos(4)];
annotation(thisFig,'textbox',[0.33,0.81, 0.1, 0.1],'string',...
    "Time remaining in session: ~"+...
    round(S.GUI.Settings.SessionLengthMins)+" mins",...
    'EdgeColor','None','Color','k','FontSize',...
    BpodSystem.GUIHandles.fontsizeDB-1,'FontName',BpodSystem.GUIHandles.FontName,...
    'FontWeight','Bold','Tag','toUpdate');
allSettings = fieldnames(S.GUI.Settings);
numOfSettings = length(allSettings);
startYval = 0.7;
x1Val = 0.07;
x2Val = 0.26;
for curr=1:numOfSettings
    currSetting = allSettings{curr};
    currSettingVal = S.GUI.Settings.(currSetting);
    annotation(thisFig,'textbox',[x1Val,startYval, 0.1, 0.1],'string',...
        currSetting,'EdgeColor','None','Color','k','FontSize',...
        BpodSystem.GUIHandles.fontsizeDB-3);
    annotation(thisFig,'textbox',[x2Val,startYval, 0.1, 0.1],'string',...
        currSettingVal,'Color','k','FontSize',...
        BpodSystem.GUIHandles.fontsizeDB-3,'FitBoxToText','on');
    startYval = startYval-0.04;
end
if(S.GUI.Basic.RecordingType==3)
    allSettings = fieldnames(S.GUI.StimulationParameters);
    numOfSettings = length(allSettings);
    for curr=[numOfSettings:-1:2]
        currSetting = allSettings{curr};
        currSettingVal = S.GUI.StimulationParameters.(currSetting);
        annotation(thisFig,'textbox',[x1Val,startYval, 0.1, 0.1],'string',...
            currSetting,'EdgeColor','None','Color','k','FontSize',...
            BpodSystem.GUIHandles.fontsizeDB-3);
        annotation(thisFig,'textbox',[x2Val,startYval, 0.1, 0.1],'string',...
            currSettingVal,'Color','k','FontSize',...
            BpodSystem.GUIHandles.fontsizeDB-3,'FitBoxToText','on');
        startYval = startYval-0.04;
    end
end

BpodSystem.GUIHandles.BackButton = uicontrol('Position', ...
    [0.35*S.resolutionOfEachTick(1) 0.35*S.resolutionOfEachTick(2) ...
    1.9*S.resolutionOfEachTick(1) 0.5*S.resolutionOfEachTick(2)], ...
    'Style', 'pushbutton', 'String', [char(171) ' Back'], ...
    'Callback',@GoBackDialog,'FontName', BpodSystem.GUIHandles.FontName,...
    'FontSize', BpodSystem.GUIHandles.fontsizeDB-1,'TooltipString',...
    'Go back!','FontWeight','Bold', 'BackgroundColor', [1 1 1],...
    'ForegroundColor', [0,0,0],'Tag','Goback');
BpodSystem.Status.BeingUsed = 1;
BpodSystem.Status.SessionStartFlag = 1;
BpodSystem.ProtocolStartTime = now*100000;
BpodSystem.resetSessionClock();
BpodSystem.GUIHandles.inProgressFig = thisFig;
return


function [fontsizeDB,chosenDialogBoxSize,postionOfDialogBox,resolutionOfEachTick] = getScreenParamters(screenSize,ratioBox,additionalHeight)
if(~exist('additionalHeight','var'))
    additionalHeight=0;
end
fontsizeDB = round(screenSize(3)/150);
centrePoints = [screenSize(3)/2 screenSize(4)/2];
chosenDialogBoxSize = [screenSize(3)/ratioBox(1)  screenSize(4)/ratioBox(2)+additionalHeight];
postionOfDialogBox = [centrePoints(1)-(chosenDialogBoxSize(1)/2) centrePoints(2)-(chosenDialogBoxSize(2)/2)];
resolutionOfEachTick = [chosenDialogBoxSize(1)/10 chosenDialogBoxSize(2)/10];

function S = getFlatStruct(S,StimulationSettingsFile)
nameOfStruct = fieldnames(StimulationSettingsFile);
nameOfStruct = nameOfStruct{1,1};
S.GUI.(nameOfStruct) = StimulationSettingsFile.(nameOfStruct);
preSetStim = S.GUI.(nameOfStruct).PresetStimCondition;
if preSetStim>1
    S.GUI.(nameOfStruct).StimulationfileName = S.GUI.StimulationfileName{preSetStim-1};
else
    S.GUI.(nameOfStruct).StimulationfileName = S.GUI.StimulationfileName{1};
end
