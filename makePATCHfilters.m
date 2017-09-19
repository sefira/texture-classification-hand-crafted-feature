function F=makePATCHfilters(kernel_size)
% Returns the patch filter bank of size kernel_size x kernel_size x kernel_size.
% To convolve an image I with the filter bank you can either use the matlab function
% conv2, i.e. responses(:,:,i)=conv2(I,F(:,:,i),'valid'), or use the
% Fourier transform.

F=zeros(kernel_size,kernel_size,kernel_size);

c = 1;
for i=1:kernel_size
    for j=1:kernel_size
        F(i,j,c)=1;
        c = c + 1;
    end
end

end