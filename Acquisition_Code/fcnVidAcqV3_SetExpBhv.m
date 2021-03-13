function fcnVidAcqV3_SetExpBhv(ddSetExpBhv,~)
    
    global vidBhv
    global Gui
    
    disp('   > setting exposure on behavioral video channel...')
    
    % read from dropdown
    sExp = Gui.ddSetExpBhv.Value;
    vExp = str2num(sExp);
    
    % set to selected value
    srcBhv = getselectedsource(vidBhv);
    
    switch Gui.CamBhv
        case {'acA1300-200um (22993834)','acA1300-200um (23157464)'}
            srcBhv.ExposureTime = vExp*1000;
        case {'c922 Pro Stream Webcam'}
            stop(vidBhv)
            srcBhv.Exposure = vExp; 
            start(vidBhv)
        case {'USB Camera'}
            src.Exposure = vExp;
    end
    
    disp(['      > set to ', num2str(vExp)])

end
