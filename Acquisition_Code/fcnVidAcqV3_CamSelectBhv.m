function fcnVidAcqV3_CamSelectBhv(ddSelectCamBhv,~,Cams)
    
    global vidBhv
    global Dsp
    global Ctr
    global Gui
    
    %% read camera selection from dropdown
    disp('Running changes')
    vCamNum = ddSelectCamBhv.Value;
    %disp(vCamNum)
    sCamName = cell2mat(Cams.ListCamsAll(vCamNum));
    Gui.CamBhv = sCamName;
    vVidBhvDeviceID = Cams.ListDeviceIDsAll(find(strcmp(sCamName,Cams.ListCamsAll)));
    if numel(vVidBhvDeviceID)>1   % sometimes cameras are detected in duplicate??
        vVidBhvDeviceID = vVidBhvDeviceID(1,1);
    end
    
    %% set up new video input object for selected behavioral imaging camera
    switch (sCamName)
        case {'acA1300-200um (22993834)', 'acA1300-200um (23157464)'}
            disp('   > configuring behavioral video input for Basler Ace 1300 camera')
            disp(['      > camera device ID = ', num2str(vVidBhvDeviceID)])
            % NOTE - configure for specific camera model
            % these settings for Basler 1MP monochrome for fast acq
            sVidBhvAdapter = 'gentl';
            sVidBhvFormat = 'Mono8';
            vidBhv = videoinput(sVidBhvAdapter, vVidBhvDeviceID, sVidBhvFormat);
            % configure acquisition properties
            vidBhv.FramesPerTrigger = inf;
            vidBhv.ReturnedColorspace = 'grayscale';
            triggerconfig(vidBhv, 'manual');
            vidBhv.TriggerRepeat = inf;
            srcBhv = getselectedsource(vidBhv);
            srcBhv.AcquisitionFrameRateEnable = 'True';
            srcBhv.AcquisitionFrameRate = 60;
            %srcBhv.AcquisitionFrameRate = 50;
            Ctr.BhvUpdateIntvl = 20;
            srcBhv.ExposureTime = 10000;
            srcBhv.Gain = 12;
            Dsp.vImgSizBhvX = 1280;
            Dsp.vImgSizBhvY = 1024;
            Dsp.vImgSizCdpth = 1;

            set (Gui.ddSetFrmRateBhv, 'Items',{'     10','     15','     20', ...
                                         '     30','     50','     60','     75', ...
                                         '    100'}, 'Value', '     60');
            set (Gui.ddSetExpBhv, 'Items', {'    -13','    -11','    -9', ...
                                      '     -7','    -5','    -3','    -1'}, ...
                                      'Value', '    -5');
            set (Gui.ddSetGainBhv, 'Items',{'     1','     2','     4', ...
                                       '     6','     8','     10','     12'}, ...
                                       'Value', '     12');
        case {'USB Camera'}
            disp('   > configuring behavioral video input for Kayeton color 2MPix')
            disp(['      > camera device ID = ', num2str(vVidBhvDeviceID)])
            % NOTE - configure for specific camera model
            % these settings for the Kayeton high-sensitivity color camera
            sVidBhvAdapter = 'winvideo';
            sVidBhvFormat = 'MJPG_1920x1080';
            vidBhv = videoinput(sVidBhvAdapter, vVidBhvDeviceID, sVidBhvFormat);
            % configure acquisition properties
            % note using ROI for this sensor since aspect ratio is very long
            vidBhv.ROIPosition = [350 0 1220 1080];
            vidBhv.FramesPerTrigger = inf;
            vidBhv.ReturnedColorspace = 'rgb';
            triggerconfig(vidBhv, 'manual');
            vidBhv.TriggerRepeat = inf;
            srcBhv = getselectedsource(vidBhv);
            srcBhv.WhiteBalanceMode = 'auto';
            srcBhv.ExposureMode = 'manual';
%             srcBhv.AcquisitionFrameRateEnable = 'True';
%             srcBhv.AcquisitionFrameRate = 40;
            %srcBhv.AcquisitionFrameRate = 50;
            Ctr.BhvUpdateIntvl = 5;
            %srcBhv.ExposureTime = 10000;
            srcBhv.Gain = 50;
            Dsp.vImgSizBhvX = 1220;
            Dsp.vImgSizBhvY = 1080;
            Dsp.vImgSizCdpth = 3;

            set (Gui.ddSetFrmRateBhv, 'Items',{'     30'}, 'Value', '     30');
            set (Gui.ddSetExpBhv, 'Items', {'    -11','    -8','    -7', '    -6',...
                                      '     -5','    -4','    -3','    -2'}, ...
                                      'Value', '     -5');
            set (Gui.ddSetGainBhv, 'Items',{'     0','    20','    40', ...
                                       '    60','   80','    100'}, ...
                                       'Value', '    60');
            
        case {'Basler GenICam Source'}
            disp('   > configuring behavioral video input for Basler Ace 1300 camera')
            disp(['      > camera device ID = ', num2str(vVidBhvDeviceID)])
            % NOTE - configure for specific camera model
            % these settings for Basler 1MP monochrome for fast acq
            sVidBhvAdapter = 'winvideo';
            sVidBhvFormat = 'Mono8';
            vidBhv = videoinput(sVidBhvAdapter, vVidBhvDeviceID, sVidBhvFormat);
            % configure acquisition properties
            vidBhv.FramesPerTrigger = inf;
            vidBhv.ReturnedColorspace = 'grayscale';
            triggerconfig(vidBhv, 'manual');
            vidBhv.TriggerRepeat = inf;
            srcBhv = getselectedsource(vidBhv);
            srcBhv.AcquisitionFrameRateEnable = 'True';
            srcBhv.AcquisitionFrameRate = 40;
            %srcBhv.AcquisitionFrameRate = 50;
            Ctr.BhvUpdateIntvl = 10;
            srcBhv.ExposureTime = 10000;
            srcBhv.Gain = 12;
            Dsp.vImgSizBhvX = 1280;
            Dsp.vImgSizBhvY = 1024;
            Dsp.vImgSizCdpth = 1;

            set (Gui.ddSetFrmRateBhv, 'Items',{'     10','     15','     20', ...
                                         '     30','     50','     60','     75', ...
                                         '    100'}, 'Value', '     50');
            set (Gui.ddSetExpBhv, 'Items', {'     5','     8','    10', ...
                                      '    15','    20','    40'}, ...
                                      'Value', '    10');
            set (Gui.ddSetGainBhv, 'Items',{'     1','     2','     4', ...
                                       '     6','     8','     10','     12'}, ...
                                       'Value', '     12');
                                   
        case 'Microsoft® LifeCam VX-2000'
            % NOTE - configure for specific camera models in use
            % these settings for basic microsoft webcam
            disp('   > configuring behavioral video input for microsoft VX-2000 webcam...')
            disp(['      > camera device ID = ', num2str(vVidBhvDeviceID)])
            sVidBhvAdapter = 'winvideo';
            sVidBhvFormat = 'MJPG_640x480';
            vidBhv = videoinput(sVidBhvAdapter, vVidBhvDeviceID, sVidBhvFormat);
            % configure acquisition properties
            triggerconfig(vidBhv, 'manual');
            vidBhv.ReturnedColorspace = 'grayscale';
            vidBhv.FramesPerTrigger = inf;
            srcBhv = getselectedsource(vidBhv);
%             srcBhv.Brightness = 100;
%             srcBhv.Gain = 64;
            %vidBhv.ROIPosition = [500 150 1600 1600];
            Dsp.vImgSizBhvX = 640;
            Dsp.vImgSizBhvY = 480;
            Dsp.vImgSizCdpth = 3;    %  probably color?  not currently using
                   
        case 'c922 Pro Stream Webcam'
            % NOTE - configure for specific camera models in use
            % these settings for HD microsoft color webcam
            disp('   > configuring behavioral video input for microsoft c922 Pro Stream Webcam...')
            disp(['      > camera device ID = ', num2str(vVidBhvDeviceID)])
            sVidBhvAdapter = 'winvideo';
            sVidBhvFormat = 'MJPG_800x600';
            vidBhv = videoinput(sVidBhvAdapter, vVidBhvDeviceID, sVidBhvFormat);
            % configure acquisition properties
            triggerconfig(vidBhv, 'manual');
            vidBhv.ReturnedColorspace = 'grayscale';
            vidBhv.FramesPerTrigger = inf;
            srcBhv = getselectedsource(vidBhv);
            srcBhv.BacklightCompensation = 'off';
            srcBhv.Brightness = 128;
            srcBhv.FrameRate = '30.0000';
            srcBhv.ExposureMode = 'manual';
            srcBhv.FocusMode = 'auto';
            srcBhv.Exposure = -7;
            srcBhv.Gain = 128;
            %vidBhv.ROIPosition = [500 150 1600 1600];
            Dsp.vImgSizBhvX = 800;
            Dsp.vImgSizBhvY = 600;  
            Dsp.vImgSizCdpth = 3;
   
            set (Gui.ddSetFrmRateBhv, 'Items',{'     30','     24','     20', ...
                                         '     15','     10','     7.5','       5'}, ...
                                         'Value', '     30');
            set (Gui.ddSetExpBhv, 'Items',{'     -11','     -10','      -9', ...
                                       '      -8','      -7','      -6','      -5', ...
                                       '      -4','      -3','      -2'}, ...
                                       'Value', '      -6');                          
            set (Gui.ddSetGainBhv, 'Items',{'     255','     200','     150', ...
                                       '     125','     100','      75','      50'}, ...
                                       'Value', '     200');
            
%         case 'MINISCOPE'
%             % NOTE - configure for specific camera models in use
%             % these settings for UCLA miniscope hardware
%             disp('   > configuring behavioral video input for UCLA miniscope sensor...')
%             disp(['      > camera device ID = ', num2str(vVidBhvDeviceID)])
%             sVidBhvAdapter = 'winvideo';
%             sVidBhvFormat = 'YUY2_752x480';
%             vidBhv = videoinput(sVidBhvAdapter, vVidBhvDeviceID, sVidBhvFormat);
%             % configure acquisition properties
%             triggerconfig(vidBhv, 'manual');
%             vidBhv.ReturnedColorspace = 'grayscale';
%             vidBhv.FramesPerTrigger = inf;
%             srcBhv = getselectedsource(vidBhv);
%             srcBhv.Brightness = 255;
%             srcBhv.Gain = 64;
%             %vidBhv.ROIPosition = [500 150 1600 1600];
%             Dsp.vImgSizBhvX = 752;
%             Dsp.vImgSizBhvY = 480;
%             
%         case 'XIMEA'
%             % NOTE - configure for specific camera models in use
%             % these settings for Ximea 5MP sensor
%             disp('   > configuring behavioral video input for Ximea 5MP sensor')
%             disp(['      > camera device ID = ', num2str(vVidBhvDeviceID)])
%             sVidBhvAdapter = 'gentl';
%             sVidBhvFormat = 'Mono8';
%             vidBhv = videoinput(sVidBhvAdapter, vVidBhvDeviceID, sVidBhvFormat);
%             % configure acquisition properties
%             srcBhv = getselectedsource(vidBhv);
%             triggerconfig(vidBhv, 'manual');
%             vidBhv.FramesPerTrigger = inf;
%             srcBhv.ExposureTime = 44944;
%             srcBhv.Gain = 12;
%             vidBhv.ROIPosition = [500 150 1600 1600];
%             Dsp.vImgSizBhvX = 1600;
%             Dsp.vImgSizBhvY = 1600;
    end
    
    % arrays to hold incoming image data block, and duplicate for transfer and save 
    Ctr.ImgBlckBhv = zeros(Dsp.vImgSizBhvY, Dsp.vImgSizBhvX, Dsp.vImgSizCdpth, Ctr.BhvBlckFrms,'uint8');
    Ctr.ImgBlckBhvSav = zeros(Dsp.vImgSizBhvY, Dsp.vImgSizBhvX, Dsp.vImgSizCdpth, Ctr.BhvBlckFrms,'uint8');
    disp(size(Ctr.ImgBlckBhv));

    % update size of image plot for video stream data
    arrFrmBhvSngl = zeros(Dsp.vImgSizBhvY, Dsp.vImgSizBhvX, Dsp.vImgSizCdpth);
    figure (Dsp.hFigBhv)
    Dsp.hImgBhv = image(arrFrmBhvSngl);
    % turn off auto-update properties for faster refresh
    set(gca, 'xlimmode','manual',...
        'ylimmode','manual',...
        'zlimmode','manual',...
        'climmode','manual',...
        'alimmode','manual');
    set(gcf,'doublebuffer','off');
    % display properties
    set(Dsp.hImgBhv,'CDataMapping','scaled');
    if Dsp.vImgSizCdpth == 1
        set(gcf, 'Colormap', gray(256));
%     elseif Dsp.vImgSizCdpth == 3
%         set(gcf, 'Colormap', gray(256));
    end
    
    vBhvDspLimLo = 0;
    vBhvDspLimHi = 100; 
    set(gca,'CLim', [vBhvDspLimLo,vBhvDspLimHi]);
    set(gca,'Position',[0.1,0.13,0.8,0.8]);
    axis off;
    
    %% set frames available callback to grab each frame 
    vidBhv.FramesAcquiredFcnCount = 1;
    set (vidBhv,'FramesAcquiredFcn', {@fcnVidAcqV3_GetFrameBhv,vidBhv});
    
    %%
    disp('      > done.')
    
end


