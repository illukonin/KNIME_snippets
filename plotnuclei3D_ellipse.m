

uniqueFields=unique(kIn.Metadata_Field);
centersX=[];
centersY=[];
centersZ=[];
majors=[];
minors=[];
colours=[];
orientations=[];

for i=1:length(unique(kIn.Metadata_Field))
    
    j= uniqueFields(i);
    subarray=zeros(length(find(kIn.Metadata_Field==j)),4);
    subarray(:,1)=find(kIn.Metadata_Field==j);
    
    centersXtemp =kIn.Location_Center_X(kIn.Metadata_Field==j)+kIn.WellCoordX(kIn.Metadata_Field==j);
    centersYtemp =kIn.Location_Center_Y(kIn.Metadata_Field==j)+kIn.WellCoordY(kIn.Metadata_Field==j);
    centersZtemp =kIn.Metadata_Plane(kIn.Metadata_Field==j);
    orientationtemp=kIn.AreaShape_Orientation(kIn.Metadata_Field==j);
    centersZtemp = round(centersZtemp(:,1)*(5/0.161));
    majorstemp = kIn.AreaShape_MajorAxisLength(kIn.Metadata_Field==j)/2;
    minorstemp= kIn.AreaShape_MinorAxisLength(kIn.Metadata_Field==j)/2;
    colourstemp=kIn.Intensity_MeanIntensity_DNA(kIn.Metadata_Field==j);
    
    centersX =[centersX;centersXtemp];
    centersY =[centersY;centersYtemp];
    centersZ =[centersZ;centersZtemp];
    
    majors =[majors; majorstemp];
    minors= [minors; minorstemp];
    orientations=[orientations; orientationtemp];
    colours= [colours;colourstemp];
    
end

% theta = atan(minors/majors);

b=(majors/2 .*cos(orientations));
a=(minors/2 .*sin(orientations));
%orientationsrad = deg2rad(orientations);


% [theta,rho,orientationsrad] = cart2pol(a);

figure1=figure();
axes1 = axes('Parent',figure1);
grid(axes1,'on');
axis equal

set(axes1,'XTick',...
    [0 2560 5120 7680 10240 12800 15360 17920 20480],'YTick',...
    [0 2160 4320 6480 8640 10800 12960 15120 17280 19440],'ZTick',...
    [0 40 80 120 160 200]);

hold on


%COPYPASTE from here on


x0=centersX;
y0=centersY;
ra=majors;
rb=minors;
ang=orientations;
Nb=300;
C=get(gca,'colororder');
diff=length(unique(kIn.Metadata_Plane))-length(C(:,1));

unique_z=unique(centersZ);

if diff>0
    
    for i=1: diff
        var=length(C(:,1))+i;
        C(var,:)=C(1,:);
    end
end

if length(ra)~=length(rb),
    error('length(ra)~=length(rb)');
end;
if length(x0)~=length(y0),
    error('length(x0)~=length(y0)');
end;

% how many inscribed elllipses are plotted

if length(ra)~=length(x0)
    maxk=length(ra)*length(x0);
else
    maxk=length(ra);
end;

% drawing loop

for k=1:maxk
    
    if length(x0)==1
        xpos=x0;
        ypos=y0;
        zpos=centersZ(k);
        radm=ra(k);
        radn=rb(k);
        if length(ang)==1
            an=ang;
        else
            an=ang(k);
        end;
    elseif length(ra)==1
        xpos=x0(k);
        ypos=y0(k);
        zpos=centersZ(k);
        radm=ra;
        radn=rb;
        an=ang;
    elseif length(x0)==length(ra)
        xpos=x0(k);
        ypos=y0(k);
        zpos=centersZ(k);
        radm=ra(k);
        radn=rb(k);
        an=ang(k);
    else
        rada=ra(fix((k-1)/size(x0,1))+1);
        radb=rb(fix((k-1)/size(x0,1))+1);
        an=ang(fix((k-1)/size(x0,1))+1);
        xpos=x0(rem(k-1,size(x0,1))+1);
        ypos=y0(rem(k-1,size(y0,1))+1);
        zpos=centersZ(k);
    end;
    
    co=cos(an);
    si=sin(an);
    the=linspace(0,2*pi,Nb(rem(k-1,size(Nb,1))+1,:)+1);
    zpos=zeros(Nb+1,1);
    zpos(:)=transpose(centersZ(k));
    
    x=radm*cos(the)*co-si*radn*sin(the)+xpos;
    y=radm*cos(the)*si+co*radn*sin(the)+ypos;
    h(k)=line(radm*cos(the)*co-si*radn*sin(the)+xpos,radm*cos(the)*si+co*radn*sin(the)+ypos,zpos);
    
    currZpos=find(unique_z==zpos(1,1));
        set(h(k),'color',C(currZpos,:));
end;
hold off
