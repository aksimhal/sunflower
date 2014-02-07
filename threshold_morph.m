%% Threshold & Track
dbstop if error;
close all; 
inputArraySize = size(croppedFrames);

%% Threshold Frames
binaryArray = false(size(croppedFrames));

for n = 1:1:inputArraySize(3)
    thresoldValue  = graythresh(croppedFrames(:, :, n));
    binaryArray(:, :, n)   = im2bw(croppedFrames(:, :, n), thresoldValue);
    
    img = binaryArray(:, :, n);
    %figure; imshow(img); title('original bw image'); 
    IL = bwlabel(img);
    R = regionprops(img,'Area', 'centroid');
    ind = find([R.Area] >= 150000);
    Iout = ismember(IL,ind);
    imshow(Iout); title(num2str(n)); 
    centroids = cat(1, R.Centroid);
    hold on
    plot(centroids(ind,1), centroids(ind,2), 'r*')
    cCenters{n} = centroids(ind, :);
    pause(0.001);
    drawnow;
    hold off
    binaryArray(:, :, n) = Iout;
end