%Code assignment 1
%Psy 627
%Jenna Pablo
%Code buddy: L. Kemmelmeier

%% Dictate paths
base_dir = pwd; 
disp(base_dir)
image_path = '/datasets/fLoc_stimuli';
image_dir = fullfile(base_dir,image_path);
disp(image_dir) 
%easier to change image_dir below:
%image_dir = '/Users/jennapablo/Documents/Psy 627/datasets/fLoc_stimuli';
disp(exist(image_dir,'dir')) %output 7=folder exists
%% Created a sorted list of all images in that folder
%list all .jpg files
all_image = dir(fullfile(image_dir,'*.jpg')); 
%extract names of all images; automatically alphabetized
all_image_names = {all_image.name}; 


%% Select a random sample of 12 images
%get total number of images
num_images = length(all_image_names);
%from the total, select 12 random indices
num_rand_images = 12; %choose X random images
%randperm - generates X(num_rand_images)options and chooses from 1 to X(num_images) 
rng('shuffle'); %shuffles the seed for randomization purposes
rand_indices = randperm(num_images,num_rand_images); 
%get names of random images
rand_images = all_image_names(rand_indices);

%% Display each of the 12 sequentially *in the same figure*
isi = 1; %time in between each image
for i = 1:num_rand_images
    %gets the fullfile directory for images, takes the 12 random images
    % and iterates through all 12
    show_image = imread(fullfile(image_dir,rand_images{i}));
    %dictate the figure window
    figure(1); 
    %display image
    imshow(show_image)
    %colormap('gray') %only needed if I use imagesc (which keeps axes)
    pause(isi);

    % Concat images into a cell array - one dimension that is 12 long 
    %some images are > 1024 x 1024 unit8
    randomly_selected_images{i} = show_image;
end
%% Concat images into an array and save them as 'randomly_selected_images'
%concatenated in line 48

%save as .mat
save("randomly_selected_images.mat","randomly_selected_images");

%% Make subplots to display each of the 12 images in a 4x3 light table grid
rows = 4;
columns = 3;
%dictate the figure window
figure(2);

for i = 1:num_rand_images
    show_image = imread(fullfile(image_dir,rand_images{i})); 
    %makes subplots m-by-n grid and position
    subplot(rows,columns,i) 
    %display image
    imshow(show_image)
    %colormap('gray') %only needed if I use imagesc (which keeps axes)
    title(rand_images{i}) %add image titles to know which photo is which
end