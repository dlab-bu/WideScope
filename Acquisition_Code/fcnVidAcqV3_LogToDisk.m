function fcnVidAcqV3_LogToDisk(hBtnLogToDisk,~)

    global vidNeur
    global vidBhv
    global fileTs
    global Ctr
    global Dsp

    % if logging is being set to ON
    if hBtnLogToDisk.Value
    
        % create new folder to hold video data
        disp('    > starting data logging.')
        sFmtOut = 'yyyy-mm-dd_tHH-MM-SS';
        Ctr.sDirNam = ['d',datestr(now,sFmtOut)];
        %sFilNam = ['d',datestr(now,sFmtOut)];
        mkdir ('E:\MiniscopeData\MATLAB\', ['vid_',Ctr.sDirNam]);
        mkdir ('E:\MiniscopeData\MATLAB\', ['vid_',Ctr.sDirNam,'\acq_params']);
        disp('       > created data folders.')
         
        if ~Ctr.clockset
            disp('       > reset main clock to zero timestamps.')
            Ctr.MainTime = clock;
            Ctr.clockset = 1;
        end
        
        % save text file with neural imaging metadata (xy size, color depth, number of frames)
        x = size(Ctr.ImgBlckNeur,1);
        y = size(Ctr.ImgBlckNeur,2);
        %cdpth = size(Ctr.ImgBlckNeur,3);
        cdpth = 1;
        nfrms = Ctr.NeurBlckFrms;
        fMetaData = fopen(['E:\MiniscopeData\MATLAB\vid_',Ctr.sDirNam,'\acq_params\imgsiz_neur_',Ctr.sDirNam,'.txt'],'w'); 
        fprintf(fMetaData, [num2str(x),'\n']);
        fprintf(fMetaData, [num2str(y),'\n']);
        fprintf(fMetaData, [num2str(cdpth),'\n']);
        fprintf(fMetaData, [num2str(nfrms),'\n']);
        fclose(fMetaData);
        
        % save text file with behavior imaging metadata (xy size, color depth, number of frames)
        x = size(Ctr.ImgBlckBhv,1);
        y = size(Ctr.ImgBlckBhv,2);
        cdpth = size(Ctr.ImgBlckBhv,3);
        nfrms = Ctr.BhvBlckFrms;
        fMetaData = fopen(['E:\MiniscopeData\MATLAB\vid_',Ctr.sDirNam,'\acq_params\imgsiz_bhav_',Ctr.sDirNam,'.txt'],'w'); 
        fprintf(fMetaData, [num2str(x),'\n']);
        fprintf(fMetaData, [num2str(y),'\n']);
        fprintf(fMetaData, [num2str(cdpth),'\n']);
        fprintf(fMetaData, [num2str(nfrms),'\n']);
        fclose(fMetaData);
               
        % open text files for writing timestamps
        fileTs(1) = fopen(['E:\MiniscopeData\MATLAB\vid_',Ctr.sDirNam,'\acq_params\ts_neur_',Ctr.sDirNam,'.txt'],'w');
        fileTs(2) = fopen(['E:\MiniscopeData\MATLAB\vid_',Ctr.sDirNam,'\acq_params\ts_bhv_',Ctr.sDirNam,'.txt'],'w');

        % reset counters tracking # of files saved
        Ctr.FileIndexNeur = 1;
        Ctr.FileIndexBhv = 1;
        Ctr.BhvBlckCurrFrm = 1;
        Ctr.NeurBlckCurrFrm = 1;

        % set disk logging flag to high (will start storing data in arrays for block save); start timer
        Ctr.FlgLogging = 1; 
        disp('       > logging set to ON.')

        tic

    % otherwise if logging is being set to OFF
    else
    
        % stop logging by setting flag to low
        Ctr.FlgLogging = 0;

        % close text files for logging timestamps
        fclose(fileTs(1));
        fclose(fileTs(2));

        if Ctr.clockset
            Ctr.clockset = 0;
        end
    
        % clean up remaining frames since last save
        Ctr.BhvFlgSav = 1;
        Ctr.NeurFlgSav = 1;
        fcnVidAcqV3_SaveBlockToDisk;
    
        % output total elapsed time to history
        disp(['    > logging completed.'])
        disp(['    > logged to disk for ',num2str(toc),' sec.'])
    
        % re-zero acquisition block
        Ctr.ImgBlckNeur = Ctr.ImgBlckNeur * 0;
        Ctr.ImgBlckBhv = Ctr.ImgBlckBhv * 0;

        Ctr.BhvBlckCurrFrm = 1; 
        Ctr.NeurBlckCurrFrm = 1;

    end

end



