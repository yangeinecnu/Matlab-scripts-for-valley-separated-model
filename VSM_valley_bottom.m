clear all; clear clc; clear;

input_filename1 = 'DEM.tif';                                                 %input DEM
input_filename2 = 'convexregion.tif';                                        %input convex region's number 

output_filename1 = 'convexregionboundary.tif';                               %output convex region boundary
output_filename2 = 'valleybottom1.tif';                                      %output incomplete valley bottom
output_filename3 = 'valleybottom2.tif';                                      %output complete valley bottom
[e,R1] = geotiffread(input_filename1);
[n,R2] = geotiffread(input_filename2);
info=geotiffinfo(input_filename1);

nrows=R1.RasterSize(1);
ncols=R1.RasterSize(2);

%% Figure2d - 2e  _____<1>finding cells as the convex region boundary bc
bc=zeros(nrows, ncols);

for i= 2:nrows-1                                                             %inner part
    for j= 2:ncols-1
        for  p=-1:2:1
            if  n(i,j)~=n(i+p,j)
                bc(i,j)=bc(i,j)+1;
            end
        end
        for q=-1:2:1
            if  n(i,j)~=n(i,j+q)
                bc(i,j)=bc(i,j)+1;
            end
        end
    end
end

i=1;                                                                          %first line
for j= 2:ncols-1
    p=1;
    if  n(i,j)~=n(i+p,j)
        bc(i,j)=bc(i,j)+1;
    end
    for q=-1:2:1
        if  n(i,j)~=n(i,j+q)
            bc(i,j)=bc(i,j)+1;
        end
    end
end

i= nrows;                                                                    %last line
for j= 2:ncols-1
    p=-1;
    if  n(i,j)~=n(i+p,j)
        bc(i,j)=bc(i,j)+1;
    end
    for q=-1:2:1
        if  n(i,j)~=n(i,j+q)
            bc(i,j)=bc(i,j)+1;
        end
    end
end

j= 1;                                                                        %first column
for i= 2:nrows-1
    for  p=-1:2:1
        if  n(i,j)~=n(i+p,j)
            bc(i,j)=bc(i,j)+1;
        end
    end
    q=1;
    if  n(i,j)~=n(i,j+q)
        bc(i,j)=bc(i,j)+1;
    end
end

j= ncols;                                                                    %last column
for i= 2:nrows-1
    for  p=-1:2:1
        if  n(i,j)~=n(i+p,j)
            bc(i,j)=bc(i,j)+1;
        end
    end
    q=-1;
    if  n(i,j)~=n(i,j+q)
        bc(i,j)=bc(i,j)+1;
    end
end

i=1;j=1;                                                                    %corner point
if  n(i,j)~=n(i+1,j)
    bc(i,j)=bc(i,j)+1;
end
if  n(i,j)~=n(i,j+1)
    bc(i,j)=bc(i,j)+1;
end

i=nrows;j=1;                                                                %corner point
if  n(i,j)~=n(i-1,j)
    bc(i,j)=bc(i,j)+1;
end
if  n(i,j)~=n(i,j+1)
    bc(i,j)=bc(i,j)+1;
end

i=1;j=ncols;                                                                %corner point
if  n(i,j)~=n(i+1,j)
    bc(i,j)=bc(i,j)+1;
end
if  n(i,j)~=n(i,j-1)
    bc(i,j)=bc(i,j)+1;
end

i=nrows;j=ncols;                                                            %corner point
if  n(i,j)~=n(i-1,j)
    bc(i,j)=bc(i,j)+1;
end
if  n(i,j)~=n(i,j-1)
    bc(i,j)=bc(i,j)+1;
end
 
 geotiffwrite(output_filename1,bc,R1, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);  
 
%% Figure2d - 2e  _____<2>finding lower elevation grids along the boundary of convex region

bv=zeros(nrows, ncols);

for i=2:nrows-1                                                              %inner part
    for j= 2:ncols-1
        if bc(i,j)>=1
            for  p=-1:2:1
                if  n(i,j)~=n(i+p,j) && e(i,j)<=e(i+p,j)
                    bv(i,j)=bv(i,j)+1;
                end
            end
            for q=-1:2:1
                if  n(i,j)~=n(i,j+q) && e(i,j)<=e(i,j+q)
                    bv(i,j)=bv(i,j)+1;
                end
            end
        end
    end
end

i=1;                                                                          %first line
for j= 2:ncols-1
    if bc(i,j)>=1
        p=1;
        if  n(i,j)~=n(i+p,j) && e(i,j)<=e(i+p,j)
            bv(i,j)=bv(i,j)+1;
        end
        for q=-1:2:1
            if  n(i,j)~=n(i,j+q) && e(i,j)<=e(i,j+q)
                bv(i,j)=bv(i,j)+1;
            end
        end
    end
end

i= nrows;                                                                     %last line
for j= 2:ncols-1
    if bc(i,j)>=1
        p=-1;
        if  n(i,j)~=n(i+p,j) && e(i,j)<=e(i+p,j)
            bv(i,j)=bv(i,j)+1;
        end
        
        for q=-1:2:1
            if  n(i,j)~=n(i,j+q) && e(i,j)<=e(i,j+q)
                bv(i,j)=bv(i,j)+1;
            end
        end
    end
end

j= 1;                                                                         %first column
for i= 2:nrows-1
    if bc(i,j)>=1
        for  p=-1:2:1
            if  n(i,j)~=n(i+p,j) && e(i,j)<=e(i+p,j)
                bv(i,j)=bv(i,j)+1;
            end
        end
        q=1;
        if  n(i,j)~=n(i,j+q) && e(i,j)<=e(i,j+q)
            bv(i,j)=bv(i,j)+1;
        end
    end
end

j= ncols;                                                                     %last column
for i= 2:nrows-1
    if bc(i,j)>=1
        for  p=-1:2:1
            if  n(i,j)~=n(i+p,j) && e(i,j)<=e(i+p,j)
                bv(i,j)=bv(i,j)+1;
            end
        end
        q=-1;
        if  n(i,j)~=n(i,j+q) && e(i,j)<=e(i,j+q)
            bv(i,j)=bv(i,j)+1;
        end
    end
end

i=1;j=1;                                                                     %corner point
if bc(i,j)>=1
    if  n(i,j)~=n(i+1,j) && e(i,j)<=e(i+1,j)
        bv(i,j)=bv(i,j)+1;
    end
    if  n(i,j)~=n(i,j+1) && e(i,j)<=e(i,j+1)
        bv(i,j)=bv(i,j)+1;
    end
end

i=nrows;j=1;                                                                 %corner point
if bc(i,j)>=1
    if  n(i,j)~=n(i-1,j) && e(i,j)<=e(i-1,j)
        bv(i,j)=bv(i,j)+1;
    end
    if  n(i,j)~=n(i,j+1) && e(i,j)<=e(i,j+1)
        bv(i,j)=bv(i,j)+1;
    end
end

i=1;j=ncols;                                                                 %corner point
if bc(i,j)>=1
    if  n(i,j)~=n(i+1,j) && e(i,j)<=e(i+1,j)
        bv(i,j)=bv(i,j)+1;
    end
    if  n(i,j)~=n(i,j-1) && e(i,j)<=e(i,j-1)
        bv(i,j)=bv(i,j)+1;
    end
end

i=nrows;j=ncols;                                                             %corner point
if bc(i,j)>=1
    if  n(i,j)~=n(i-1,j) && e(i,j)<=e(i-1,j)
        bv(i,j)=bv(i,j)+1;
    end
    if  n(i,j)~=n(i,j-1) && e(i,j)<=e(i,j-1)
        bv(i,j)=bv(i,j)+1;
    end
end


bvn=bc.*bv;

for i=1:nrows                                                               %all
    for j= 1:ncols
        if bv(i,j)>=1
            bvn(i,j)=bc(i,j);
        end
    end
end

geotiffwrite(output_filename2,bvn,R1, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

%% Figure2d - 2e  _____<3> modifying boundary of convex cell around corner grid
bvp=bv;
for i=2:nrows-1                                                              %inner part
    for j= 2:ncols-1
        if  bvn(i,j)>=2
            for p=-1:2:1
                if   bvn(i+p,j)==0 && e(i,j)>e(i+p,j)
                    bvp(i+p,j)=1;
                end
            end
            
            for q=-1:2:1
                if   bvn(i,j+q)==0 && e(i,j)>e(i,j+q)
                    bvp(i,j+q)=1;
                end
            end
        end
    end
end


i=1;                                                                          %first line
for j= 2:ncols-1
    if bvn(i,j)>=1
        p=1;
        if   bvn(i+p,j)==0 && e(i,j)>e(i+p,j)
            bvp(i+p,j)=1;
        end
        for q=-1:2:1
            if   bvn(i,j+q)==0 && e(i,j)>e(i,j+q)
                bvp(i,j+q)=1;
            end
        end
    end
end

i= nrows;                                                                     %last line
for j= 2:ncols-1
    if bvn(i,j)>=1
        p=-1;
        if   bvn(i+p,j)==0 && e(i,j)>e(i+p,j)
            bvp(i+p,j)=1;
        end
        
        for q=-1:2:1
            if   bvn(i,j+q)==0 && e(i,j)>e(i,j+q)
                bvp(i,j+q)=1;
            end
        end
    end
end

j= 1;                                                                         %first column
for i= 2:nrows-1
    if bvn(i,j)>=1
        for  p=-1:2:1
            if   bvn(i+p,j)==0 && e(i,j)>e(i+p,j)
                bvp(i+p,j)=1;
            end
        end
        q=1;
        if   bvn(i,j+q)==0 && e(i,j)>e(i,j+q)
            bvp(i,j+q)=1;
        end
    end
end

j= ncols;                                                                     %last column
for i= 2:nrows-1
    if bvn(i,j)>=1
        for  p=-1:2:1
            if   bvn(i+p,j)==0 && e(i,j)>e(i+p,j)
                bvp(i+p,j)=1;
            end
        end
        q=-1;
        if   bvn(i,j+q)==0 && e(i,j)>e(i,j+q)
            bvp(i,j+q)=1;
        end
    end
end

geotiffwrite(output_filename3,bvp,R1, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
