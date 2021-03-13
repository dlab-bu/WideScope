function fcnVidAcqV3_DropPellet(hBtnPellet,~)

    % button callback:  play masking audio sound, drop pellet

    global Gui
    global Daq
    
    disp('   > playing audio mask / dropping pellet') 
    
    % change button color while operating 
    %set (Gui.hBtnPellet, 'BackgroundColor', [1 0.7 0.7]);
    set (hBtnPellet, 'BackgroundColor', [1 0.7 0.7]);
    
    % play sound
    sound(Daq.arrAudOut, Daq.Fs);
    
    % change button color back to normal
    %set (Gui.hBtnPellet, 'BackgroundColor', [0.95 0.95 0.95]);
    set (hBtnPellet, 'BackgroundColor', [0.95 0.95 0.95]);   
    
end

