names=transpose(kIn.Properties.VarNames(:));

data=double(kIn);
unique_field=unique(data(:,2));

a=length (unique_field);
b=length (data);

% here create a subarray to host stuff for the loop
% first, create a subarray where the first imgID is clustered

for i = 1 : a
    imageIDs = data(:,1);
    currImag = find(data(:,2) == unique_field(i));
    currStacks = data(currImag,3);
    if length(currStacks) > 1
        for j =1:length(currStacks)
            stack = currStacks(j);
            if j ~= 1 && j ~= length(currStacks)
                stackBel = currStacks(j-1);
                stackAb = currStacks(j+1);
                diff1 = stack - stackBel;
                diff2 = stackAb - stack;
                if diff1 == 1
                    data(currImag(j),4) = imageIDs(currImag(j-1));
                end
                if diff2 == 1
                    data(currImag(j),5) = imageIDs(currImag(j+1));
                end

            elseif j == 1
                stackAb = currStacks(j+1);
                diff2 = stackAb - stack;
                if diff2 == 1
                    data(currImag(j),5) = imageIDs(currImag(j+1));
                end
            else
               stackBel = currStacks(j-1);
               diff1 = stack - stackBel;
               if diff1 == 1
                    data(currImag(j),4) = imageIDs(currImag(j-1));
               end
            end
        end
    end
end

names {4} = 'stackBel';
names {5} = 'stackAb';
mOut2=mat2dataset(data,'VarNames',names);
mOut=mOut2;

