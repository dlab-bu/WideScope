function fcnVidAcqV3_LedCtrl(sld,~)
    
    global Daq
    global Gui
    
    % get percentage intensity value from slider
    Daq.vLedPct = round(sld.Value);
    sld.Value = Daq.vLedPct;
    
    %convert to control voltage appropriate for buckpuck
    Daq.vLedVlt = 4.35-(2.7*(Daq.vLedPct/100));
    
    % update Aout voltage level
    if Daq.vFlgLedPwr
        Daq.sess.outputSingleScan(Daq.vLedVlt);
        disp(['    > set LED power: ', num2str(Daq.vLedPct),' % ; ', num2str(Daq.vLedVlt), ' V'])
    end
   
    % update percentage on control panel
    Gui.hTxtLedPct.Text = num2str(Daq.vLedPct);
    %set(S_PnlCtrls.hTxtLedVlt,'String',num2str(S_PnlCtrls.vLedVlt));
    
end

