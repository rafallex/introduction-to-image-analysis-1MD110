
% Specify Video to be read in
video_in = 'source_sequence.avi';
% Initialize Video Reader
utilities.videoReader = VideoReader(video_in);

% Specify name for output video
video_out = 'Tracks.avi';
% Initialize Video writer
utilities.videoFWriter = vision.VideoFileWriter(video_out,'FrameRate',30);

% Compress the output video as it will be very big if you don't. The
% compression options depend on your operating system, so maybe you will
% need to use the following instead of the current settings:
% utilities.videoFWriter.VideoCompressor='DV Video Encoder';
% for further details see: 
% https://se.mathworks.com/help/vision/ref/vision.videofilewriter-system-object.html
utilities.videoFWriter.VideoCompressor='MJPEG Compressor';

% Initialize video player if you want to watch video with tracking results
% while running the code (will slow down code significantly of course)
utilities.videoPlayer=vision.VideoPlayer('Position',[100,100,500,400]);


% Get number of frames
N_frames=utilities.videoReader.NumberOfFrames;

% Loop through frames
for i=1:N_frames
    % Read in next frame
    frame = read(utilities.videoReader,i);
    
    
    
    % Process frame
    % (for example feature extraction, segmentation, object detection...)
    % ...
    %
    
    
    
    % here we have three points wandering through the video, such that you
    % can see how you can do the annotations in the video
    trackedLocation=[1+i,1; 2,2+i; 3+i,3+i];
    
    % mark the position in every tenth frame for example
    if mod(i,10)
    if ~isempty(trackedLocation)
        shape = 'circle';
        region = trackedLocation;
        region(:, 3) = 5;
        label=1:1:length(trackedLocation(:,1));
        combinedImage = insertObjectAnnotation(frame,shape,...
            region, label, 'Color', 'red');
    end
    end
    
    % Take a step in playing the video with tracks if you want to watch it
    % while running the code
    
    step(utilities.videoPlayer, combinedImage);
    step(utilities.videoFWriter,combinedImage);
    
end


% Release and close all video related objects
release(utilities.videoPlayer);
release(utilities.videoFWriter);


