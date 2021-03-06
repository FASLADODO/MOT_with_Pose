function [ ] = convert_test2paper( source_dir, save_mat_file, save_dir, prefix, isSave )
%CONVERT_TEST2PAPER Summary of this function goes here
%   Detailed explanation goes here

source_files = dir([source_dir, '/*.mat']);
num_videos = size(source_files, 1);

pre = [];
if isSave
    mkdir_if_missing(save_dir);
end

for i = 1:num_videos
    
    file_name = source_files(i).name;
    fprintf('Processing %s\n', file_name);
    full_file = fullfile(source_dir, file_name);
    
    load(full_file, 'annolist');
    num_frames = size(annolist, 2);
    
    [~, only_name, ~] = fileparts(full_file);
    
    cur = struct();
    cur.num_frames = num_frames;
    cur.name = only_name;
    if isSave
        save_video_dir = fullfile(save_dir, only_name);
        mkdir_if_missing(save_video_dir);
        for fid = 1:num_frames
            img_file = annolist(fid).image.name;
            img_file = fullfile(prefix, img_file);
            [~, ~, suffix] = fileparts(img_file);
            save_name = sprintf('%05d%s', fid, suffix);
            save_file = fullfile(save_video_dir, save_name);
            command = ['cp ' img_file ' ' save_file];
            s = unix(command);
            assert(s == 0);
        end
    end
    
    if isempty(pre)
        pre = cur;
    else
        pre = cat(1, pre, cur);
    end
end

annolist = pre;
save(save_mat_file, 'annolist');

end

