names=transpose(kIn.Properties.VarNames(:));
 
    output=zeros(length(kIn),13);
    names_output=(cell(1,7));
    names_output{1}='Object_UID';
    names_output{8}='position';
    names_output{9}='Metadata_Well';
    
    names_output{10}='Linked_Object1_UID';
    names_output{11}='Linked_Object2_UID';
    names_output{12}='Linked_Object3_UID';
    names_output{13}='PairID';
    
    names_output{2}=names{1};
     names_output{3}=names{2};
     names_output{4}=names{3};
     names_output{5}=names{4};
     names_output{6}=names{5};
     names_output{7}=names{6};
     
output=mat2dataset(output,'VarNames',names_output);

output.ImageNumber=kIn.ImageNumber;
output.ObjectNumber=kIn.ObjectNumber;
output.Metadata_Field=kIn.Metadata_Field;
output.Metadata_Plane=kIn.Metadata_Plane;
output.Metadata_Well=kIn.Metadata_Well;
output.Location_CenterMassIntensity_X_ab=kIn.Location_CenterMassIntensity_X_ab;
output.Location_CenterMassIntensity_Y_ab=kIn.Location_CenterMassIntensity_Y_ab;


%because mad Matlab skills, thats why

temparray=zeros(length(kIn),1);

for i=1 : length(kIn)

    temparray(i,1)=i;
    
end

temparray=mat2dataset(temparray,'VarNames','Object_UID');
output.Object_UID=temparray.Object_UID;

%hard-coded for now, maybe get the image dimensions from yokogawa meta
%eventually

sizex=2560;
sizey=2160;

%define 4 corners: 1=ul=upper left, 2=ur=upper right 3=bl=bottomleft 4=bottom
%right corners are defined as 500x500 square areas in the corner

%include extra column to host corner data



for i=1: length(kIn)
    
    if kIn.Location_CenterMassIntensity_X_ab(i) <500
        
        if kIn.Location_CenterMassIntensity_Y_ab(i)<500
            
            pos=1;
            
        elseif kIn.Location_CenterMassIntensity_Y_ab(i)>1660
            
            pos=7;
        else
            pos=4;
        end
        
    elseif kIn.Location_CenterMassIntensity_X_ab(i)>2060
        
        if kIn.Location_CenterMassIntensity_Y_ab(i)<500
            pos=3;
        elseif kIn.Location_CenterMassIntensity_Y_ab(i)>1660
            pos=9;
        else
            pos=6;
        end
        
    else
        if kIn.Location_CenterMassIntensity_Y_ab(i)<500
            pos=2;
        elseif kIn.Location_CenterMassIntensity_Y_ab(i)>1660
            pos=8;
        else
            pos=5;
    end
    end

output.position(i)=pos;

end

 partarray=zeros(length(kIn),3);
 
for i=1: length(kIn)
    
     %max of 3 fields possible for object search
     
   
    part1=0;
    part2=0;
    part3=0;
    val=output.position(i);
    
    if val==2
        
        %get field, check partner2
        
        part1=kIn.partner2(i);
    end
    if val==4
        
        part1=kIn.partner4(i);
    end
    
    if val==6
        
        part1=kIn.partner6(i);
    end
    
    if val==8
        
        part1=kIn.partner8(i);
    end
    
    if val==1
         part1=kIn.partner1(i);
         part2=kIn.partner2(i);
         part3=kIn.partner4(i);
    end
    if val==3
         part1=kIn.partner2(i);
         part2=kIn.partner3(i);
         part3=kIn.partner6(i);
    end
    if val==7
         part1=kIn.partner4(i);
         part2=kIn.partner7(i);
         part3=kIn.partner8(i);
    end
     if val==9
         part1=kIn.partner6(i);
         part2=kIn.partner8(i);
         part3=kIn.partner9(i);
    end
   
   partarray(i,1)=part1;
   partarray(i,2)=part2;
   partarray(i,3)=part3;
 end

idarray=zeros(length(kIn),7);


wellarray=cellstr(kIn.Metadata_Well);
uwells=unique(wellarray);


 counter=0;
for i=1: length(uwells)
    
    currentwell=find(strcmp(uwells{i},wellarray));
     
   
    
    for l=1: length(currentwell)
        counter=counter+1;
        
        currobj=currentwell(l);
        curimg=output.Object_UID(currobj); 
        
            chk1=0;
            chk2=0;
            chk3=0;
            
             chk1field=0;
             chk2field=0;
             chk3field=0;
             
             
    if  partarray(currobj,1)>0      
        
        if output.position(currobj)==2
            
            chk1=kIn.partner2(curimg);
            chk1field=8;
        end 
        
        if output.position(currobj)==4
            
            chk1=kIn.partner4(curimg);
            chk1field=6;
        end    
        
        if output.position(currobj)==6
            
            chk1=kIn.partner6(curimg);
            chk1field=4;
        end    
        
        if output.position(currobj)==8
            chk1=kIn.partner8(curimg);
            chk1field=2;
        end 
        
        if output.position(currobj)==1
            
            chk1=kIn.partner1(curimg);
                chk1field=9;
            chk2=kIn.partner2(curimg);
                chk2field=7;
            chk3=kIn.partner4(curimg);
                chk3field=3;
        end 
        
        if output.position(currobj)==3
            
            chk1=kIn.partner2(curimg);
                chk1field=9;
            chk2=kIn.partner3(curimg);
                chk2field=7;
            chk3=kIn.partner6(curimg);
                chk3field=1;
           
        end 
        
        if output.position(currobj)==7
            
            chk1=kIn.partner4(curimg);
                chk1field=9;
            chk2=kIn.partner7(curimg);
                chk2field=3;
            chk3=kIn.partner8(curimg);
                chk3field=1;
        end
        
        if output.position(currobj)==9
            
            chk1=kIn.partner4(curimg);
                chk1field=7;
            chk2=kIn.partner7(curimg);
                chk2field=3;
            chk3=kIn.partner8(curimg);
                chk3field=9;
        end
    end
    idarray(counter,1)=output.ImageNumber(counter);
    idarray(counter,2)=chk1;
    idarray(counter,3)=chk2;
    idarray(counter,4)=chk3;
    
    idarray(counter,5)=chk1field;
    idarray(counter,6)=chk2field;
    idarray(counter,7)=chk3field;
    
    end
end


%now check fields

wellarray=cellstr(kIn.Metadata_Well);
uwells=unique(wellarray);
       counter=0;     
       
   for i=1: length(uwells)
    %this loops over unique wells  
    currentwell=find(strcmp(uwells{i},wellarray));  
    tempidarray =idarray(currentwell,:);   
    tempOutput = output(currentwell,:);
     
    %sub-loop within one well
     for iObjt=1: length(tempidarray(:,1))
        %a workaround to avoid another nested loop
        counter=counter+1;
    for chkObj = 1 : length(tempidarray(:,1))
     
      
        if tempOutput.position(iObjt)~=5 & tempOutput.ImageNumber(iObjt)~=tempOutput.ImageNumber(chkObj)
        %should only link objects which are not in the center position and
        %should not link to self
         
    if tempidarray(iObjt,2) == tempOutput.Metadata_Field(chkObj) & tempidarray(iObjt,5) == tempOutput.position(chkObj)
    
    output.Linked_Object1_UID(counter)=tempOutput.Object_UID(chkObj);
   
    end
    
    if tempidarray(iObjt,3) == tempOutput.Metadata_Field(chkObj) & tempidarray(iObjt,6) == tempOutput.position(chkObj)
    
    output.Linked_Object2_UID(counter)=tempOutput.Object_UID(chkObj);
    
    end
    
    if tempidarray(iObjt,4) == tempOutput.Metadata_Field(chkObj) & tempidarray(iObjt,7) == tempOutput.position(chkObj)
    
    output.Linked_Object3_UID(counter)=tempOutput.Object_UID(chkObj);
    
    end
    
    end
     end
     end
     end
   mOut=output;
   
   
   matcharray=zeros(length(output),6);
   matcharray(:,1)=output.Object_UID;
   matcharray(:,2)=output.Linked_Object1_UID;
   matcharray(:,3)=output.Linked_Object2_UID;
   matcharray(:,4)=output.Linked_Object3_UID;
   
   
   counter=0;
   countercouples=0;
   
   for i=1: length(output)
       
       
       calc1=find(output.Linked_Object1_UID== matcharray(i,1));
       calc2=find(output.Linked_Object2_UID== matcharray(i,1));
       calc3=find(output.Linked_Object3_UID== matcharray(i,1));
       
       calc4=[calc1 calc2 calc3];
       
       
       if  isempty(calc4)==0
           
           countercouples=countercouples+1;
           matcharray(i,5)=countercouples;
           
           for i=1 : length(calc4)
               
               partner=calc1;
               matcharray(partner,5)=countercouples;
               
           end
           
       else
           
           
           matcharray(i,5)=0;
                   
       end
   end
   
   
  
  % this is a trick to avoid getting same values for UID and PairID
   counter=length(matcharray)+10;
      
   for i=1 : length(matcharray)
       
       counter=counter+1;
       
       if  matcharray(i,5)==0
           
           matcharray(i,6)=counter;
       end
       
       if matcharray(i,5)~=0
           
           findpair=find((matcharray(:,5)==matcharray(i,5)));
           interval=matcharray(1:i,:);
           checkprev=find((interval(:,6)==matcharray(i,5)));
           
           if isempty(checkprev)==1
               
               for  j=1 : length(findpair)
                   pos=findpair(j);
                   matcharray(pos,6)= counter;
               end
           end  
               
               
               
               
           end
           
   end
       
       
   %this is the export step for KNIME
   
    mOut=zeros(length(kIn),7);
        
    names_mOut=(cell(1,7));
    names_mOut{1}='Object_UID';
    names_mOut{2}='position';
    names_mOut{3}='Metadata_Well';
    names_mOut{4}='Metadata_Plane';
    names_mOut{5}='Metadata_Field';
    names_mOut{6}='ImageNumber';
    names_mOut{7}='PairID';
    
    
  mOut=mat2dataset(mOut,'VarNames',names_mOut);  
  
  
    mOut.Object_UID=output.Object_UID;    
    mOut.ImageNumber=kIn.ImageNumber;
    mOut.position=output.position;
    mOut.ObjectNumber=kIn.ObjectNumber;
    mOut.Metadata_Field=kIn.Metadata_Field;
    mOut.Metadata_Plane=kIn.Metadata_Plane;
    mOut.Metadata_Well=kIn.Metadata_Well;
    mOut.PairID=matcharray(:,6);
    
    
