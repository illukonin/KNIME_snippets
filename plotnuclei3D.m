
uniqueFields=unique(kIn.Metadata_Field);
centersX=[0];
centersY=[0];
centersZ=[0];
radiussX=[1];
radiussY=[0];
colours=[1];


for i=1:length(unique(kIn.Metadata_Field))

    j= uniqueFields(i);
  subarray=zeros(length(find(kIn.Metadata_Field==j)),4);
  subarray(:,1)=find(kIn.Metadata_Field==j);
        
  


    centersXtemp =kIn.Location_Center_X(kIn.Metadata_Field==j)+kIn.absWellCoordX(kIn.Metadata_Field==j);
    centersYtemp =kIn.Location_Center_Y(kIn.Metadata_Field==j)+kIn.absWellCoordY(kIn.Metadata_Field==j);
    centersZtemp =kIn.Metadata_Plane(kIn.Metadata_Field==j);
    centersZtemp = round(centersZtemp(:,1)*(5/0.161));
    radiussXtemp = kIn.AreaShape_MajorAxisLength(kIn.Metadata_Field==j);
    radiussYtemp= kIn.AreaShape_MinorAxisLength(kIn.Metadata_Field==j);
    colourstemp=kIn.Intensity_MeanIntensity_DNA(kIn.Metadata_Field==j);

    centersX =[centersX;centersXtemp];
    centersY =[centersY;centersYtemp];
    centersZ =[centersZ;centersZtemp];
  
    radiussX =[radiussX;radiussXtemp];
    radiussY= [radiussY;radiussYtemp];
    colours= [colours;colourstemp];
    
    
    
end

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');



scatter3(centersX,centersY,centersZ,radiussX,colours,'filled');
colormap default; 
colorbar;
view(axes1,[-26.3 54.8]);
grid(axes1,'on');
caxis([0 0.03])

set(axes1,'DataAspectRatio',[1 1 1],'XTick',...
    [0 2560 5120 7680 10240 12800 15360 17920 20480],'YTick',...
    [0 2160 4320 6480 8640 10800 12960 15120 17280 19440],%'ZTick',...
    %[0 40 80 120 160 200]);
%axis equal
