function fcnVidAcqV3_StreamNeurOnOff(btn,~)
    
    global Ctr
    global vidNeur
    
    if btn.Value
        disp('    > turning neural data streaming on...')
        %         Ctr.Neur = 1;
        %         Ctr.vidNeur.CtrUpdate = 1;
        flushdata(vidNeur);
        start(vidNeur)
        fcnVidAcqV3_TriggerGuarantor(vidNeur)
        disp('       > done.')        
    else
        disp('    > turning neural data streaming off...')
        flushdata(vidNeur);
        stop(vidNeur)
        wait(vidNeur)
        disp('       > done.')
    end
    
end

