function fcnVidAcqV3_GetFrameNeur(obj,event,~)
    
    global Ctr
    global Dsp
    global vidNeur
    global fileTs
    
    if islogging(vidNeur)
        
        % read last frame data
        [arrFrmNeurSngl, tsNeur, metadata] = getdata(vidNeur,1);
        tsNeur = etime(metadata.AbsTime, Ctr.MainTime);

        % convert to 8-bit for grayscale and update display
        arrFrmNeurSngl = uint8(arrFrmNeurSngl);
        Ctr.NeurUpdate = Ctr.NeurUpdate + 1;
        if Ctr.NeurUpdate>Ctr.NeurUpdateIntvl
            set (Dsp.hImgNeur,'CData',arrFrmNeurSngl);
            % calculate histogram info if requested
            %if vFlgHist
            %  arrHist = sum(histc(arrFrmNeurSngl,arrHstBins),2);
            %  %arrHist = sum(arrImgHist,2)';
            %  set (hPltHst,'YData',arrHist);
            %end
            drawnow;
            Ctr.NeurUpdate = 1;
        end
        
        % if logging to disk, write into image block array     
        %if strcmp(vidNeur.LoggingMode,'disk&memory')
        if Ctr.FlgLogging
            fprintf(fileTs(1), [num2str(tsNeur),'\n']);
            Ctr.ImgBlckNeur(:,:,Ctr.NeurBlckCurrFrm) = arrFrmNeurSngl;
            Ctr.NeurBlckCurrFrm = Ctr.NeurBlckCurrFrm+1;
            if Ctr.NeurBlckCurrFrm > Ctr.NeurBlckFrms
                Ctr.NeurBlckCurrFrm = 1;
                Ctr.NeurFlgSav = 1;
                fcnVidAcqV3_SaveBlockToDisk;
            end
        end
        
    end
end