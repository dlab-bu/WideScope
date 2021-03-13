function fcnVidAcqV3_SetFrmRateNeur(ddSetFrmRateNeur,~)
    
    global vidNeur
    global Gui
    global Ctr
    
    disp('   > setting frame rate on neural imaging channel...')
    
    % read from dropdown
    sFrmRate = Gui.ddSetFrmRateNeur.Value;
    vFrmRate = str2num(sFrmRate);
    
    % set to selected value
    srcNeur = getselectedsource(vidNeur);
    
    switch Gui.CamNeur
        case {'MINISCOPE'}
            disp('    > unable to set frame rate via MATLAB')
            %Ctr.NeurUpdateIntvl = 10;
            vFrmRate = 60;
        case {'acA1300-200um (22993834)'}
            srcNeur.AcquisitionFrameRate = vFrmRate;
            %Ctr.NeurUpdateIntvl = round(vFrmRate/10);
        case {'c922 Pro Stream Webcam'}
            srcNeur.Exposure = vFrmRate;
            %Ctr.NeurUpdateIntvl = round(vFrmRate/10);
    end
    
    Ctr.NeurUpdateIntvl = round(vFrmRate/3);
    
%     switch Gui.CamBhv
%         case {'acA1300-200um (22993834)'}
%             srcBhv.ExposureTime = vExp*1000;
%         case {'c922 Pro Stream Webcam'}
%             srcBhv.Exposure = vExp;  
%     end
    
    disp(['      > set to ', num2str(vExp)])

end
