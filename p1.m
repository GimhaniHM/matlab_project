I=imread('v3.jpg');    %read the image
subplot(3,3,1),imshow(I),title('Original image');

I1 = rgb2gray(I); %convert to grayscale
subplot(3,3,2),imshow(I1),title('Grayscale image');

I2 = imadjust(I1,[],[],2); %adjust image
subplot(3,3,3),imshow(I1),title('Adjusted Image');

I3 = im2bw(I2,graythresh(I2)); %convert to binary
subplot(3,3,4),imshow(I3),title('Binary Image');

% imtool(I3)  %display image with info

I_crop = I3(76:123,99:202);  %crop the image
subplot(3,3,5),imshow(I_crop),title('Cropped Image');

I_part1 = I3(76:101,99:202);

subplot(3,3,6),imshow(I_part1),title('First dose');

hold on

[B1] = bwboundaries(I_part1,'noholes');

for i=1:length(B1)
    boundary = B1{i};
    plot(boundary(:,2),boundary(:,1),'b','linewidth',1)
end
%z = imcomplement(I_part1);
%subplot(3,3,7),imshow(I_part1),title('First dose');

[L1 , B1_ob_num] = bwlabel(I_part1, 8); 

I_part2 = I3(101:123,99:202);
subplot(3,3,7),imshow(I_part2),title('Second dose');

hold on

[B2] = bwboundaries(I_part2,'holes');

for i=1:length(B2)
    boundary = B2{i};
    plot(boundary(:,2),boundary(:,1),'r','linewidth',1)
end

[L1 , B2_ob_num] = bwlabel(I_part2, 8); 

if((B1_ob_num ~= 0) && (B2_ob_num ~= 0))
    fprintf('\n\tBoth doses are taken');
elseif(B1_ob_num ~= 0)
    fprintf('\n\tOne dose is only taken');
end

fprintf('\n')
    
