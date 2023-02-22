%{
EGR102 HEADER COMMENT
Authors:    Alessandra Lozano , ID#12523364
Assignment: EGR 102- Machine Vision
Due Date:   December 12 2022
History:    December 1 2022
Purpose: Display image of coins in different capacities and then evaluating
the value of the coins.
  
%}

% read in the image 
image=imread('CoinsOnGreen.jpg');
% this will make your picture appear on the screen.
imshow(image)
% Use this tool to inspect your image
imtool(image);

% Mouse around the image
   g_channel=image(:,:,2);
    r_channel=image(:,:,1);
    b_channel=image(:,:,3);

rg_ratio=double(r_channel)./double(g_channel);% red green ratio
    bg_ratio=double(b_channel)./double(g_channel);% blue green ratio
    rg_ratio(isnan(rg_ratio))=0;% if it is nan it sets it to zero
    bg_ratio(isnan(bg_ratio))=0;% this should only happen if it is black

 g_bin=rg_ratio<0.7 ;
 % This gets rid of noise and turns the logical array into an image
    bw=bwareaopen(g_bin,50); % gets rid of object smaller than 50pixels area
   bw =~bw;
   
   %displays image in black and white
   imshow(bw)

 %gives area, major and minor diameter, and centroid of ever circle in
 %image and then sets it in the table
 stats = regionprops('table',bw,'Centroid', 'ConvexArea', 'MajorAxisLength','MinorAxisLength');

UsefulTable=stats{:,:};  % Turns stats in to an array

%converting diameters into radii
radii=UsefulTable(:,3)/2;
centers=UsefulTable(:,1:2);

%overlays circles over the original image
figure
    imshow(image)
    hold on
    viscircles(centers, radii);
    hold off

%subsetting array to only look at items that are coin based on the size
%difference 
realCoins=UsefulTable(:,5)>1000 & UsefulTable(:,5)<100000;
CoinTable=UsefulTable(realCoins,:);

%readjusts centers of the coins
newCenters=CoinTable(:,1:2);
newRadii=CoinTable(:,3)/2;

%displays image of the coins with overlay circles with new center
figure
    imshow(image)
    hold on
    viscircles(newCenters, newRadii);
    hold off

%looks at the distribution of the diameters
histogram(CoinTable(:,3),20);

%for loop that goes iterates over the table and assigns what type of coin 
%the change is
Change=0;
for index=1:length(newRadii)
    if newRadii(index) > 45
    Change=Change+0.25;     % Found a quarter
    elseif newRadii(index) >40
        Change=Change+0.05; % Found a nickel
    elseif newRadii(index)> 35.5
        Change=Change+0.01; % Found a penny
    else
        Change=Change+0.10;  % Found a dime
    end
end

%output statement with results
disp(' ');
fprintf('The value of the coins in the image is $%.2f \n',Change)
disp(' ');