function [Cams] = fcnVidAcqV3_GetCamList
    
    disp('   > scanning for attached GENTL and WINVIDEO cameras') 
    camInfo = imaqhwinfo;
    vNumAdaptors = size(camInfo.InstalledAdaptors,2);
    vNumCamsTot = 0; 
    for ii = 1:vNumAdaptors
        if strcmp(camInfo.InstalledAdaptors(ii),'gentl')
            gentlInfo = imaqhwinfo('gentl');
            vNumCamsGentl = size(gentlInfo.DeviceIDs,2);
            for jj = 1:vNumCamsGentl
                Cams.ListCamsAll(jj+vNumCamsTot) = {gentlInfo.DeviceInfo(jj).DeviceName};
                Cams.ListAdaptersAll(jj+vNumCamsTot) = {'gentl'};
                Cams.ListDeviceIDsAll(jj+vNumCamsTot) = jj;
                Cams.ListMenu(jj+vNumCamsTot) = strcat({' (#'},num2str(jj+vNumCamsTot), ...
                      {') - '}, Cams.ListCamsAll(jj+vNumCamsTot), '  (gentl)');
            end
            vNumCamsTot = vNumCamsTot + vNumCamsGentl;
        end
        if strcmp(camInfo.InstalledAdaptors(ii),'winvideo')
            winvideoInfo = imaqhwinfo('winvideo');
            vNumCamsWinvideo = size(winvideoInfo.DeviceIDs,2);
            for jj = 1:vNumCamsWinvideo
                Cams.ListCamsAll(jj+vNumCamsTot) = {winvideoInfo.DeviceInfo(jj).DeviceName};
                Cams.ListAdaptersAll(jj+vNumCamsTot) = {'winvideo'};
                Cams.ListDeviceIDsAll(jj+vNumCamsTot) = jj;
                Cams.ListMenu(jj+vNumCamsTot) = strcat({' (#'}, num2str(jj+vNumCamsTot), ...
                      {') - '}, Cams.ListCamsAll(jj+vNumCamsTot), '  (winvideo)');
            end
            vNumCamsTot = vNumCamsTot + vNumCamsWinvideo;
        end
    end    
    
    % output list to history
    Cams.vNumCams = vNumCamsTot;
    disp(['   > found ',num2str(Cams.vNumCams),' cameras available : '])
    for ii = 1:Cams.vNumCams
        disp(['       > ', cell2mat(Cams.ListAdaptersAll(ii)), ' # ', ...
              num2str(Cams.ListDeviceIDsAll(ii)), ' : ', ...
              cell2mat(Cams.ListCamsAll(ii))])
    end
    
end
