function fcnVidAcqV3_DaqClose
    
    global Daq
    % set output to 5V to zero LED output on close
    Daq.sess.outputSingleScan(5);
    % end session
    release(Daq.sess);
    disp('   > closed DAQ session.')
    
end

