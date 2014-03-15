%% Plots centroid; determines periodicity, but cannot track the stem

figure; imshow(croppedFrames(:, :, 20));  hold on;

x = [540 540];
y = [0 970] ;
plot(x, y, 'g'); 

for n=1:1:length(cCenters)
    cc = cCenters{n};
    if length(cc) == 2
        plot(cc(1), cc(2), '*r');
    end
    
    pause(1)
end


hold on; 

