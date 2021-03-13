function [vidNeur] = fcnVidAcqV3_CamSelectNeur(ddSelectCamNeur,~,Cams)
    
    global vidNeur
    global Dsp
    global Ctr
    global Gui
    
    %% read camera selection from dropdown
    vCamNum = ddSelectCamNeur.Value;
    disp(vCamNum)
    sCamName = cell2mat(Cams.ListCamsAll(vCamNum));
    Gui.CamNeur = sCamName;
    vVidNeurDeviceID = Cams.ListDeviceIDsAll(find(strcmp(sCamName,Cams.ListCamsAll)));
    if numel(vVidNeurDeviceID)>1   % sometimes cameras are detected in duplicate??
        vVidNeurDeviceID = vVidNeurDeviceID(1,1);
    end
    %sCamName = 'MINISCOPE';

    %% set up video input object for selected neural imaging camera
    switch (sCamName)
        case 'MINISCOPE'
            % NOTE - configure for specific camera models in use
            % these settings for UCLA miniscope hardware V3
            disp('   > configuring neural video input for UCLA miniscope sensor...')
            disp(['      > camera device ID = ', num2str(vVidNeurDeviceID)])
            sVidNeurAdapter = 'winvideo';
            sVidNeurFormat = 'YUY2_752x480';
            vidNeur = videoinput(sVidNeurAdapter, vVidNeurDeviceID, sVidNeurFormat);
            vidNeur.ReturnedColorspace = 'grayscale';
            vidNeur.FramesPerTrigger = inf;
            % configure acquisition properties
            triggerconfig(vidNeur, 'manual');
            srcNeur = getselectedsource(vidNeur);
            srcNeur.Brightness = 255;
            %srcNeur.Gain = 64;
            srcNeur.Gain = 64;
            Ctr.NeurUpdateIntvl = 20;    
            %vidNeur.ROIPosition = [500 150 1600 1600];
            Dsp.vImgSizNeurX = 480;
            Dsp.vImgSizNeurY = 752;

            set (Gui.ddSetFrmRateNeur, 'Items',{'   - set w/ UCLA software -'});
            set (Gui.ddSetExpNeur, 'Items', {'     255','     200','     150', ...
                                      '     100','     50'}, 'Value', '     255');
            set (Gui.ddSetGainNeur, 'Items',{'     16','     24','     32', ...
                                       '     40','     48','     56','     64'}, ...
                                       'Value', '     64');
        case 'MINISCOPEV4'
            % NOTE - configure for specific camera models in use
            % these settings for UCLA miniscope hardware V4
            disp('   > configuring neural video input for UCLA miniscope sensor...')
            disp(['      > camera device ID = ', num2str(vVidNeurDeviceID)])
            sVidNeurAdapter = 'winvideo';
            sVidNeurFormat = 'YUY2_608x608';
            vidNeur = videoinput(sVidNeurAdapter, vVidNeurDeviceID, sVidNeurFormat);
            vidNeur.ReturnedColorspace = 'grayscale';
            vidNeur.FramesPerTrigger = inf;
            % configure acquisition properties
            triggerconfig(vidNeur, 'manual');
            srcNeur = getselectedsource(vidNeur);
            %srcNeur.Brightness = 255;
            %srcNeur.Gain = 64;
            %srcNeur.Gain = 64;
            Ctr.NeurUpdateIntvl = 15;    
            %vidNeur.ROIPosition = [500 150 1600 1600];
            Dsp.vImgSizNeurX = 608;
            Dsp.vImgSizNeurY = 608;

            set (Gui.ddSetFrmRateNeur, 'Items',{'   - set w/ UCLA software -'});
            set (Gui.ddSetExpNeur, 'Items', {'     255','     200','     150', ...
                                      '     100','     50'}, 'Value', '     255');
            set (Gui.ddSetGainNeur, 'Items',{'     16','     24','     32', ...
                                       '     40','     48','     56','     64'}, ...
                                       'Value', '     64');        
        case {'08981158','17880258','18880958','08981258','06080258';}
            % NOTE - configure for specific camera models in use
            % these settings for Ximea 5MP sensor
            disp('   > configuring neural video input for Ximea 5MP sensor')
            disp(['      > camera device ID = ', num2str(vVidNeurDeviceID)])
            sVidNeurAdapter = 'gentl';
            sVidNeurFormat = 'Mono8';
            vidNeur = videoinput(sVidNeurAdapter, vVidNeurDeviceID, sVidNeurFormat);
            % configure acquisition properties
            srcNeur = getselectedsource(vidNeur);
            triggerconfig(vidNeur, 'manual');
            vidNeur.FramesPerTrigger = inf;
            srcNeur.ExposureTime = 100000;                                 %Exposure Set between _ and _
            srcNeur.Gain = 14;                                              %Gain set between 1 and 20
            vRoiXpos = 858;
            vRoiYpos = 856;
            vRoiWdth = 1012;
            vRoiHght = 914;
            vidNeur.ROIPosition = [vRoiXpos vRoiYpos vRoiWdth vRoiHght];
            Dsp.vImgSizNeurY = vRoiWdth;
            Dsp.vImgSizNeurX = vRoiHght;
            
            set (Gui.ddSetFrmRatNeur, 'Items',{'     4.0', '     4.5', '     5.0', ...
                                         '     6.0', '     7.0', '     8.0', ...
                                         '     9.0', '     10.0'}, 'Value', '     5.0');
            set (Gui.ddSetExpNeur, 'Items', {'     90','     100','     115', ...
                                      '     150','     200'}, 'Value', '     100');
            set (Gui.ddSetGainNeur, 'Items',{'      1','      2','      4', ...
                                       '      8','    10','     12','     14', ...
                                       '     16','     18', '     20' }, ...
                                       'Value', '     14');
            
         case {'acA1300-200um (22993834)','acA1300-200um (23157464)'}
            disp('   > configuring neural video input for Basler Ace 1300 camera')
            disp(['      > camera device ID = ', num2str(vVidNeurDeviceID)])
            % NOTE - configure for specific camera model
            % these settings for Basler 1MP monochrome for fast acq
            sVidNeurAdapter = 'gentl';
            sVidNeurFormat = 'Mono8';
            vidNeur = videoinput(sVidNeurAdapter, vVidNeurDeviceID, sVidNeurFormat);
            % configure acquisition properties
            vidNeur.FramesPerTrigger = inf;
            vidNeur.ReturnedColorspace = 'grayscale';
            triggerconfig(vidNeur, 'manual');
            vidNeur.TriggerRepeat = inf;
            srcNeur = getselectedsource(vidNeur);
            srcNeur.AcquisitionFrameRateEnable = 'True';
            srcNeur.AcquisitionFrameRate = 40;
            Ctr.NeurUpdateIntvl = 10;
            srcNeur.ExposureTime = 10000;
            srcNeur.Gain = 12;
            Dsp.vImgSizNeurX = 1280;
            Dsp.vImgSizNeurY = 1024;

            set (Gui.ddSetFrmRateNeur, 'Items',{'     10','     15','     20', ...
                                         '     30','     50','     60','     75', ...
                                         '    100'}, 'Value', '     50');
            set (Gui.ddSetExpNeur, 'Items', {'     5','     8','    10', ...
                                      '    15','    20','    40'}, ...
                                      'Value', '    10');
            set (Gui.ddSetGainNeur, 'Items',{'     1','     2','     4', ...
                                       '     6','     8','     10','     12'}, ...
                                       'Value', '     12');
            
%         case 'Basler GenICam Source'
%             Dsp.vImgSizNeurX = 1280;
%             Dsp.vImgSizNeurY = 1024;
                    
        case 'c922 Pro Stream Webcam'
            % NOTE - configure for specific camera models in use
            % these settings for HD microsoft color webcam
            disp('   > configuring neural video input for microsoft c922 Pro Stream Webcam...')
            disp(['      > camera device ID = ', num2str(vVidNeurDeviceID)])
            sVidNeurAdapter = 'winvideo';
            sVidNeurFormat = 'MJPG_800x600';
            vidNeur = videoinput(sVidNeurAdapter, vVidNeurDeviceID, sVidNeurFormat);
            % configure acquisition properties
            triggerconfig(vidNeur, 'manual');
            vidNeur.ReturnedColorspace = 'grayscale';
            vidNeur.FramesPerTrigger = inf;
            srcNeur = getselectedsource(vidNeur);
            srcNeur.BacklightCompensation = 'off';
            srcNeur.Brightness = 128;
            srcNeur.FrameRate = '30.0000';
            srcNeur.ExposureMode = 'manual';
            srcNeur.FocusMode = 'auto';
            srcNeur.Exposure = -7;
            srcNeur.Gain = 128;
            %vidNeur.ROIPosition = [500 150 1600 1600];
            Dsp.vImgSizNeurX = 800;
            Dsp.vImgSizNeurY = 600;   
   
            set (Gui.ddSetFrmRateNeur, 'Items',{'     30','     24','     20', ...
                                         '     15','     10','     7.5','       5'}, ...
                                         'Value', '     30');
            set (Gui.ddSetExpNeur, 'Items',{'     -11','     -10','      -9', ...
                                       '      -8','      -7','      -6','      -5', ...
                                       '      -4','      -3','      -2'}, ...
                                       'Value', '      -6');                          
            set (Gui.ddSetGainNeur, 'Items',{'     255','     200','     150', ...
                                       '     125','     100','      75','      50'}, ...
                                       'Value', '     200');
    end
    
     % arrays to hold incoming image data block, and duplicate for transfer and save 
    Ctr.ImgBlckNeur = zeros(Dsp.vImgSizNeurX,Dsp.vImgSizNeurY,Ctr.NeurBlckFrms,'uint8');
    Ctr.ImgBlckNeurSav = zeros(Dsp.vImgSizNeurX,Dsp.vImgSizNeurY,Ctr.NeurBlckFrms,'uint8');
    
    % update size of image plot for video stream data
    arrFrmNeurSngl = zeros(Dsp.vImgSizNeurX,Dsp.vImgSizNeurY);
    figure (Dsp.hFigNeur)
    Dsp.hImgNeur = image(arrFrmNeurSngl);
    % turn off auto-update properties for faster refresh
    set(gca, 'xlimmode','manual',...
        'ylimmode','manual',...
        'zlimmode','manual',...
        'climmode','manual',...
        'alimmode','manual');
    set(gcf,'doublebuffer','off');
    % display properties
    set(Dsp.hImgNeur,'CDataMapping','scaled');
    set(gcf, 'Colormap', gray(256));
    vNeurDspLimLo = 0;
    vNeurDspLimHi = 255;
    set(gca,'CLim', [vNeurDspLimLo,vNeurDspLimHi]);
    set(gca,'Position',[0.1,0.13,0.8,0.8]);
    axis off;
    
    %% set frames available callback to grab each frame 
    vidNeur.FramesAcquiredFcnCount = 1;
    set (vidNeur,'FramesAcquiredFcn', {@fcnVidAcqV3_GetFrameNeur,vidNeur});
    
   %%
   disp('      > done.')


end
