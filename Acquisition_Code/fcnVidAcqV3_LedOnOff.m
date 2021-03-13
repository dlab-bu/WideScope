function fcnVidAcqV3_LedOnOff(btn,~)
    
    global Daq
    
    %if hBtnStreamBhv.Value
    if btn.Value
        disp('    > turning LED on...')
        Daq.sess.outputSingleScan(Daq.vLedVlt);
        Daq.vFlgLedPwr = 1;
        %disp([Daq.vLedPct Daq.vLedVlt])
    else
        disp('    > turning LED off...')
        Daq.sess.outputSingleScan(5);
        %Daq.vFlgLedPwr = 0;
    end
    
    
    
end

