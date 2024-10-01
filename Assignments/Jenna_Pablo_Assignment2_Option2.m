% Code Assignment 2 - Option 2: Color Patches (NOT CONFIDENT IN THIS ONE)
% Psy 627
% Jenna Pablo

debugging_mode = 0; %0=full screen, 1=small screen

%% Timing Parameters 
stim_time = 1; %show color pairs for 1 second each
isi = .25; %.25 s gap between color pairs
block_time = 20; %20s of each block
bw_block_time = 3; %3s between blocks

num_stim_per_block = block_time/(stim_time+isi); %16 stim per block

%% Set up Screen 
% Skip sync tests (sync tests cause issues on Mac OS)
Screen('Preference', 'SkipSyncTests', 1);  
screen_color = [128,128,128];
screens = Screen('Screens');
screen_number=max(screens);


%choose screen size
if debugging_mode == 0
    screen_rect = []; %for fullscreen
    stim_width = 512; %figured out a good size when i completed option1 first, probably a better way to decide this
    stim_height = 512; 
else 
    screen_size = [400,400];
    screen_upper_left = [200,200];
    screen_rect = [screen_upper_left, screen_upper_left + screen_size];
    stim_width = 128; %make small 
    stim_height = 128; %make small
end

% Open window
w=Screen('OpenWindow', screen_number, screen_color, screen_rect);

%figure out screen coordinates
[screen_x,screen_y] = Screen('WindowSize',w);

%dictate left and right side of screen for color patches 
%help from past lab screen setups: gets left side of screen and middle
%point using dimensions of stim to be shown 
left_rect = [(screen_x / 4) - (stim_width / 2), (screen_y / 2) - (stim_height / 2), ...
    (screen_x / 4) + (stim_width / 2), (screen_y / 2) + (stim_height / 2)];

%multipled by 3 is essentially flipping from left side to right side 
right_rect = [(3 * screen_x / 4) - (stim_width / 2), (screen_y / 2) - (stim_height / 2), ...
    (3 * screen_x / 4) + (stim_width / 2), (screen_y / 2) + (stim_height / 2)];

%% Color Parameters 
%within .1 hue space
near_hue = [0.01,.1]; %min and max of near hue; .01 so it isnt identical
%.1 to .2 hue space
medium_hue = [.1,.2];
%.4 to .5 hue space
far_hue = [.4,.5];

%combine color blocks
block = [near_hue; medium_hue; far_hue];

%% for loop for displaying color patches
%preallocate color patches
color_patch = ones(100,100,3);
color_patch2 = ones(100,100,3);

for b = 1:height(block) %go through each of the color blocks (near, medium, far)
    for i = 1:num_stim_per_block %go through the 16 color patch pairs

        %creates random HSV color for patch1, creates random HSV color within HSV space
        % for patch2, converts to RGB, creates color patch in RGB 
        [color_patch, color_patch2] = generate_patch_pairs(block(b,1),block(b,2)); %custom function use 

        %%Present color patches%%
        color_texture = Screen('MakeTexture',w,color_patch);
        color_texture2 = Screen('MakeTexture',w,color_patch2);
        Screen('DrawTexture',w,color_texture,[], left_rect);
        Screen('DrawTexture',w,color_texture2,[], right_rect);
        Screen('Flip',w); %show patches
        WaitSecs(stim_time);

        Screen('Flip',w); %go back to blank screen
        if i ~= num_stim_per_block
            WaitSecs(isi); %.25s gap between images except last image
        end
    end
    WaitSecs(bw_block_time); %wait before moving onto next block
    % disp('Next block:'); %sanity check
end

sca; %close screen

%% Functions 
function [color_patch, color_patch2] = generate_patch_pairs(hue_min, hue_max)
    %
    % Usage: generate_patch_pairs(hue_min,hue_max)
    % Inputs
    % hue_min: min hue distance allowed
    % hue_max: max hue distance allowed
    % Outputs
    % color_patch: first color patch rgb values
    % color_patch2: second color patch rgb values
    % 
   
%%Create Random Colors in HSV (Hue-Saturation-Value) Space%%
    hue = rand(); %generates random number 0 to 1
    % fprintf('Hue 1: %f\n',hue); %debugging: check hue color patch 1
    saturation = 1; %purest color, fully saturated
    value = 1; %brightest color possible 

    %dictate second color patch be within certain hue space
    %creates a random difference between the max and min hue space 
    hue_diff = hue_min + (rand() * (hue_max - hue_min));  
    % fprintf('Hue difference: %f\n',hue_diff); %debugging: check hue difference is correct 

    % Chat GPT helped with next line: mod=modulo operation keeps it from exceeding 1
    % number is between -hue_diff and +hue_diff
    % Randomly add or subtract the hue_diff: randi(2) generates 1 or 2, 
    %raising -1 to power of 1 = subtracting hue_diff, 
    % whereas to power of 2 = adding hue_diff
    hue2 = mod(hue + hue_diff * (-1)^randi(2), 1);  
    % fprintf('Hue 2: %f\n',hue2); %debugging: check hue color patch 2 is within the criteria 
    % disp('------------------'); %debugging: line to distinguish next trial numbers

%%Convert HSV to RGB%%
    color_patch_rgb = hsv2rgb([hue, saturation, value]);
    color_patch_rgb = round(color_patch_rgb * 255);

    color_patch2_rgb = hsv2rgb([hue2, saturation, value]);
    color_patch2_rgb = round(color_patch2_rgb * 255);

    for rgb = [1,2,3] %fill those rgb values
        color_patch(:,:,rgb) = color_patch_rgb(rgb); %go through each index of rgb colors and fill in the colorPatch
        color_patch2(:,:,rgb) = color_patch2_rgb(rgb);
    end

end