function fcnVidAcqV3_FrmRateSelectNeur(ddSelectFrmRatNeur,~,Cams)
    
    global vidNeur
    global Dsp
    global Ctr
    global Gui
    
    %% read camera selection from dropdown
    vCamNum = ddSelectCamNeur.Value;
    sCamName = cell2mat(Cams.ListCamsAll(vCamNum));
    vVidNeurDeviceID = Cams.ListDeviceIDsAll(find(strcmp(sCamName,Cams.ListCamsAll)));
    
    vFrmRate = Gui.ddSelectFrmRatNeur.Value
    sFrmRate = cell2mat(Gui.ddSelectFrmRatNeur.Items(vFrmRate))
    %vVidNeurDeviceID = Cams.ListDeviceIDsAll(find(strcmp(sCamName,Cams.ListCamsAll)));
    %sCamName = 'MINISCOPE';

%     %% set up video input object for selected neural imaging camera
%     switch (sCamName)
%         case 'MINISCOPE'
%             % NOTE - configure for specific camera models in use
%             % these settings for UCLA miniscope hardware
%             disp('   > configuring neural video input for UCLA miniscope sensor...')
%             disp(['      > camera device ID = ', num2str(vVidNeurDeviceID)])
%             sVidNeurAdapter = 'winvideo';
%             sVidNeurFormat = 'YUY2_752x480';
%             vidNeur = videoinput(sVidNeurAdapter, vVidNeurDeviceID, sVidNeurFormat);
%             vidNeur.ReturnedColorspace = 'grayscale';
%             vidNeur.FramesPerTrigger = inf;
%             % configure acquisition properties
%             triggerconfig(vidNeur, 'manual');
%             srcNeur = getselectedsource(vidNeur);
%             srcNeur.Brightness = 255;
%             srcNeur.Gain = 64;
%             Ctr.NeurUpdateIntvl = 10;
% 
%             %vidNeur.ROIPosition = [500 150 1600 1600];
%             Dsp.vImgSizNeurX = 480;
%             Dsp.vImgSizNeurY = 752;
%             % {'16','24','32','40','48','56','64'}
%             % {'not configurable'}
%                 
%         case {'08981158','17880258','18880958','08981258';}
%             % NOTE - configure for specific camera models in use
%             % these settings for Ximea 5MP sensor
%             disp('   > configuring neural video input for Ximea 5MP sensor')
%             disp(['      > camera device ID = ', num2str(vVidNeurDeviceID)])
%             sVidNeurAdapter = 'gentl';
%             sVidNeurFormat = 'Mono8';
%             vidNeur = videoinput(sVidNeurAdapter, vVidNeurDeviceID, sVidNeurFormat);
%             % configure acquisition properties
%             srcNeur = getselectedsource(vidNeur);
%             triggerconfig(vidNeur, 'manual');
%             vidNeur.FramesPerTrigger = inf;
%             srcNeur.ExposureTime = 100000;                                 %Exposure Set between _ and _
%             srcNeur.Gain = 14;                                              %Gain set between 1 and 20
%             vRoiXpos = 858;
%             vRoiYpos = 856;
%             vRoiWdth = 1012;
%             vRoiHght = 914;
%             vidNeur.ROIPosition = [vRoiXpos vRoiYpos vRoiWdth vRoiHght];
%             Dsp.vImgSizNeurY = vRoiWdth;
%             Dsp.vImgSizNeurX = vRoiHght;
%             
%          case 'acA1300-200um (22993834)'
%             disp('   > configuring neural video input for Basler Ace 1300 camera')
%             disp(['      > camera device ID = ', num2str(vVidNeurDeviceID)])
%             % set up video input for behavior camera
%             % NOTE - configure for specific camera model
%             sVidBhvAdapter = 'gentl';
%             sVidBhvFormat = 'Mono8';
%             vidBhv = videoinput(sVidBhvAdapter, vVidBhvDeviceID, sVidBhvFormat);
%             % configure acquisition properties
%             srcBhv = getselectedsource(vidBhv);
%             vidBhv.FramesPerTrigger = inf;
%             vidBhv.ReturnedColorspace = 'grayscale';
%             triggerconfig(vidBhv, 'manual');
%             vidBhv.TriggerRepeat = inf;
%             %srcBhv.AcquisitionFrameRateEnable = 'True';
%             srcBhv.AcquisitionFrameRate = 100;
%             srcBhv.ExposureTime = 7000;
%             srcBhv.Gain = 12;
%             Dsp.vImgSizNeurX = 1280;
%             Dsp.vImgSizNeurY = 1024;
%             % {'1','2','4','6','8','10','12'}
%             % {'10','15','20','30','40','50','60','80','100','120'}
%     end
%     
%      % arrays to hold incoming image data block, and duplicate for transfer and save 
%     Ctr.ImgBlckNeur = zeros(Dsp.vImgSizNeurX,Dsp.vImgSizNeurY,Ctr.BhvBlckFrms,'uint8');
%     Ctr.ImgBlckNeurSav = zeros(Dsp.vImgSizNeurX,Dsp.vImgSizNeurY,Ctr.BhvBlckFrms,'uint8');
%     
%     % update size of image plot for video stream data
%     arrFrmNeurSngl = zeros(Dsp.vImgSizNeurX,Dsp.vImgSizNeurY);
%     figure (Dsp.hFigNeur)
%     Dsp.hImgNeur = image(arrFrmNeurSngl);
%     % turn off auto-update properties for faster refresh
%     set(gca, 'xlimmode','manual',...
%         'ylimmode','manual',...
%         'zlimmode','manual',...
%         'climmode','manual',...
%         'alimmode','manual');
%     set(gcf,'doublebuffer','off');
%     % display properties
%     set(Dsp.hImgNeur,'CDataMapping','scaled');
%     set(gcf, 'Colormap', gray(256));
%     vBhvDspLimLo = 0;
%     vBhvDspLimHi = 255;
%     set(gca,'CLim', [vBhvDspLimLo,vBhvDspLimHi]);
%     set(gca,'Position',[0.1,0.13,0.8,0.8]);
%     axis off;
%     
%     %% set frames available callback to grab each frame 
%     vidNeur.FramesAcquiredFcnCount = 1;
%     set (vidNeur,'FramesAcquiredFcn', {@fcnVidAcqV3_GetFrameNeur,vidNeur});
%     
%    %%
%    disp('      > done.')


end
