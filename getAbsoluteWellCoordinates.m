names=transpose(kIn.Properties.VarNames(:));


imageSizeX = 2560;
imageSizeY = 2160;
imageSizeZ = round(5/0.161*8);

temparray=zeros(length(kIn),2);
%x and y shift are field dependant, could be calculated from metadata

minx=min(kIn.coordX);
miny=min(kIn.coordY);
maxx=max(kIn.coordX);
maxy=max(kIn.coordY);

stepx=unique(kIn.coordX);
stepy=unique(kIn.coordY);

xlength=length(stepx)*imageSizeX;
ylength=length(stepy)*imageSizeY;

for i=1:(length(unique(kIn.coordX)))
    
    temparray(find(kIn.coordX==stepx(i)),1)=i*imageSizeX-imageSizeX;
    
end

for i=1:(length(unique(kIn.coordY)))
    
    temparray(find(kIn.coordY==stepy(i)),2)=i*imageSizeY-imageSizeY;
    
end

names_temparray={'absWellCoordX','absWellCoordY'};
temparray=mat2dataset(temparray,'VarNames',names_temparray);

mOut=[kIn, temparray];


