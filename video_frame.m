function outputVideoObject = video_frame(inputVideoObject, interp, max_iter)

originalNumberOfFrames = inputVideoObject.NumberOfFrames;
originalFrameRate = inputVideoObject.FrameRate;
vidHeight = inputVideoObject.Height;
vidWidth = inputVideoObject.Width;

newNumberOfFrames = originalNumberOfFrames*interp;

inputPixelMap = zeros(vidHeight, vidWidth, originalNumberOfFrames);
outputPixelMap = zeros(vidHeight, vidWidth, newNumberOfFrames);

bandwidth = 0.8;        % This needs to be a number between 0.5 to 1
h = waitbar(0,'Reading input video')
for frameNumber=1:originalNumberOfFrames
    inputPixelMap(:,:,frameNumber) = rgb2gray(double(read(inputVideoObject, 50))/255);
    % TODO: see if any need for converting to grayscale
    waitbar(frameNumber/originalNumberOfFrames);
end
close(h)

h = waitbar(0,'Interpolating Video Signal')
for i=1:vidHeight
    for j=1:vidWidth
        outputPixelMap(i,j,:) = pg_1d(inputPixelMap(i,j,:), bandwidth, interp, max_iter);
    end
    waitbar(i/(vidHeight));
end
close(h)

outputVideoObject = VideoWriter('new video.mov');
outputVideoObject.FrameRate = originalFrameRate*interp;
% 
% outputVideoObjectBackup = VideoWriter('new video 2.mov');
% outputVideoObjectBackup.FrameRate = originalFrameRate*interp;
% % open(outputVideoObjectBackup);

outputPixelMapTemp = outputPixelMap;
outputPixelMap(outputPixelMap > 1) = 1;
outputPixelMap(outputPixelMap < 0) = 0;
% for frameNumber=1:newNumberOfFrames    
%     frame = outputPixelMap(:,:,frameNumber)*255;
%     writeVideo(outputVideoObjectBackup, im2uint8(frame));
% end
% close(outputVideoObjectBackup)

open(outputVideoObject);
%outputPixelMapTemp = outputPixelMap;
%outputPixelMap(outputPixelMap > 1) = 1;
%outputPixelMap(outputPixelMap < 0) = 0;
    
for frameNumber=1:newNumberOfFrames
    %Convert Image to movie Frame
    
    frame = outputPixelMap(:,:,frameNumber);
    writeVideo(outputVideoObject, im2uint8(frame));
    
    
end
temp2 =2;
close(outputVideoObject);

temp1 = 1;