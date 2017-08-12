function [ ] = convert_txt2mat(source_dir, save_dir)
% convert txt files under source_dir to mat and saved in save_dir.
% 

files = dir(source_dir);
num_files = length(files);

% empty save_dir
if(exist(save_dir))
    fprintf('`%s` already exists, delete.\n', save_dir);
    rmdir(save_dir, 's');
end
mkdir(save_dir);

for i = 3:num_files % skip `./` and `../`
    fprintf('Converting detection txt `%s` to mat. %d/%d\n', files(i).name, i-2, num_files - 2);
    % read file.
    file_name = files(i).name;
    full_file = fullfile(source_dir, file_name);  
    [names, xs, ys, ws, hs, scores] = textread(full_file, '%f%f%f%f%f%f');
    
    % convert `full_file` to mat.
    % fields: unPos, unProb, frameIndex, index, scale, partClass.
    detections = struct();
    detections.unPos = [xs, ys, ws, hs];
    detections.unProb = scores;
    detections.frameIndex = names;
    detections.index = [1:size(names,1)]';
    detections.scale = ones(size(names,1), 1);
    detections.partClass = zeros(size(names,1), 1);

    % save as the mat.
    file_name = deblank(file_name);
    splits = regexp(file_name, '\.', 'split'); % 000001.txt_result.txt => [000001, txt_result, txt]
    save_name = splits{1};
    full_save = fullfile(save_dir, save_name);
    save(full_save, 'detections');
end
fprintf('Convert detection .txt to .mat, done.\n');
end