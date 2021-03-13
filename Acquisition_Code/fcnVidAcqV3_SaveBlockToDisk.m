function fcnVidAcqV3_SaveBlockToDisk

global vidNeur
global vidBhv
global fileTs
global Ctr
global Dsp

    % save neural data if requested
    if Ctr.NeurFlgSav
                
        % transfer acquired image data to separate array to write to disk
        Ctr.ImgBlckNeurSav = Ctr.ImgBlckNeur;                                       % note this may be unnecessary - seems that save ties up processing until complete anyhow so re-zeroing not a concern
        
        % re-zero acquisition block
        Ctr.ImgBlckNeur = zeros(Dsp.vImgSizNeurX,Dsp.vImgSizNeurY,Ctr.BhvBlckFrms,'uint8');
        
        % generate string to append to filename for indexing
        strFileIdxNeur = num2str(Ctr.FileIndexNeur);
        if numel(strFileIdxNeur) == 1
            strFileIdxNeur = strcat('00',strFileIdxNeur);
        elseif numel(strFileIdxNeur) == 2
            strFileIdxNeur = strcat('0',strFileIdxNeur);
        end
        
        % eliminate zero (non-acquired) frames from pre-allocated block
        vNumNonZeroFrms = sum(squeeze(sum(Ctr.ImgBlckNeurSav,[1 2]))>0);
        if vNumNonZeroFrms < Ctr.NeurBlckFrms
            %vNumNonZeroFrms
            size(Ctr.ImgBlckNeurSav)
            Ctr.ImgBlckNeurSav = Ctr.ImgBlckNeurSav(:,:,1:vNumNonZeroFrms);
            size(Ctr.ImgBlckNeurSav)
        end
            
        % open binary file, save, close
        disp(['    > saving neural data to binary file :  ','vid_neur_',strFileIdxNeur,'.bin'])
        sFilNameVidNeur = ['E:\MiniscopeData\MATLAB\vid_',Ctr.sDirNam,'\vid_neur_',strFileIdxNeur,'.bin'];
        fid = fopen(sFilNameVidNeur,'w');
        fwrite(fid,Ctr.ImgBlckNeurSav);                                             % note 'Sav' version of variable may not be necessary?
        fclose(fid);
        %disp(['    > saved neural data to binary file :  ','vid_neur_',strFileIdxNeur,'.bin'])
        disp(['       > saved.'])
        
        % update counters
        Ctr.FileIndexNeur = Ctr.FileIndexNeur+1;
        Ctr.NeurFlgSav = 0;
        
%         % open videowriter file with appropriate format
%         sFilNameVidNeur = ['E:\MiniscopeData\MATLAB\vid_',Ctr.sDirNam,'\vid_neur_',strFileIdxNeur,'.avi'];
%         switch vidNeur.VideoFormat
%             case 'YUY2_752x480'
%                 vidWriterNeur = VideoWriter(sFilNameVidNeur, 'Uncompressed AVI');
%             case 'Mono8'
%                 vidWriterNeur = VideoWriter(sFilNameVidNeur, 'Grayscale AVI');
%         end
%         disp(['    > created AVI log file for neural data :  ','vid_neur_',strFileIdxNeur,'.avi'])
%         open(vidWriterNeur);
%         
%         % write all frames in current block
%         NonZeroFrms = sum(squeeze(sum(Ctr.ImgBlckNeurSav,[1 2]))>0);
%         for ii = 1:NonZeroFrms
%             writeVideo(vidWriterNeur,Ctr.ImgBlckNeurSav(:,:,ii))
%         end
%         close(vidWriterNeur)
%         disp(['    > data saved.'])
%         Ctr.FileIndexNeur = Ctr.FileIndexNeur+1;
%         Ctr.NeurFlgSav = 0;


    end

    % save behavioral data if requested 
    if Ctr.BhvFlgSav
        % transfer acquired image data to separate array to write to disk
        % (not sure if operations are asynchronous - but will allow image acq to continue during save).  
        Ctr.ImgBlckBhvSav = Ctr.ImgBlckBhv;
        
        %arrtmp = Ctr.ImgBlckBhvSav;
        %whos arrtmp
        %assignin('base','tstout1',Ctr.ImgBlckBhvSav);
        
        % re-zero acquisition block
        %Ctr.ImgBlckBhv = zeros(Dsp.vImgSizBhvY,Dsp.vImgSizBhvX,Ctr.BhvBlckFrms,'uint8');
        Ctr.ImgBlckBhv = Ctr.ImgBlckBhv * 0;  % zeros are used to save partial blocks at end of acquisition
        
        % generate string for indexing filenames (behavioral data)
        strFileIdxBhv = num2str(Ctr.FileIndexBhv);
        if numel(strFileIdxBhv) == 1
            strFileIdxBhv = strcat('00',strFileIdxBhv);
        elseif numel(strFileIdxBhv) == 2
            strFileIdxBhv = strcat('0',strFileIdxBhv);
        end
        
        % eliminate zero (non-acquired) frames from pre-allocated block
        %vNumNonZeroFrms = sum(squeeze(sum(Ctr.ImgBlckBhvSav,[1 2 3]))>0);
        vNumNonZeroFrms = sum(Ctr.ImgBlckBhvSav(1,1,1,:)>0);
        if vNumNonZeroFrms < Ctr.BhvBlckFrms
            Ctr.ImgBlckBhvSav = Ctr.ImgBlckBhvSav(:,:,:,1:vNumNonZeroFrms);
        end
        
        % open binary file, save, close
        disp(['    > saving behavior data to binary file :  ','vid_bhav_',strFileIdxBhv,'.bin'])
        sFilNameVidBhv = ['E:\MiniscopeData\MATLAB\vid_',Ctr.sDirNam,'\vid_bhav_',strFileIdxBhv,'.bin'];
        fid = fopen(sFilNameVidBhv,'w');
        fwrite(fid,Ctr.ImgBlckBhvSav);                                             % note 'Sav' version of variable may not be necessary?
        fclose(fid);
        disp(['       > saved.'])
        
        
        
        % update counters
        Ctr.FileIndexBhv = Ctr.FileIndexBhv+1;
        Ctr.BhvFlgSav = 0;
        
%         % open videowriter file with appropriate format
%         %sFilNameBhv = ['E:\MiniscopeData\MATLAB\vid_',sDirNam,'\vid_bhav_',sDirNam,'.avi'];
%         sFilNameVidBhv = ['E:\MiniscopeData\MATLAB\vid_',Ctr.sDirNam,'\vid_bhav_',strFileIdxBhv,'.avi'];
%         switch vidBhv.VideoFormat
%             case 'YUY2_752x480'
%                 vidWriterBhv = VideoWriter(sFilNameVidBhv, 'Uncompressed AVI');
%             case 'Mono8'
%                 % option 1 - uncompressed grayscale AVI
%                 vidWriterBhv = VideoWriter(sFilNameVidBhv, 'Grayscale AVI');
%                 % option 2 - motion JPEG compression (uses single color channel)
%                 %vidWriterBhv = VideoWriter(sFilNameBhv, 'Motion JPEG 2000');
%                 %vidWriterBhv.CompressionRatio = 5;  % default = 10; range not specified.
%                 % option 3 - uncompressed grayscale AVI
%                 %vidWriterBhv = VideoWriter(sFilNameBhv, 'Motion JPEG AVI');
%                 %vidWriterBhv.Quality = 90;
%                 % option 4 - MPEG-4 (H.264) (uses 3 color channels)
%                 %vidWriterBhv = VideoWriter(sFilNameBhv, 'MPEG-4');
%             case 'MJPG_800x600'
%                 vidWriterBhv = VideoWriter(sFilNameVidBhv, 'Motion JPEG AVI');
%                 vidWriterBhv.Quality = 90;
%             case 'MJPG_1920x1080'
%                 vidWriterBhv = VideoWriter(sFilNameVidBhv, 'Motion JPEG AVI');
%                 vidWriterBhv.Quality = 90;
%         end
%         disp(['    > created AVI log file for behavioral data :  ','vid_bhav_',strFileIdxBhv,'.avi'])
%         open(vidWriterBhv);
%         % write all frames in current block
%         NonZeroFrms = sum(squeeze(sum(Ctr.ImgBlckBhvSav,[1 2]))>0);
        
%         x = size(Ctr.ImgBlckBhvSav,1)
%         y = size(Ctr.ImgBlckBhvSav,2)
%         col = size(Ctr.ImgBlckBhvSav,3)
%         nfrms = size(Ctr.ImgBlckBhvSav,4)
%          
%         for ii = 1:NonZeroFrms
%             writeVideo(vidWriterBhv,Ctr.ImgBlckBhvSav(:,:,ii))
%         end
%         close(vidWriterBhv)
        
        

        
    end


end



