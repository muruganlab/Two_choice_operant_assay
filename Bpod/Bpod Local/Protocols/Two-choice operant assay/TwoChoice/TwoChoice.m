function TwoChoice
global BpodSystem S
%% Setup (runs once before the first trial)
st = dbstack;
functionName = st.name;
S = load(functionName);
dialogBoxSettingsFile;
BpodSystem.ProtocolSettings = S; % Creates a settings file chosen in launch manager into current workspace as a struct called 'S'dialogBoxSettingsFile;
currentTrialFig = [];
numTrialsWaterPokes = [];
numTrialsSocialReward = [];
numTrialsLateWaterReward = [];
BpodSystem.Status.Pause = 1;
HandlePauseCondition;
a = 0;
b = 100;
MaxTrials = 200;
OptoArray = (b-a).*rand(MaxTrials,1);
if BpodSystem.Status.BeingUsed == 1
    %Initial values
    GlobalTimeLimit = S.GUI.Settings.SessionLengthMins * 60;
    markersize = 5;
    color1 = '#ca0020';
    color2 = '#0571b0';
    color3 = '#404040';
    incrementVals=5;
    CurrentTrial = 0;
    MaxTrialLength = GlobalTimeLimit;
    thisFig = BpodSystem.GUIHandles.inProgressFig;
    delete(findall(thisFig,'Tag','Goback'));
    if(S.GUI.Basic.RecordingType==3)
        axs = axes(thisFig,'Position',[.15 .07 .7 .3]);
        posOfTitle = 0.3;
    else
        axs = axes(thisFig,'Position',[.15 .07 .7 .4]);
        posOfTitle = 0.4;
    end
    set(axs,'fontname',BpodSystem.GUIHandles.FontName);
    set(axs,'fontsize',BpodSystem.GUIHandles.fontsizeDB-2);
    annotation(thisFig,'textbox',[0.35, posOfTitle, 0.1, 0.1],'string',...
        "Trial progression in session",'EdgeColor','None',...
        'Color','k','FontSize',BpodSystem.GUIHandles.fontsizeDB-1,...
        'FontName',BpodSystem.GUIHandles.FontName,...
        'FontWeight','Bold');
    markerPlotWater = {};
    markerPlotLate = {};
    markerPlotSocial = {};
    %% Main loop (runs once per trial)
    while CurrentTrial <= MaxTrials
        %--- Typically, a block of code here will compute variables for assembling this trial's state machine
        if CurrentTrial == 0
            CurrentTrial = 1;
            xVal = incrementVals;
            yVal = incrementVals;
            InitialSessionTime = clock;
            InitialSessionTimeSecs = (InitialSessionTime(4)*3600) + (InitialSessionTime(5)*60) + InitialSessionTime(6);
            RemainingSessionTime = GlobalTimeLimit;
            if(S.GUI.Basic.RecordingType==3)
                S.GUI.Results.StimWaterPokes = 0;
                S.GUI.Results.StimLateWaterReward = 0;
                S.GUI.Results.StimSocialPoke = 0;
            end
            numTrialsWaterPokes = vertcat(numTrialsWaterPokes,S.GUI.Results.WaterPokes);
            numTrialsLateWaterReward = vertcat(numTrialsLateWaterReward,S.GUI.Results.LateWaterReward);
            numTrialsSocialReward = vertcat(numTrialsSocialReward,S.GUI.Results.SocialPoke);
            markerPlotWater = vertcat(markerPlotWater,"None");
            markerPlotLate = vertcat(markerPlotLate,"None");
            markerPlotSocial = vertcat(markerPlotSocial,"None");
        else
            if OptoArray(CurrentTrial) <= S.GUI.StimulationParameters.OptoTrialPercentage
                S.GUI.StimulationParameters.CurrentTrialStim = 1;
                annotation(thisFig,'textbox',[0.63, posOfTitle, 0.1, 0.1],'string',...
                    "Current trial : Stim trial",'EdgeColor','None',...
                    'Color','k','FontSize',BpodSystem.GUIHandles.fontsizeDB-1,'FontName',BpodSystem.GUIHandles.FontName,...
                    'FontWeight','Bold','Tag','toUpdate');
            else
                S.GUI.StimulationParameters.CurrentTrialStim = 0;
                if(S.GUI.Basic.RecordingType==3)
                    annotation(thisFig,'textbox',[0.63, posOfTitle, 0.1, 0.1],'string',...
                        "Current trial : Non-stim trial",'EdgeColor','None',...
                        'Color','k','FontSize',BpodSystem.GUIHandles.fontsizeDB-1,'FontName',BpodSystem.GUIHandles.FontName,...
                        'FontWeight','Bold','Tag','toUpdate');
                end
            end
            %Set valve opening time to deliver reward amount set in GUI
            ValveTimeSet = GetValveTimes(S.GUI.Settings.RewardAmountuL, [2 4]);
            socialPort = 'PWM3';
            sucrosePort = 'PWM1';
            if S.GUI.Settings.BpodChamber == 'Bpod1'
                ValveTime = ValveTimeSet(1);
                ValveUse = 'Valve2';
                PWMUse = 'PWM2';
                PortIn = 'Port2In';
            elseif S.GUI.Settings.BpodChamber == 'Bpod2'
                ValveTime = ValveTimeSet(2);
                ValveUse = 'Valve4';
                PWMUse = 'PWM4';
                PortIn = 'Port4In';
            end
            %--- Assemble state machine
            sma = NewStateMachine();
            %This is a timer tracking total session time left in order to end the
            %session, GlobalTimeLimit will be reduced each trial until it reaches 0
            sma = SetGlobalTimer(sma, 'TimerID', 1, 'Duration', RemainingSessionTime);
            
            if(S.GUI.Basic.RecordingType==3)
                if(S.GUI.StimulationParameters.StimulationFrequency==0)
                    S.GUI.StimulationParameters.OnDurationMS = S.GUI.StimulationParameters.MaxPulseDurationSecs;
                    S.GUI.StimulationParameters.MaxNumberOfPulses = 0;
                    S.GUI.StimulationParameters.WaveOffDurationMS = 0;
                else
                    wavePeriod = 1/S.GUI.StimulationParameters.StimulationFrequency;
                    S.GUI.StimulationParameters.WaveOffDurationMS = wavePeriod*1000 - S.GUI.StimulationParameters.OnDurationMS;
                    S.GUI.StimulationParameters.MaxNumberOfPulses = size(0:(S.GUI.StimulationParameters.WaveOffDurationMS+S.GUI.StimulationParameters.OnDurationMS)/1000:S.GUI.StimulationParameters.MaxPulseDurationSecs,2);
                end
                %If loop accounts for cases where LoopMode is set to 1 when
                %MaxNumberOfPulses = 1, in which GlobalTimer 2 will depend on a
                %GlobalTimerCancel 2 call to stop. Typically, when LoopMode > 1, The GlobalTimer
                %2 will stop by itself when Duration*LoopMode runs out
                
                %This is the timer functioning as the optogenetic waveform to pulse the
                %laser during Stim trials
                sma = SetGlobalTimer(sma, 'TimerID', 2, 'Duration', S.GUI.StimulationParameters.OnDurationMS/1000, ...
                    'OnsetDelay', 0, ...
                    'Channel', 'BNC2', ...
                    'OnsetValue', 1, 'OffsetValue', 0, ...
                    'LoopMode',  S.GUI.StimulationParameters.MaxNumberOfPulses, 'EventsEnabled', 1, 'LoopInterval', S.GUI.StimulationParameters.WaveOffDurationMS/1000);
            end
            %States are organized by the typical order they would appear in the
            %trial, although for the sake of programming, only the first outlined
            %state's order is necessary so as to determine the initial state
            
            %If this is the first trial, initial start state includes a flash to
            %indicate in the video recording the beginning of the session
            
            if CurrentTrial == 1
                sma = AddState(sma, 'Name', 'StartState', ...
                    'Timer', 0.5, ...
                    'StateChangeConditions', {'Tup', 'InitialStandby'}, ...
                    'OutputActions', {'GlobalTimerTrig', 1, 'PWM1', 255, 'PWM2', 255, 'PWM3', 255, 'PWM4', 255});
                sma = AddState(sma, 'Name', 'InitialStandby', ...
                    'Timer', 6.5, ...
                    'StateChangeConditions', {'Tup', 'EnforcePortClear', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {});
                %Update CurrentTrialStim in GUI for first trial, subsequent
                %updates are at the end of each trial/loop
            else
                sma = AddState(sma, 'Name', 'StartState', ...
                    'Timer', 0, ...
                    'StateChangeConditions', {'Tup', 'EnforcePortClear', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {'GlobalTimerTrig', 1});
            end
            
            if(S.GUI.StimulationParameters.CurrentTrialStim==1)
                sma = AddState(sma, 'Name', 'EnforcePortClear', ...
                    'Timer', 3, ...
                    'StateChangeConditions', {'Port1In', 'RefreshPortClear', 'Port3In', 'RefreshPortClear', 'Tup', 'PokePrimeStim', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {});
                sma = AddState(sma, 'Name', 'RefreshPortClear', ...
                    'Timer', 0, ...
                    'StateChangeConditions', {'Port1Out', 'EnforcePortClear', 'Port3Out', 'EnforcePortClear', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {});
                sma = AddState(sma, 'Name', 'PokePrimeStim', ...
                    'Timer', MaxTrialLength, ...
                    'StateChangeConditions', {'Tup', 'TrialEnd', 'Port1In', 'SuccessSignal1Stim', 'Port3In', 'SuccessSignalAStim', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {sucrosePort, 255,socialPort, 255});
            else
                sma = AddState(sma, 'Name', 'EnforcePortClear', ...
                    'Timer', 3, ...
                    'StateChangeConditions', {'Port1In', 'RefreshPortClear', 'Port3In', 'RefreshPortClear', 'Tup', 'PokePrimeNoStim', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {});
                sma = AddState(sma, 'Name', 'RefreshPortClear', ...
                    'Timer', 0, ...
                    'StateChangeConditions', {'Port1Out', 'EnforcePortClear', 'Port3Out', 'EnforcePortClear', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {});
                sma = AddState(sma, 'Name', 'PokePrimeNoStim', ...
                    'Timer', MaxTrialLength, ...
                    'StateChangeConditions', {'Tup', 'TrialEnd', 'Port1In',...
                    'SuccessSignal1', 'Port3In', 'SuccessSignalA',...
                    'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {sucrosePort,255,socialPort,255});
                if(S.GUI.Basic.RecordingType==2)
                    sma = EditState(sma,'PokePrimeNoStim','OutputActions', {'GlobalTimerTrig', 2});
                end
            end
            %SuccessSignals A-F and 1-6 rapidly flash LEDs off and on the chosen port to
            %indicate to the animal that they have initiated reward targets
            sma = AddState(sma, 'Name', 'SuccessSignal1Stim', ... %alternate version of SuccessSignal1 where opto is turned on after selection
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignal2', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {'GlobalTimerTrig', 2});
            tic;
            sma = AddState(sma, 'Name', 'SuccessSignal1', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignal2', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {'GlobalTimerCancel', 2});
            sma = AddState(sma, 'Name', 'SuccessSignal2', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignal3', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {sucrosePort, 255});
            sma = AddState(sma, 'Name', 'SuccessSignal3', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignal4', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {});
            sma = AddState(sma, 'Name', 'SuccessSignal4', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignal5', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {sucrosePort, 255});
            sma = AddState(sma, 'Name', 'SuccessSignal5', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignal6', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {});
            
            sma = AddState(sma, 'Name', 'SuccessSignal6', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'RewardIndicator', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {sucrosePort, 255});
            
            sma = AddState(sma, 'Name', 'SuccessSignalAStim', ... %alternate version of SuccessSignal1 where opto is turned on after selection
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignalA', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {'GlobalTimerTrig', 2});
            tic;
            sma = AddState(sma, 'Name', 'SuccessSignalA', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignalB', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {'GlobalTimerCancel', 2});
            sma = AddState(sma, 'Name', 'SuccessSignalB', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignalC', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {socialPort, 255});
            sma = AddState(sma, 'Name', 'SuccessSignalC', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignalD', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {});
            sma = AddState(sma, 'Name', 'SuccessSignalD', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignalE', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {socialPort, 255});
            sma = AddState(sma, 'Name', 'SuccessSignalE', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SuccessSignalF', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {});
            
            sma = AddState(sma, 'Name', 'SuccessSignalF', ...
                'Timer', 0.1, ...
                'StateChangeConditions', {'Tup', 'SocialReward', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {socialPort, 255});
            
            
            
            
            %RewardIndicator turns out the LED of a water reward port, that when
            %poked in time administers the water reward
            
            sma = AddState(sma, 'Name', 'RewardIndicator', ...
                'Timer', S.GUI.Settings.RewardTimeLimitSecs, ...
                'StateChangeConditions', {PortIn, 'Reward', 'Tup', 'WaterRewardFail', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {PWMUse, 255});
            if(S.GUI.StimulationParameters.CurrentTrialStim==1 && S.GUI.Basic.RecordingType==3)
                sma = AddState(sma, 'Name', 'Reward', ...
                    'Timer', ValveTime, ...
                    'StateChangeConditions', {'Tup', 'WaitPeriod', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {ValveUse, true, PWMUse, 255});
                sma = AddState(sma, 'Name', 'WaitPeriod', ... % Wait period so that we account for the speed of the mice drinking and dont rush into the standby mode just after it pokes
                    'Timer', S.GUI.StimulationParameters.MaxPulseDurationSecs, ...
                    'StateChangeConditions', {'Tup', 'Standby','GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {});
            else
                sma = AddState(sma, 'Name', 'Reward', ...
                    'Timer', ValveTime, ...
                    'StateChangeConditions', {'Tup', 'Standby', 'GlobalTimer1_End', 'SessionEnd'}, ...
                    'OutputActions', {ValveUse, true, PWMUse, 255});
            end
            sma = AddState(sma, 'Name', 'WaterRewardFail', ...
                'Timer', 0, ...
                'StateChangeConditions', {'Tup', 'Standby', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {});
            sma = AddState(sma, 'Name', 'SocialReward', ...
                'Timer', 1 + S.GUI.Settings.GateOpenTimeSecs, ...
                'StateChangeConditions', {'Tup', 'GateClosing', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {'BNCState', 1});
            sma = AddState(sma, 'Name', 'GateClosing', ...
                'Timer', 4, ...
                'StateChangeConditions', {'Tup', 'Standby', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {});
            
            %Standby occurs at the end of the trial to create an intertrial period
            sma = AddState(sma, 'Name', 'Standby', ...
                'Timer', S.GUI.Settings.TrialIntervalSecs, ...
                'StateChangeConditions', {'Tup', 'TrialEnd', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {});
            sma = AddState(sma, 'Name', 'TrialEnd', ...
                'Timer', 0, ...
                'StateChangeConditions', {'Tup', 'exit', 'GlobalTimer1_End', 'SessionEnd'}, ...
                'OutputActions', {});
            %Session end is signalled in the video recording by a flash of all LEDs
            sma = AddState(sma, 'Name', 'SessionEnd', ...
                'Timer', 0.5, ...
                'StateChangeConditions', {'Tup', 'exit'}, ...
                'OutputActions', {sucrosePort, 255, 'PWM2', 255, socialPort, 255, 'PWM4', 255});
            
            SendStateMatrix(sma); % Send state machine to the Bpod state machine device
            RawEvents = RunStateMatrix; % Run the trial and return events
            
            %--- Package and save the trial's data
            if ~isempty(fieldnames(RawEvents)) % If you didn't stop the session manually mid-trial
                BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents); % Adds raw events to a human-readable data struct
                BpodSystem.Data.TrialSettings(CurrentTrial) = S; % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
                %%BpodSystem.Data.Metadata =
                SaveBpodSessionData; % Saves the field BpodSystem.Data to the current data file
            end
            
            %--- This final block of code is necessary for the Bpod console's pause and stop buttons to work
            HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
            if BpodSystem.Status.BeingUsed == 0
                return
            end
            markerPlotWater = vertcat(markerPlotWater,"None");
            markerPlotLate = vertcat(markerPlotLate,"None");
            markerPlotSocial = vertcat(markerPlotSocial,"None");
            if(S.GUI.StimulationParameters.CurrentTrialStim==1 && S.GUI.Basic.RecordingType==3)
                if (~isnan(BpodSystem.Data.RawEvents.Trial{CurrentTrial}.States.WaterRewardFail(1)))
                    S.GUI.Results.StimLateWaterReward = S.GUI.Results.StimLateWaterReward + 1;
                    markerPlotLate(end) = "*";
                end
                if (~isnan(BpodSystem.Data.RawEvents.Trial{CurrentTrial}.States.Reward(1)))
                    S.GUI.Results.StimWaterPokes = S.GUI.Results.StimWaterPokes + 1;
                    markerPlotWater(end) = "*";
                end
                if (~isnan(BpodSystem.Data.RawEvents.Trial{CurrentTrial}.States.SocialReward(1)))
                    S.GUI.Results.StimSocialPoke = S.GUI.Results.StimSocialPoke + 1;
                    markerPlotSocial(end) = "*";
                end
            else
                if (~isnan(BpodSystem.Data.RawEvents.Trial{CurrentTrial}.States.WaterRewardFail(1)))
                    S.GUI.Results.LateWaterReward = S.GUI.Results.LateWaterReward + 1;
                    markerPlotLate(end) = "o";
                end
                if (~isnan(BpodSystem.Data.RawEvents.Trial{CurrentTrial}.States.Reward(1)))
                    S.GUI.Results.WaterPokes = S.GUI.Results.WaterPokes + 1;
                    markerPlotWater(end) = "o";
                end
                if (~isnan(BpodSystem.Data.RawEvents.Trial{CurrentTrial}.States.SocialReward(1)))
                    S.GUI.Results.SocialPoke = S.GUI.Results.SocialPoke + 1;
                    markerPlotSocial(end) = "o";
                end
            end
            if(S.GUI.Basic.RecordingType==3)
                numTrialsLateWaterReward = vertcat(numTrialsLateWaterReward,S.GUI.Results.LateWaterReward+S.GUI.Results.StimLateWaterReward);
                numTrialsWaterPokes = vertcat(numTrialsWaterPokes,S.GUI.Results.WaterPokes+S.GUI.Results.StimWaterPokes);
                numTrialsSocialReward = vertcat(numTrialsSocialReward,S.GUI.Results.SocialPoke+S.GUI.Results.StimSocialPoke);
            else
                numTrialsLateWaterReward = vertcat(numTrialsLateWaterReward,S.GUI.Results.LateWaterReward);
                numTrialsWaterPokes = vertcat(numTrialsWaterPokes,S.GUI.Results.WaterPokes);
                numTrialsSocialReward = vertcat(numTrialsSocialReward,S.GUI.Results.SocialPoke);
            end
            CurrentTrial = CurrentTrial + 1;
            S.GUI.Results.CurrentTrialNumber = CurrentTrial;
            %Checks time after trial and compares to starting time to update
            %RemainingSessionTime
            CurrentTrialTime = clock;
            CurrentTrialTimeSecs = (CurrentTrialTime(4)*3600) + (CurrentTrialTime(5)*60) + CurrentTrialTime(6);
            TimePassedDuringSession = CurrentTrialTimeSecs - InitialSessionTimeSecs;
            RemainingSessionTime = GlobalTimeLimit - TimePassedDuringSession;
            if RemainingSessionTime <= 0
                savefig(BpodSystem.Path.CurrentDataFileFig);
                saveas(thisFig,BpodSystem.Path.CurrentDataFileFig(1:end-4),'png');
                break
            end
        end
        currentTrialFig = vertcat(currentTrialFig,CurrentTrial-1);
        stair1 = stairs(axs,currentTrialFig,numTrialsWaterPokes,...
            'Linestyle','-','Color',color2);
        hold(axs,'on');
        stair2 = stairs(axs,currentTrialFig,numTrialsLateWaterReward,...
            'Linestyle','-','Color',color3);
        hold(axs,'on');
        stair3 = stairs(axs,currentTrialFig,numTrialsSocialReward,...
            'Linestyle','-','Color',color1);
        hold(axs,'on');
        for count=1:length(currentTrialFig)
            scatter(axs,currentTrialFig(count),numTrialsWaterPokes(count),markersize+40,'MarkerFaceColor',color2,...
                'MarkerEdgeColor',color2,'Marker',markerPlotWater(count),'HandleVisibility','off');
            hold(axs,'on');
            scatter(axs,currentTrialFig(count),numTrialsLateWaterReward(count),markersize+40,'MarkerFaceColor',color3,...
                'MarkerEdgeColor',color3,'Marker',markerPlotLate(count),'HandleVisibility','off');
            hold(axs,'on');
            scatter(axs,currentTrialFig(count),numTrialsSocialReward(count),markersize+40,'MarkerFaceColor',color1,...
                'MarkerEdgeColor',color1,'Marker',markerPlotSocial(count),'HandleVisibility','off');
            hold(axs,'on');
        end
        axP = get(axs,'Position');
        legend(axs,'hide');
        legend(axs,[stair1,stair2,stair3],"Successful Water Pokes",...
            "Late Water Reward","Social Reward",'FontName',...
            BpodSystem.GUIHandles.FontName,'Location',...
            'northeastoutside','FontSize',axs.XLabel.FontSize-1);
        legend(axs,'boxoff');
        refreshdata(axs);
        drawnow;
        box(axs,'off');
        axP(1) = 0.07;
        set(axs, 'Position', axP)
        if(mod(CurrentTrial,incrementVals)==0)
            maxValue = max(max([numTrialsWaterPokes,numTrialsSocialReward,numTrialsLateWaterReward]));
            xVal = CurrentTrial+incrementVals;
            yVal = maxValue+incrementVals;
        end
        xlim(axs,[0,xVal]);
        ylim(axs,[0,yVal]);
        x_ticks = floor(0):ceil(xVal);
        y_ticks = floor(0):ceil(yVal);
        if(CurrentTrial>=20)
            x_ticks = floor(0):incrementVals:ceil(xVal);
            y_ticks = floor(0):incrementVals:ceil(yVal);
        end
        set(axs, 'XTick', x_ticks);
        set(axs, 'YTick', y_ticks);
        xtickformat(axs, '%d');
        ytickformat(axs, '%d');
        xlabel(axs,'Trial Number','FontName',...
            BpodSystem.GUIHandles.FontName,'FontWeight','Bold');
        ylabel(axs,'Cumulative sum of trials','FontName',...
            BpodSystem.GUIHandles.FontName,'FontWeight','Bold');
        delete(findall(thisFig,'Tag','toUpdate'));
        annotation(thisFig,'textbox',[0.33,0.81, 0.1, 0.1],'string',...
            "Time remaining in session : ~"+...
            round(RemainingSessionTime/60)+" mins",...
            'EdgeColor','None','Color','k','FontSize',...
            BpodSystem.GUIHandles.fontsizeDB-1,'FontName',BpodSystem.GUIHandles.FontName,...
            'FontWeight','Bold','Tag','toUpdate');
        startYval = 0.7;
        x1Val = 0.58;
        x2Val = 0.8;
        allResults = fieldnames(S.GUI.Results);
        numOfResults = length(allResults);
        for curr=1:numOfResults
            currResults = allResults{curr};
            currResultsVal = S.GUI.Results.(currResults);
            annotation(thisFig,'textbox',[x1Val,startYval, 0.1, 0.1],'string',...
                currResults,'EdgeColor','None','Color','k','FontSize',...
                BpodSystem.GUIHandles.fontsizeDB-3,'Tag','toUpdate');
            annotation(thisFig,'textbox',[x2Val,startYval, 0.1, 0.1],'string',...
                currResultsVal,'Color','k','FontSize',...
                BpodSystem.GUIHandles.fontsizeDB-3,'FitBoxToText','on',...
                'Tag','toUpdate');
            startYval = startYval-0.04;
        end
    end
end