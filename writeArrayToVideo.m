function writeArrayToVideo( filename, inputArray, framerate )
%writeArrayToVideo Writes array to video 
%grayscale video only 
%   (r, c, nframes)

xout = VideoWriter(filename);
xout.FrameRate = framerate;
open(xout);
%Output to video
vidSize = size(inputArray);
for k = 1 : vidSize(3)
    writeVideo(xout, inputArray(:, :, k));
    if mod(k, 40) == 0
        fprintf('writing frame %d \n', k);
    end
end
xout.close;


end

