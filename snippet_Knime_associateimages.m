%hard-coded for now, maybe get the image dimensions from yokogawa meta
%eventually

sizex=2560;
sizey=2160;

%define 4 corners: 1=ul=upper left, 2=ur=upper right 3=bl=bottomleft 4=bottom
%right corners are defined as 500x500 square areas in the corner

%include extra column to host corner data

dummy_input(:,10)=zeros;

for i=1: length(dummy_input)
    
    if(dummy_input(i,3))<500
        
        if(dummy_input(i,4))<500
            
            pos=1;
            
        elseif (dummy_input(i,5))>1660
            
            pos=7;
        else
            pos=4;
        end
        
    elseif (dummy_input(i,3))>2060
        
        if(dummy_input(i,4))<500
            pos=3;
        elseif (dummy_input(i,5))>1660
            pos=9;
        else
            pos=6;
        end
        
    else
        if(dummy_input(i,4))<500
            pos=2;
        elseif (dummy_input(i,4))>1660
            pos=8;
        else
            pos=5;
    end
end
dummy_input(i,10)=pos;

end

for i=1: length(dummy_input)

    val=dummy_input(i,10);
    field=dummy_input(i,9);
    
    dummy_input(:,11)=zeros;
    dummy_input(:,12)=zeros;
    dummy_input(:,13)=zeros;
    
    %max of 3 fields possible for object search
    
    part1=0;
    part2=0;
    part3=0;
    
    
    if val==2
        %get field, check partner2
        
        part1=assarray(field,2);
        
    elseif val==4
                
        part1=assarray(field,4);
        
    elseif val==4
                
        part1=assarray(field,4);
        
    end
    
    dummy_input(i,11)=part1;
    dummy_input(i,12)=part2;
    dummy_input(i,13)=part3;
end
        
