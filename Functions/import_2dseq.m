function [stack, num] = import_2dseq(filename, rows, columns, n)
%import_2dseq Read bruker images into a stack of images,
%   Read 2d seq into 3d array (row, column, n) 

% Check number of inputs.
if nargin > 4 
    error('import2dseq:TooManyInputs', ...
        'requires at most 3 optional inputs');
end
if nargin == 2
     error('import2dseq:NotEnoughInputs', ...
        'requires 2 or 3 optional inputs');
end

% Fill in unset optional values.
switch nargin
    case 1
        rows = 64;
        columns = 64;
        n = -1;
    case 3
        n = -1;
end
fid = fopen(filename, 'r');
if fid == -1
  error('Cannot open file: %s', FileName);
end
%read in the images, automatically calculating the number of images if not
%given.
if n == -1
    data = fread(fid,'uint16','ieee-le');
    s = size(data);
    stack = reshape(data, [rows, columns,int16(s(1)/rows/columns)]);
    num = int16(s(1)/rows/columns);
else
    data = fread(fid,rows*columns*n, 'uint16');
    s = size(data);
    stack = reshape(data, [rows, columns,min(n, int16(s(1)/rows/columns))]);
    num = n;
end
fclose(fid);
end

