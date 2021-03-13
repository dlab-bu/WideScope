function fcnVidAcqV3_StreamBhvOnOff(btn,~)
    
    global Ctr
    global vidBhv
    
    if btn.Value
        disp('    > turning behavioral data streaming on...')
        Ctr.Bhv = 1;
        Ctr.BhvUpdate = 1;
        flushdata(vidBhv);
        start(vidBhv)
        disp('       > started.')
        trigger(vidBhv)
    else
        disp('    > turning behavioral data streaming off...')
        flushdata(vidBhv);
        stop(vidBhv);
        wait(vidBhv);
        disp('       > stopped.')
    end
    
end

