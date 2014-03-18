function plotMatches(matches, Ia, Ib, fa, fb)
% Plots SIFT matches between two images.  Code based on
% http://stackoverflow.com/questions/13305416/...
%getting-stuck-on-matlabs-subplot-mechanism-for-matching-images-points-for-vlfe/...
%13308950#13308950

if (size(Ia,1) > size(Ib,1))
    longestWidth = size(Ia,1);
else
    longestWidth = size(Ib,1);
end

if (size(Ia,2) > size(Ib,2))
    longestHeight = size(Ia,2);
else
    longestHeight = size(Ib,2);
end


% create new matrices with longest width and longest height
newim = uint8(zeros(longestWidth, longestHeight)); %3 cuz image is RGB
newim2 = uint8(zeros(longestWidth, longestHeight));

% transfer both images to the new matrices respectively.
newim(1:size(Ia,1), 1:size(Ia,2)) = Ia;
newim2(1:size(Ib,1), 1:size(Ib,2)) = Ib;

% with the same proportion and dimension, we can now show both
% images. Parts that are not used in the matrices will be black.
imshow([newim newim2]);

hold on;

X = zeros(2,1);
Y = zeros(2,1);

% draw line from the matched point in one image to the respective matched point in another image.
for k=1:numel(matches(1,:))
    
    X(1) = fa(1, matches(1, k));
    Y(1) = fa(2, matches(1, k));
    X(2) = fb(1, matches(2, k)) + longestHeight; % for placing matched point of 2nd image correctly.
    Y(2) = fb(2, matches(2, k));
    
    line(X,Y, 'Color', [0 1 0]);
    
end
end