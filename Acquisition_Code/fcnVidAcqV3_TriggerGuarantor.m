function fcnVidAcqV3_TriggerGuarantor(vidObj)

    % triggering and starting the UCLA sensor / DAQ can be unreliable.
    % try 5 consecutive times; report error and stop if all fail.
    
    for f = 1:5
        trigger(vidObj)
        pause(0.5)
        if vidObj.FramesAcquired > 0
            disp(['      > running; ', num2str(vidObj.FramesAcquired), ' frames acquired in 500 ms after trigger.'])
            break
        else
            disp(['      > trigger failed on attempt # ', num2str(f), ' of 5'])
            disp('       > stopping vidObj, which takes forever during a failure.')
            stop(vidObj)
            wait(vidObj)
            disp('      > stopped.')
            if f == 5
                disp('   > Trigger failed 5 consecutive times. Retry or redo cam selection.')
            end
        end
    end 

end
