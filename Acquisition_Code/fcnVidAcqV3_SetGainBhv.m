function fcnVidAcqV3_SetGainBhv(ddSetGainBhv,~,Cams)
    
    global vidBhv
    global Gui
    
    disp('   > setting gain on behavioral video channel...')
    
    % read from dropdown
    sGain = Gui.ddSetGainBhv.Value;
    vGain = str2num(sGain);
    
    % set to selected value
    srcBhv = getselectedsource(vidBhv);
    
    switch Gui.CamBhv
        case {'acA1300-200um (22993834)', 'acA1300-200um (23157464)'}
            srcBhv.Gain = vGain;
        case {'c922 Pro Stream Webcam'}
            stop(vidBhv);
            pause(0.3);
            srcBhv.Gain = vGain; 
            pause(0.3);
            start(vidBhv)
        case {'USB Camera'}
            stop(vidBhv);
            pause(1);
            srcBhv.Gain = vGain; 
            pause(1);
            start(vidBhv)
    end
    
    disp(['      > set to ', num2str(vGain)])

end
