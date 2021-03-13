function fcnVidAcqV3_SetFrmRateBhv(ddSetFrmRateBhv,~)
    
    global vidBhv
    global Gui
    global Ctr
    
    disp('   > setting frame rate on behavioral video channel...')
    
    % read from dropdown
    sFrmRate = Gui.ddSetFrmRateBhv.Value;
    vFrmRate = str2num(sFrmRate);
    
    disp(['      > set to ', num2str(vFrmRate)]);
    
    % set to selected value
    srcBhv = getselectedsource(vidBhv); 
        
    switch Gui.CamBhv
        case {'acA1300-200um (22993834)', 'acA1300-200um (23157464)'}
            srcBhv.AcquisitionFrameRate = vFrmRate;
        case {'c922 Pro Stream Webcam'}
            stop(vidBhv)
            srcBhv.Exposure = vFrmRate;  
            start(vidBhv)
        case {'USB Camera'}
            disp('   **** frame rate fixed at 30Hz for this sensor ****')
            vFrmRate = 30;
    end
    
    Ctr.BhvUpdateIntvl = round(vFrmRate/3);
    
    disp(['      > set to ', num2str(vFrmRate),' ; updating every ', ...
          num2str(Ctr.BhvUpdateIntvl), ' frames.'])
      

end

