function fcnVidAcqV3_SetExpNeur(ddSetExpNeur,~)
    
    global vidNeur
    global Gui
    
    disp('   > setting exposure on neural imaging channel...')
    
    % read from dropdown
    sExp = Gui.ddSetExpNeur.Value;
    vExp = str2num(sExp);
    
    % set to selected value
    srcNeur = getselectedsource(vidNeur);
    srcNeur.Exposure = vExp;
    
    disp(['      > set to ', num2str(vGain)])

end
