function [arrtsBhv] = fcnVidAcqV3_Main
    
    global Gui
    global Dsp
    global Ctr
    global Daq
    global vidNeur
    global vidBhv
        
    Ctr.Neur = 1;
    Ctr.NeurBlckCurrFrm = 1;
    Ctr.NeurBlckFrms = 1000;
    Ctr.NeurUpdate = 1;
    Ctr.NeurUpdateIntvl = 1;
    Ctr.NeurFlgSav = 0;
    
    Ctr.Bhv = 1;
    Ctr.BhvBlckCurrFrm = 1;
    Ctr.BhvBlckFrms = 1000;
    Ctr.BhvUpdate = 1;
    Ctr.BhvUpdateIntvl = 1;
    Ctr.BhvFlgSav = 0;
    
    Daq.vFlgLedPwr = 0;
    Daq.vLedPct = 0;
    Daq.vLedVlt = 5;
    
    Ctr.FlgLogging = 0;    
    Ctr.clockset = 0;
    Ctr.MainTime = clock;
%     
% %     % Kelton settings for Ximea sensor
%     % NOTE!  run matlab software AFTER plugging in camera.
%     Gui.vCamNeurInit = 2;   % for Ximea; make sure that sensor ID is listed
%     Gui.vCamBehavInit = 1;  % for microsoft webcam (Kelton)    
    
%     % Kevin settings for UCLA sensor
%     % NOTE!  run matlab software AFTER plugging in camera.
%     Gui.vCamBehavInit = 1;  % for Basler 1MP camera
%     Gui.vCamNeurInit = 3;   % for UCLA USB DAQ
    
    % Alice settings for UCLA sensor / widescope
    % NOTE!  run matlab software AFTER plugging in camera.
    Gui.vCamBehavInit = 1;  % for Basler 1MP camera
    Gui.vCamNeurInit = 2;   % for UCLA USB DAQ 


    %% set up NI device for analog output (LED intensity control)
    fcnVidAcqV3_DaqInit;
    
    %% clear any existing video input objects
    delete(imaqfind)
    imaqreset
    
    %% parameters for acquisition, updating live displays, etc
    vFlgHist = 0;
    vFlgStrmMem = 0;
    vFlgStrmDsk = 0;
    
    vImgSizBhvX = 1280;     % initial values for setup; will change based on camera selection
    vImgSizBhvY = 1024;
    vImgSizNeurX = 752;     % initial values for setup; will change based on camera selection
    vImgSizNeurY = 480;
    
    %% scan to detect attached cameras
    Cams = fcnVidAcqV3_GetCamList;
 
    %% make figure panel for camera selection and general control
    Gui.hFigCtrl = uifigure('Position',[25,220,400,850],...
                'ToolBar', 'none',...
                'MenuBar', 'none');  
    
    % main GUI panel - neural imaging camera controls
    hNeurPnlCtrl = uipanel(Gui.hFigCtrl,'Position',[20 500 360 330]);
    uilabel(hNeurPnlCtrl,'Position',[20 290 180 32], ...
                'Text','Neural Imaging Channel', ...
                'FontSize',14,'Fontweight','bold');
    uilabel(hNeurPnlCtrl,'Position',[30 256 80 32], ...
                'Text','Camera : ', 'FontSize',14);
    ddSelectCamNeur = uidropdown(hNeurPnlCtrl,'Position',[130 260 200 22], ....
                 'Items',Cams.ListMenu, 'ItemsData', (1:Cams.vNumCams+1), ...
                 'Value', Gui.vCamNeurInit, 'ValueChangedFcn', ...
                 @(ddSelectCamNeur,event) fcnVidAcqV3_CamSelectNeur(ddSelectCamNeur,event,Cams));
    uilabel(hNeurPnlCtrl,'Position',[30 226 80 32], ...
                'Text','Frame Rate : ', 'FontSize',13);
    Gui.ddSetFrmRateNeur = uidropdown(hNeurPnlCtrl,'Position',[130 230 200 22], ....
                        'Items',{'     20','     30','     60'}, 'Value', '     30', ...
                        'ValueChangedFcn', ...
                        @(ddSetFrmRatNeur,event) fcnVidAcqV3_SetFrmRateNeur(ddSetFrmRatNeur,event,Cams));  
    uilabel(hNeurPnlCtrl,'Position',[30 196 80 32], ...
                'Text','Exposure : ', 'FontSize',13);
    Gui.ddSetExpNeur = uidropdown(hNeurPnlCtrl,'Position',[130 200 200 22], ....
                        'Items',{'     12','     36','     64'}, ...
                        'ValueChangedFcn', ...
                        @(ddSetExpNeur,event) fcnVidAcqV3_SetExpNeur(ddSetExpNeur,event));          
    uilabel(hNeurPnlCtrl,'Position',[30 166 80 32], ...
                'Text','Gain : ', 'FontSize',13);
    Gui.ddSetGainNeur = uidropdown(hNeurPnlCtrl,'Position',[130 170 200 22], ....
                        'Items',{'     12','     36','     64'}, ...
                        'ValueChangedFcn', ...
                        @(ddSetGainNeur,event) fcnVidAcqV3_SetGainNeur(ddSetGainNeur,event,Cams));       
    Gui.hSldLedPct = uislider(hNeurPnlCtrl, ...
                           'Position', [125,140,205,3], ...
                           'Value',0, ...
                           'ValueChangedFcn',{@fcnVidAcqV3_LedCtrl});
    set(Gui.hSldLedPct, 'Limits', [0 100], ...
                        'MajorTicksMode', 'manual', ...
                        'MajorTicks', (0:10:100), ...
                        'MajorTickLabels', {'0','10','20','30','40','50','60','70','80','90','100'}, ...
                        'MinorTicks', (0:5:100), ...
                        'FontSize', 9);
    uilabel(hNeurPnlCtrl,...
              'Text','LED % :',...
              'Position',[30,130,50,16]);
    Gui.hTxtLedPct = uilabel(hNeurPnlCtrl, ...
                           'Text','0',...
                           'Position',[90,130,45,16]);
    % buttons                   
    hBtnLedOnOffNeur = uibutton(hNeurPnlCtrl, 'State', ...
                               'Position',[30 65 300 30], ...
                               'Text','LED On / Off', ...
                               'ValueChangedFcn',{@fcnVidAcqV3_LedOnOff});         
    hBtnStreamNeur = uibutton(hNeurPnlCtrl,'State', ...
                'Position',[30 25 300 30], ...
                'Text','Stream On / Off', ...
                'ValueChangedFcn',{@fcnVidAcqV3_StreamNeurOnOff});
                          
    % main GUI panel - behavioral imaging camera controls
    hBhavPnlCtrl = uipanel(Gui.hFigCtrl,'Position',[20 240 360 240]);
    uilabel(hBhavPnlCtrl,'Position',[20 200 220 32], ...
                'Text','Behavioral Imaging Channel', ...
                'FontSize',14,'Fontweight','bold');
    uilabel(hBhavPnlCtrl,'Position',[30 166 80 32], ...
                'Text','Camera : ', 'FontSize',14);
    ddSelectCamBhv = uidropdown(hBhavPnlCtrl,'Position',[130 170 200 22], ....
                 'Items',Cams.ListMenu, 'ItemsData', (1:Cams.vNumCams), ...
                 'Value', Gui.vCamBehavInit, 'ValueChangedFcn', ...
                 @(ddSelectCamBhv,event) fcnVidAcqV3_CamSelectBhv(ddSelectCamBhv,event,Cams));
    uilabel(hBhavPnlCtrl,'Position',[30 136 80 32], ...
                'Text','Frame Rate : ', 'FontSize',13);
    Gui.ddSetFrmRateBhv = uidropdown(hBhavPnlCtrl,'Position',[130 140 200 22], ....
                        'Items',{'     20','     30','     60'}, ...
                        'ValueChangedFcn', ...
                        @(ddSetFrmRateBhv,event) fcnVidAcqV3_SetFrmRateBhv(ddSetFrmRateBhv,event));   
    uilabel(hBhavPnlCtrl,'Position',[30 106 80 32], ...
                'Text','Exposure : ', 'FontSize',13);
    Gui.ddSetExpBhv = uidropdown(hBhavPnlCtrl,'Position',[130 110 200 22], ....
                        'Items',{'     12','     36','     64'}, ...
                        'ValueChangedFcn', ...
                        @(ddSetExpBhv,event) fcnVidAcqV3_SetExpBhv(ddSetExpBhv,event));          
    uilabel(hBhavPnlCtrl,'Position',[30 76 80 32], ...
                'Text','Gain : ', 'FontSize',13);
    Gui.ddSetGainBhv = uidropdown(hBhavPnlCtrl,'Position',[130 80 200 22], ....
                        'Items',{'     12','     36','     64'}, ...
                        'ValueChangedFcn', ...
                        @(ddSetGainBhv,event) fcnVidAcqV3_SetGainBhv(ddSetGainBhv,event,Cams));      
    hBtnStreamBhv = uibutton(hBhavPnlCtrl, 'State', ...
                'Position',[30 30 300 30], 'Text','Start/Stop Stream', ...
                'ValueChangedFcn',{@fcnVidAcqV3_StreamBhvOnOff});
                                   
    %% primary button controls
    hBtnLogToDisk = uibutton(Gui.hFigCtrl,'State','Position',[30 180 300 40], ...
                'Text','LOG TO DISK','ValueChangedFcn',{@fcnVidAcqV3_LogToDisk});   
    hBtnPellet = uibutton(Gui.hFigCtrl, 'Position',[30 120 300 40], ...
                'Text','DELIVER PELLET','ButtonPushedFcn', @(hBtnPellet,event) fcnVidAcqV3_DropPellet(hBtnPellet,event));       
    hBtnQuit = uibutton(Gui.hFigCtrl,'Position',[30 60 300 30], ...
                'Text','QUIT','ButtonPushedFcn', @(hBtnQuit,event) fcnVidAcqV3_quit(hBtnQuit,event));             
    drawnow; 
    
    %% create figure panel for neural data video stream    
    Dsp.hFigNeur = figure('Position',[450,280,700,700],...
        'Name', '  NEURAL VIDEO STREAM', ...
        'Color', 'k',...
        'ToolBar', 'none',...
        'MenuBar', 'none');
    
    Dsp.hSldNeurLUTlo = uicontrol('Style','slider');
    Dsp.hSldNeurLUTlo.Position = [50,50,600,15];
    Dsp.hSldNeurLUTlo.Min = 0;
    Dsp.hSldNeurLUTlo.Max = 255;
    Dsp.hSldNeurLUTlo.Value = 0;
    Dsp.hSldNeurLUTlo.SliderStep = [0.00390625 0.01953125];
    
    Dsp.hSldNeurLUThi = uicontrol('Style','slider');
    Dsp.hSldNeurLUThi.Position = [50,30,600,15];
    Dsp.hSldNeurLUThi.Min = 0;
    Dsp.hSldNeurLUThi.Max = 255;
    Dsp.hSldNeurLUThi.Value = 255;
    Dsp.hSldNeurLUThi.SliderStep = [0.00390625 0.01953125];    
    
    %% create figure panel for behavioral video stream
    Dsp.hFigBhv = figure('Position',[1175,280,700,700],...
        'Name', '  BEHAVIORAL VIDEO STREAM', ...
        'Color', 'k',...
        'ToolBar', 'none',...
        'MenuBar', 'none');
    
    Dsp.hSldBhvLUTlo = uicontrol('Style','slider');
    Dsp.hSldBhvLUTlo.Position = [50,50,600,15];
    Dsp.hSldBhvLUTlo.Min = 0;
    Dsp.hSldBhvLUTlo.Max = 255;
    Dsp.hSldBhvLUTlo.Value = 0;
    Dsp.hSldBhvLUTlo.SliderStep = [0.00390625 0.01953125];
    Dsp.hSldBhvLUTlo.Callback = @fcnVidAcqV3_BhvLutUpd;
    
    Dsp.hSldBhvLUThi = uicontrol('Style','slider');
    Dsp.hSldBhvLUThi.Position = [50,30,600,15];
    Dsp.hSldBhvLUThi.Min = 0;
    Dsp.hSldBhvLUThi.Max = 255;
    Dsp.hSldBhvLUThi.Value = 255;
    Dsp.hSldBhvLUThi.SliderStep = [0.00390625 0.01953125];    
    
    %% intialize by connecting to defaults
    fcnVidAcqV3_CamSelectNeur(ddSelectCamNeur,0,Cams);
    fcnVidAcqV3_CamSelectBhv(ddSelectCamBhv,0,Cams);   
    
    % set GUI button press functions to reflect video input objects
    set(hBtnStreamNeur,'ValueChangedFcn', @(hBtnStreamNeur,event) fcnVidAcqV3_StreamNeurOnOff(hBtnStreamNeur,vidNeur))
    set(hBtnStreamBhv,'ValueChangedFcn', @(hBtnStreamBhv,event) fcnVidAcqV3_StreamBhvOnOff(hBtnStreamBhv,vidBhv))
    set(hBtnLogToDisk,'ValueChangedFcn', @(hBtnLogToDisk,event) fcnVidAcqV3_LogToDisk(hBtnLogToDisk))
      
    %% initialize audio mask waveform
    
    % make basic white noise array
    Daq.Fs = 44100;
    vAudRampDur = 2;
    vAudSustDur = 9;
    vAudTotDur = ((2*vAudRampDur) + vAudSustDur) * Daq.Fs;
    Daq.arrAudOut = randn(vAudTotDur,1);  
    % apply slow ramps for onset, offset
    arrAudEnvSlw = linspace(0,1,Daq.Fs*vAudRampDur);
    arrAudEnvSlw  = arrAudEnvSlw';
    arrAudEnvSlw = cat(1, arrAudEnvSlw, ones(Daq.Fs*vAudSustDur,1), (1-arrAudEnvSlw));
    Daq.arrAudOut = Daq.arrAudOut .* arrAudEnvSlw;
    % add a second fast-modulating envelope
    arrAudEnvFst = [];
    while (1)
        vDur = round(200 * randn(1,1)) + 25;
        vLev = (0.5 * randn(1,1)) + 0.5;
        arrIntvl = ones(vDur,1) * vLev;
        arrAudEnvFst = cat(1,arrAudEnvFst,arrIntvl);
        if numel(arrAudEnvFst) > vAudTotDur
            arrAudEnvFst = arrAudEnvFst(1:vAudTotDur);
            break
        end
    end
    Daq.arrAudOut = Daq.arrAudOut .* arrAudEnvFst;

    
    %% 
    return;
    
    %% 
%     
%     % display range for pixel values
%     vBhvDspLimLo = 0;
%     vBhvDspLimHi = 255;
%     vNeurDspLimLo = 0;
%     vNeurDspLimHi = 255;
%     
%     S_PnlCtrls.vLedVlt = 0;
%     
%     % turn on LED
% %     S_PnlCtrls.vLedPct = get(S_PnlCtrls.hSldLedInt,'Value');
% %     S_PnlCtrls.vLedVlt = 4.2-(2.5*(S_PnlCtrls.vLedPct/100));
% %     S_OdrPrms.arrVlvCtrl(9) = 0;
% %     S_OdrPrms.arrVlvCtrl(10) = S_PnlCtrls.vLedVlt;
% %     sessNI.outputSingleScan(S_OdrPrms.arrVlvCtrl)
%     
% 
%     % callback info for buttons
%     strClbkDone = sprintf('%s,%s','global S_FcsFlg','S_FcsFlg.BtnDone=1;');
%     strClbkGrayscale = sprintf('%s,%s','global S_FcsFlg;','S_FcsFlg.BtnGryscl=1;');
%     strClbkRainbow = sprintf('%s,%s','global S_FcsFlg;','S_FcsFlg.BtnRnbow=1;');
%     strClbkRange = sprintf('%s,%s','global S_FcsFlg;','S_FcsFlg.BtnRng=1;'); 
%     
%     % calculate histogram info from initial zero focus frame
% %     arrHstBins = 0:16:4096;
% %     arrImgHist = histc(arrFrmFcsSngl,arrHstBins);
% %     arrImgHist = sum(arrImgHist,2)';
% %                         
% %     % draw histogram figure window
% %     hFigHst = figure('Position',[350,50,700,200],...
% %                      'ToolBar', 'none',...
% %                      'MenuBar', 'none');
% %     
% %     % draw plot in histogram figure window
% %      hPltHst = plot(arrImgHist);
% %      set (hPltHst,'LineWidth',2);
% %      set (gca,'Position',[0.13 0.2 0.76 0.68]);
% %      set (gca,'XLim',[0,256]);
% %      set (gca,'XTick',0:64:256);
% %      set (gca,'XTickLabel',{'0','1024','2048','3072','4096'});
% %      ylabel ('count');
% %      xlabel ('pixel value');
%     
%     %turn on LED for fluorescence illumination
%     %disp(S_PnlCtrls.vLedVlt)
%     %S_OdrPrms.arrVlvCtrl(9) = 0;
%     %S_OdrPrms.arrVlvCtrl(10) = S_PnlCtrls.vLedVlt;
%     %sessNI.outputSingleScan(S_OdrPrms.arrVlvCtrl)
%     %pause (1);
%    
% %     % set up initial flags for control buttons
% %     S_FcsFlg.BtnGryscl = 0;
% %     S_FcsFlg.BtnRnbow = 0;
% %     S_FcsFlg.BtnRng = 0;
% %     S_FcsFlg.BtnDone = 0;
%     
%     % arrays for timestamp data
%     arrtsBhv = zeros(10000,1);
%     arrtsNeur = zeros(10000,1);
%     
%     % frame counters for full image series, and display update
%     vCtrBhv = 1;
%     vCtrNeur = 1;
%     vCtrUpdateBhv = 1;
%     vCtrUpdateNeur = 1;
%     
%     
%     % send manual trigger to start video objects running
%     if vFlgAcqNeur
%         if ~vFlgWebcam
%             start(vidNeur)
%         end
%         disp('    > started neural vid obj.')
%     end    
%     if vFlgAcqBhv
%         start(vidBhv)
%         disp('    > started behavioral vid obj.')
%     end
%     
%     if vFlgAcqBhv
%         trigger(vidBhv)
%         disp('    > triggered behavioral vid obj.')
%     end
%     if vFlgAcqNeur
%         if ~vFlgWebcam
%             trigger(vidNeur);
%         end
%         disp('    > triggered neural vid obj.')
%     end
% 
%     S_FcsFlg.Running = 1;
%     
%     while (1)
%         
%         if (vFlgAcqNeur>0) && (vidNeur.FramesAvailable>0)
%             % bring frame into workspace memory from buffer
%             [arrFrmNeurSngl, ts] = getdata(vidNeur,1);
%             arrFrmNeurSngl = uint8(arrFrmNeurSngl);
%             arrtsNeur(vCtrNeur,1) = ts;
%             vCtrUpdateNeur = vCtrUpdateNeur + 1;
%             if vCtrUpdateNeur>vUpdateIntvlNeur
%                 set (hImgNeur,'CData',arrFrmNeurSngl);
%                 % calculate histogram info if requested
%                 if vFlgHist
%                     %arrHist = sum(histc(arrFrmNeurSngl,arrHstBins),2);
%                     %%arrHist = sum(arrImgHist,2)';
%                     %set (hPltHst,'YData',arrHist);
%                 end
%                 drawnow;
%                 vCtrUpdateNeur = 1;
%             end
%             vCtrNeur = vCtrNeur+1;      
%         end
%         
%         if (vFlgAcqBhv>0) && (vidBhv.FramesAvailable>0)
%             [arrFrmBhvSngl, ts] = getdata(vidBhv,1);
%             arrtsBhv(vCtrBhv,1) = ts;
%             vCtrUpdateBhv = vCtrUpdateBhv + 1;
%             if vCtrUpdateBhv>vUpdateIntvlBhv
%                 set (hImgBhv,'CData',arrFrmBhvSngl);
%                 drawnow;
%                 vCtrUpdateBhv = 1;
%             end
%             vCtrBhv = vCtrBhv+1;
%         end
%         
%         
%      
% %         if (S_FcsFlg.BtnGryscl==1)
% %             S_FcsFlg.BtnGryscl=0;
% %             map = bone(256);
% %             set (gcf,'Colormap',map);
% %         end
% %         if (S_FcsFlg.BtnRnbow==1)
% %             S_FcsFlg.BtnRnbow=0;
% %             map = jet(256);
% %             set (gcf,'Colormap',map);
% %         end
% %         if (S_FcsFlg.BtnRng==1)
% %             S_FcsFlg.BtnRng=0;
% %             if (S_Fcs.DspLimHi==50)
% %                 S_Fcs.DspLimHi = 400;
% %             elseif (S_Fcs.DspLimHi==400)
% %                 S_Fcs.DspLimHi = 50;
% %             end
% %             set(gca,'CLim', [S_Fcs.DspLimLo,S_Fcs.DspLimHi]);
% %         end
% 
%         if (S_FcsFlg.BtnDone==1)
%             S_FcsFlg.BtnDone=0;
%             disp('    ***  complete!!  ***')
%             break
%         end
%         
%     end
%     
%     %turn off LED for fluorescence illumination
% %     S_OdrPrms.arrVlvCtrl(9) = 1;
% %     S_OdrPrms.arrVlvCtrl(10) = 5;
% %     sessNI.outputSingleScan(S_OdrPrms.arrVlvCtrl)
% %     pause (0.2);
%     
%     % set flag
%     disp('    > completed, cleaning up')
%     S_FcsFlg.Running = 0;
%     if vFlgAcqNeur
%         stop(vidNeur)
%         disp('    > stopped neural vid obj.')
%         disp(['   > acquired neural frames: ', num2str( vidNeur.FramesAcquired)])
%         disp(['   > logged neural frames: ', num2str( vidNeur.DiskLoggerFrameCount)])
%     end    
%     if vFlgAcqBhv
%         stop(vidBhv)
%         disp('    > stopped behavioral vid obj.')
%         disp(['   > acquired behavioral frames: ', num2str( vidBhv.FramesAcquired)])
%         disp(['   > logged behavioral frames: ', num2str( vidBhv.DiskLoggerFrameCount)])
%     end
%     
% 
%     % ensure all file saved to disk
%     if vFlgStrmDsk
%         disp('  > checking logger...')
%         while (vidBhv.FramesAcquired > vidBhv.DiskLoggerFrameCount) 
%             disp('  > waiting for logger...')
%             pause(1)
%         end
%        
%     end
%     
%     % clean up video objects
%     if vFlgAcqBhv
%         % clear video object from memory
%         disp('    > cleaning up behavior acq object')
%         stop (vidBhv);
%         flushdata (vidBhv);
%         delete (vidBhv);
%         clear vidBhv;
%         close (hFigBhv);
%         % save time series data to disk if requested
%         arrtsBhv = arrtsBhv(arrtsBhv>0);
%         if vFlgStrmDsk
%             sFilNameBhavTs = ['E:\MiniscopeData\MATLAB\vid_',sDirNam,'\ts_bhav_',sDirNam,'.txt'];
%             writematrix(arrtsBhv, sFilNameBhavTs,'FileType','Text')
%         end
%         % plot to check for dropped frames
%         arrtsBhvDiff = diff(arrtsBhv);
%         figure('Name','Behav cam frame intervals');
%         plot(arrtsBhvDiff);
%     end
%     if vFlgAcqNeur
%         disp('    > cleaning up neural acq object')
%         flushdata (vidNeur);
%         delete (vidNeur);
%         clear vidNeur;
%         close (hFigNeur);
%         % save time series data to diskif requested
%         arrtsNeur = arrtsNeur(arrtsNeur>0);
%         if vFlgStrmDsk
%             sFilNameNeurTs = ['E:\MiniscopeData\MATLAB\vid_',sDirNam,'\ts_neur_',sDirNam,'.txt'];
%             writematrix(arrtsNeur, sFilNameBhavTs,'FileType','Text')
%         end
%         % plot to check for dropped frames
%         arrtsNeur = arrtsNeur(arrtsNeur>0);
%         arrtsNeurDiff = diff(arrtsNeur);
%         figure('Name','Neural cam frame intervals');
%         plot(arrtsNeurDiff);
%     end
%     
%     
%     % plot timestamp data 
% 
%     
    
   
    
end

%===========================================================================================================
function fcnVidAcqV3_quit(~,~)
    
    global Gui
    global Dsp
    global Daq
    global vidBhv
    global vidNeur

    % set output to 5V to zero LED output on close
    Daq.sess.outputSingleScan(5);
    % end session
    release(Daq.sess);
    disp('   > closed DAQ session.')
    
    stop(vidNeur)
    flushdata (vidNeur);
    delete (vidNeur);
    clear vidNeur;

    stop(vidBhv)
    flushdata (vidBhv);
    delete (vidBhv);
    clear vidBhv;
    
    close(Gui.hFigCtrl)
    close(Dsp.hFigNeur)
    close(Dsp.hFigBhv)
    
    
end

