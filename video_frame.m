% Generates the input video taking every 4th sample; interpolates it by
% factor of 2
function outputVideoObject = video_frame(originalVideoObject, interp, max_iter)

%% reading video and generating pixel maps
originalNumberOfFrames = originalVideoObject.NumberOfFrames;
originalFrameRate = originalVideoObject.FrameRate;
vidHeight = originalVideoObject.Height;
vidWidth = originalVideoObject.Width;

inputNumberOfFrames = floor(originalNumberOfFrames/4);
outputNumberOfFrames = inputNumberOfFrames*interp;

%originalPixelMap = zeros(vidHeight, vidWidth, originalNumberOfFrames);
inputPixelMap = zeros(vidHeight, vidWidth, inputNumberOfFrames);
outputPixelMap = zeros(vidHeight, vidWidth, outputNumberOfFrames);

bandwidth = 0.8;        % This needs to be a number between 0.5 to 1
h = waitbar(0,'Reading input video');
for frameNumber=1:inputNumberOfFrames
    inputPixelMap(:,:,frameNumber) = rgb2gray(double(read(originalVideoObject, 4*frameNumber))/255);
    % TODO: see if any need for converting to grayscale
    waitbar(frameNumber/inputNumberOfFrames);
end
close(h)

%% Preforming the PG interpolation
h = waitbar(0,'Interpolating Video Signal');
for i=1:vidHeight
    for j=1:vidWidth
        outputPixelMap(i,j,:) = pg_1d(inputPixelMap(i,j,:), bandwidth, interp, max_iter);
    end
    waitbar(i/(vidHeight));
end
close(h)

%% storing the input video
inputVideoObject = VideoWriter('inputvideo.mov');
inputVideoObject.FrameRate = originalFrameRate/4;

open(inputVideoObject);
for frameNumber=1:inputNumberOfFrames
    %Convert Image to movie Frame
    frame = inputPixelMap(:,:,frameNumber);
    writeVideo(inputVideoObject, im2uint8(frame));
end
close(inputVideoObject);

%% storing the output video
% restricting pixel values between 0 and 1
outputPixelMap(outputPixelMap > 1) = 1;
outputPixelMap(outputPixelMap < 0) = 0;

outputVideoObject = VideoWriter('outputvideo.mov');
outputVideoObject.FrameRate = originalFrameRate*interp/4;
open(outputVideoObject);
    
for frameNumber=1:outputNumberOfFrames
    %Convert Image to movie Frame
    frame = outputPixelMap(:,:,frameNumber);
    writeVideo(outputVideoObject, im2uint8(frame));
end
close(outputVideoObject);