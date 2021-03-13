function fcnVidAcqV3_DaqInit
    
    global Daq
    
    % start DAQ session, add single analog out channel
    Daq.sess = daq.createSession('ni');
    Daq.chAiOut = addAnalogOutputChannel(Daq.sess,'Dev1','ao0','Voltage');
    
    % set to 5V to zero LED output on startup
    Daq.sess.outputSingleScan(5);
    
end

