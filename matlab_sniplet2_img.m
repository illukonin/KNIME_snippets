

data=double(mOut);
a=length (data);
unique_img=unique(data(:,1));

 A = zeros(2560,2160,length(unique_img));
%     create an array outside the loop to host nuclei 

 for j = 1 : length(unique_img)
     img = unique_img(j);
     
     for i = 1 : a
         % so here we are in a unique field
         
         if data(i,1) == unique_img(j)
             
             above=data(i,7)
             below=data(i,8)
             
             
             
             tempX=data(i,3);
             tempY=data(i,4);
             rad=7;
             
             if(tempX>rad)
                 if(tempY>rad)
                     
                     %       nucleus mean radius
                     
                     diltempXlow=tempX-rad;
                     diltempYlow=tempY-rad;
                     
                     diltempXhi=tempX+rad;
                     diltempYhi=tempY+rad;
                     
                     for l = diltempXlow : diltempXhi
                         
                         for m = diltempYlow : diltempYhi
                             val=data(i,2);
                             A(l,m,j) = val;
                         end
                     end
                     
                 end
             end
         end
     end
     
 end

