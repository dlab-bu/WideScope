function fcnVidAcqV3_SetGainNeur(ddSetGainNeur,~,Cams)
    
    global vidNeur
    global Gui
    
    disp('   > setting gain on neural imaging channel...')
    
    % read from dropdown
    sGain = Gui.ddSetGainNeur.Value;
    vGain = str2num(sGain);
    
    % set to selected value
    srcNeur = getselectedsource(vidNeur);
    
    switch Gui.CamBhv
        case {'MINISCOPE'}
            srcNeur.Gain = vGain;
        case {'c922 Pro Stream Webcam'}
            stop(vidNeur);
            pause(0.3);
            srcNeur.Gain = vGain; 
            pause(0.3);
            start(vidNeur)
    end
    
    disp(['      > set to ', num2str(vGain)])

end

