clear all; clear clc; clear;
input_filename = 'fanDEM.tif';    %input reversed DEM 
output_filename = 'fanDEM+.tif';  %output reversed DEM with supplemented boundary
[e0,R] = geotiffread(input_filename)
info=geotiffinfo(input_filename)

r=R
r.XWorldLimits=[R.XWorldLimits(1)-R.CellExtentInWorldX R.XWorldLimits(2)+R.CellExtentInWorldX];
r.YWorldLimits=[R.YWorldLimits(1)-R.CellExtentInWorldY R.YWorldLimits(2)+R.CellExtentInWorldY];
nrows = R.RasterSize(1)+2;
ncols = R.RasterSize(2)+2;
max = max(max(e0));
e=zeros(nrows, ncols);
r.RasterSize=size(e);

for i=2:nrows-1
    for j= 2:ncols-1     
        e(i,j)=e0(i-1,j-1);        
    end
end

for i=1:nrows  
    e(i,1)=max+1;
    e(i,ncols)=max+1; 
end

for j=1:ncols  
    e(1,j)=max+1;
    e(nrows,j)=max+1;
end

% Writiing the data to a new GEOTIFF file
geotiffwrite(output_filename,e,r, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag)




