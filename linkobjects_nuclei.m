
temparray=zeros(length(kIn),5);


for i=1: length(kIn)
    temparray(i,1)=i;
    temparray(i,2)=kIn.ObjectNumber_nuclei(i);
    
    
end


for i=1: length(kIn)
    
    radius=kIn.AreaShape_MeanRadius(i);
    centx=kIn.AreaShape_Center_X(i);
    centy=kIn.AreaShape_Center_Y(i);
    
    stackabove=kIn.stackAb(i);
    stackbelow=kIn.stackBel(i);
    
    if stackabove~=0
        
        subarray=zeros(length(find(kIn.ImageNumber==stackabove)),4);
        
        subarray(:,1)=find(kIn.ImageNumber==stackabove);
        subarray(:,2)=kIn.AreaShape_Center_X(subarray(:,1));
        subarray(:,3)=kIn.AreaShape_Center_Y(subarray(:,1));
        subarray(:,4)=kIn.ObjectNumber_nuclei(subarray(:,1));
        
        for j=1: length(subarray(:,1))
            
            checkx=sqrt((subarray(j,2)-kIn.AreaShape_Center_X(i))^2);
            checky=sqrt((subarray(j,3)-kIn.AreaShape_Center_Y(i))^2);
            
            if checkx<=radius && checky<=radius
                temparray(i,3)=subarray(j,4);
            else
                temparray(i,3)=0;
            end
    
        end
        
    elseif stackbelow~=0
            
            subarray=zeros(length(find(kIn.ImageNumber==stackbelow)),4);
            
            subarray(:,1)=find(kIn.ImageNumber==stackbelow);
            subarray(:,2)=kIn.AreaShape_Center_X(subarray(:,1));
            subarray(:,3)=kIn.AreaShape_Center_Y(subarray(:,1));
            subarray(:,4)=kIn.ObjectNumber_nuclei(subarray(:,1));
            
            for j=1: length(subarray(:,1))
                
                checkx=sqrt((subarray(j,2)-kIn.AreaShape_Center_X(i))^2);
                checky=sqrt((subarray(j,3)-kIn.AreaShape_Center_Y(i))^2);
                
                if checkx<=radius && checky<=radius
                    
                    temparray(i,4)=subarray(j,4);
                else
                    temparray(i,4)=0;
                end
            end
          
        else
            temparray(i,3)=666;
        end
    end
