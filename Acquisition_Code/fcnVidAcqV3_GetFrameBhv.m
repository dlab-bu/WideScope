function fcnVidAcqV3_GetFrameBhv(obj,event,~)
    
    global Ctr
    global Dsp
    global vidBhv
    global fileTs

    if islogging(vidBhv)
        
        % read last frame data
        [arrFrmBhvSngl, tsBhv, metadata] = getdata(vidBhv,1);
        
        % convert to 8 bit (can revisit if more bit depth needed)
        arrFrmBhvSngl = uint8(arrFrmBhvSngl);
        
        % adjust timestamp to relative time from acquisition start
        tsBhv = etime(metadata.AbsTime, Ctr.MainTime);
        
        % if flag is set for disk logging
        if Ctr.FlgLogging
            
            %disp([tsBhv, Ctr.BhvBlckCurrFrm])
             
            % write timestamp to text file    
            fprintf(fileTs(2), [num2str(tsBhv),'\n']);
            % and transfer image data to the disk storage array
            Ctr.ImgBlckBhv(:,:,:, Ctr.BhvBlckCurrFrm) = arrFrmBhvSngl;
            % increment counter tracking frame # in current write block
            Ctr.BhvBlckCurrFrm = Ctr.BhvBlckCurrFrm + 1;
            % if exceeds max for block, then reset to 1 and write current block
            if Ctr.BhvBlckCurrFrm > Ctr.BhvBlckFrms
                Ctr.BhvBlckCurrFrm = 1;
                Ctr.BhvFlgSav = 1;
                fcnVidAcqV3_SaveBlockToDisk;
            end
        end
        
        % update realtime image (every Nth frame)
        if size(arrFrmBhvSngl,3)
            Ctr.BhvUpdate = Ctr.BhvUpdate + 1;
            if Ctr.BhvUpdate>Ctr.BhvUpdateIntvl
                set (Dsp.hImgBhv,'CData',arrFrmBhvSngl);
                % calculate histogram info if requested
                %if vFlgHist
                %  arrHist = sum(histc(arrFrmBhvSngl,arrHstBins),2);
                %  %arrHist = sum(arrImgHist,2)';
                %  set (hPltHst,'YData',arrHist);
                %end
                drawnow;
                Ctr.BhvUpdate = 1;
            end
        
    end
    
end