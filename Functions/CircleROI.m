function [ROI_index] = CircleROI(rows,columns,center_x,center_y,diameter)
%CIRCLEROI Summary of this function goes here
%   Detailed explanation goes here
x = -rows/2+1:rows/2;
y = -columns/2+1:columns/2;
c_x = center_x - rows/2;
c_y = center_y - columns/2;
[xx, yy] = meshgrid(x,y);
ROI_index = zeros(size(xx));
ROI_index(((xx-c_x).^2+(yy-c_y).^2)<(diameter/2)^2)=1;
end

