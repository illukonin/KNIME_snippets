names=transpose(kIn.Properties.VarNames(:));

data1=double(kIn);
data=int16(data1);

% input from Knime should have 4 coloumns, order:
% X, Y, image ID, field

len=length(data);

%temporary array to host data

temparray=zeros(len,6);

minx=min(data(:,1));
miny=min(data(:,2));



for i = 1: length(data)
    
    temparray((i),1)=(data((i),1)-minx);
    temparray((i),2)=(data((i),2)-miny);
end

%set max vals for x/y to create a 2D array from X-Y for field placement,
%500 is an arbitrary number to avoid negatives and zeros

maxx=max(temparray(:,1))+500;
maxy=max(temparray(:,2))+500;

A = zeros(maxx,maxy);

for i = 1: length(temparray)
    %once again, offset to avoid negatives and zeros, 100 is arbitrary
    x=temparray(i,1)+100;
    y=temparray(i,2)+100;
    A(x,y)=256;
    
end

 %same offset as above

x=temparray(1,1)+100;
y=temparray(1,2)+100;

numx=(find(A(:,y)));
numy=fliplr(find(A(x,:)));

lenx=length(numx);
leny=length(numy);

% write column to array

for i = 1: length(temparray)
    
     %same offset as above
    
    x=temparray(i,1)+100;

    
    for j = 1: lenx
        if x == numx(j)
            
            ff=find(numx==x);
            temparray(i,3)=ff;
        end
    end
end

%write row to array

for i = 1: length(temparray)
    
     %same offset as above
    
        y=temparray(i,2)+100;
        
        for k = 1: leny
            if y == numy(k)
                ff=find(numy==y);
                temparray(i,4)=ff;
            end
        end
            
end

  %write filed number to temparray
  
for i = 1: length(temparray)
    
                ff=data(i,4);
                temparray(i,5)=ff;
            
end
        
     
%steps below assign fields to neighboring fields, the matrix is 3-by3 left
%to right, top to bottom

%create an array for hosting offset coeffs in the 3-by 3 matrix

xcoeffs=[-1 0 1 -1 0 1 -1 0 1];
ycoeffs=[-1 -1 -1 0 0 0 1 1 1];

     assarray=(zeros(length(temparray),9));
     
%      this is a test to visualize the layout of fields
      vis=zeros(leny,lenx);
      for i = 1: length(temparray)
          x=temparray(i,3);
          y=temparray(i,4);
          vis(y,x)=temparray(i,5);
      end
 
     %here we identify partner fields' row and column, both have to
     %be positive, otherwise they dont exist and write field number to array     
        
     for i = 1: length(temparray)
   disp('1')            
         for p = 1 : length(xcoeffs)      
             
             idx=temparray(i,3)+xcoeffs(p);
             idy=temparray(i,4)+ycoeffs(p);
              
             if lenx>=idx && leny>=idy && idx>0 && idy>0 
                         
             for h = 1: length(temparray)
                 if temparray(h,4)==idy && temparray(h,3)==idx
                     
                     xwrite=data(h,4);
                     assarray(i,p)=xwrite;
                  
                 end
         end
             end
         end
     end

export=(zeros(length(temparray),13));

%export data block

for i = 1: length(temparray)

%write original data to array

export(i,1)=data(i,1);
export(i,2)=data(i,2);
export(i,3)=data(i,3);
export(i,4)=data(i,4);

%write partner field number to array

export(i,5)=assarray(i,1);
export(i,6)=assarray(i,2);
export(i,7)=assarray(i,3);
export(i,8)=assarray(i,4);
export(i,9)=assarray(i,5);
export(i,10)=assarray(i,6);
export(i,11)=assarray(i,7);
export(i,12)=assarray(i,8);
export(i,13)=assarray(i,9);

end

names {5}='partner1';
names {6}='partner2';
names {7}='partner3';
names {8}='partner4';
names {9}='partner5';
names {10}='partner6';
names {11}='partner7';
names {12}='partner8';
names {13}='partner9';

export1=mat2dataset(export,'VarNames',names);
mOut=export1;

