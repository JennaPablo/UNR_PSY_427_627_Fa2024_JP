% Code Assignment 2 - Option 1: Images in blocks 
% Psy 627
% Jenna Pablo
% Code buddy: L. Kemmelmeier

debugging_mode = 0; %0=full screen, 1=small screen

%% Dictate Paths
image_dir = '/Users/jennapablo/Documents/Psy 627/datasets/fLoc_stimuli';
disp(exist(image_dir,'dir')) %output 7=folder exists

%% Timing parameters 
stim_time = 1; %show image for 1 second each
isi = .25; %.25 s gap between images
block_time = 20; %20s of each block
bw_block_time = 3; %3s between blocks

num_imgs_per_block = block_time/(stim_time+isi); %16 images per block
%20 seconds per block = (1s per image x 16 images) + (16 images x .25s gap between images) 

%% Make arrays for each image category 
%realized I was repeating code to get images - made into function
adult_imgs = get_img_names(image_dir,'adult*');
child_imgs = get_img_names(image_dir,'child*');

house_imgs = get_img_names(image_dir,'house*');
corridor_imgs = get_img_names(image_dir,'corridor*');

instrument_imgs = get_img_names(image_dir,'instrument*');
car_imgs = get_img_names(image_dir,'car*');

%% Choose images to show
%from the total select, 16 images per block/8 per category within block
num_rand_images = 8; %choose X random images per category
rng('shuffle'); %shuffles the seed for randomization purposes

%made randomizer and combine categories for a block into function
rand_face_imgs = rand_pick_imgs(adult_imgs,child_imgs,num_rand_images);
rand_place_imgs = rand_pick_imgs(house_imgs, corridor_imgs, num_rand_images);
rand_object_imgs = rand_pick_imgs(instrument_imgs, car_imgs, num_rand_images);

%% Get screen set up
% Skip sync tests (sync tests cause issues on Mac OS)
Screen('Preference', 'SkipSyncTests', 1);  
screen_color = [128,128,128];
screens = Screen('Screens');
screen_number=max(screens);

%figure out appropriate image sizes
%original image sizes
og_img_width = 1024;
og_img_height = 1024;

%choose screen size
if debugging_mode == 0
    screen_rect = []; %for fullscreen
    new_img_width = og_img_width/2; %half og size
    new_img_height = og_img_height/2; %half og size
else 
    screen_size = [400,400];
    screen_upper_left = [200,200];
    screen_rect = [screen_upper_left, screen_upper_left + screen_size];
    new_img_width = og_img_width/8; %make small - 8th of its size
    new_img_height = og_img_height/8; %make small - 8th of its size
end

% Open window
w=Screen('OpenWindow', screen_number, screen_color, screen_rect);

%figure out screen coordinates
[screen_x,screen_y] = Screen('WindowSize',w);

%dictate left and right side of screen for images 
%help from past lab screen setups: gets left side of screen and middle
%point using dimensions of image to be shown 
left_rect = [(screen_x / 4) - (new_img_width / 2), (screen_y / 2) - (new_img_height / 2), ...
    (screen_x / 4) + (new_img_width / 2), (screen_y / 2) + (new_img_height / 2)];

%multipled by 3 is essentially flipping from left side to right side 
right_rect = [(3 * screen_x / 4) - (new_img_width / 2), (screen_y / 2) - (new_img_height / 2), ...
    (3 * screen_x / 4) + (new_img_width / 2), (screen_y / 2) + (new_img_height / 2)];

%% for loop to show imgs
block = [rand_face_imgs; rand_place_imgs; rand_object_imgs];

%LEFT presentation first
for b = 1:height(block) 
    for i = 1:num_imgs_per_block %go through all 16 images within each block
        image = imread(fullfile(image_dir,block{b,i}));
        image_texture = Screen('MakeTexture',w,image);
        Screen('DrawTexture',w,image_texture,[],left_rect); %left_rect = left side of screen
        Screen('Flip', w);
        WaitSecs(stim_time); %stay on screen for 1s

        Screen('Flip', w); %goes back to blank screen
        if i ~= num_imgs_per_block
            WaitSecs(isi); %.25s gap between images except last image
        end
    end
    WaitSecs(bw_block_time); %wait before moving onto next block
end

%RIGHT presentation second
for b = 1:height(block) 
    for i = 1:num_imgs_per_block %go through all 16 images within each block
        image = imread(fullfile(image_dir,block{b,i}));
        image_texture = Screen('MakeTexture',w,image);
        Screen('DrawTexture',w,image_texture,[],right_rect); %right_rect = right side of screen
        Screen('Flip', w);
        WaitSecs(stim_time); %stay on screen for 1s

        Screen('Flip', w); %goes back to blank screen
        if i ~= num_imgs_per_block
            WaitSecs(isi); %.25s gap between images except last image
        end
    end
    WaitSecs(bw_block_time); %wait before moving onto next block
end

%close screen
sca;
disp('Hooray!');
%% Functions

% Function to make arrays for each image category
function img_names = get_img_names(image_dir,img_cat)
    %
    % Usage: img_names = get_img_names(image_dir,img_cat)
    % Inputs
    % image_dir: image directory
    % img_cat : wild card string of category of interest
    % Output
    % img_names : cell of image names
    %
    img_set = dir(fullfile(image_dir,img_cat));
    img_names = {img_set.name};

end

% Function to get array of random image names for a block
function rand_img_names = rand_pick_imgs(img_set1,img_set2, num_rand)
    %
    % Usage: rand_img_names = rand_pick_imgs(img_set,num_rand)
    % Inputs
    % img_set1: image array 1 you are choosing random images from
    % img_set2: image array 2 you are choosing random images from
    % num_rand : number of random images you are choosing
    % Output
    % rand_img_names : cell of image names from the randomly choosen images
    % from  one whole block (contains two image sets)
    %
    rand_set1_indices = randperm(length(img_set1),num_rand);
    rand_set1_names = img_set1(rand_set1_indices);
    rand_set2_indices = randperm(length(img_set2),num_rand);
    rand_set2_names = img_set2(rand_set2_indices);
    %combine the sets together and shuffle order
    rand_imgs = horzcat(rand_set1_names, rand_set2_names);
    rand_img_names = rand_imgs(randperm(length(rand_imgs)));

end

