%x = imread('C:\Users\krit\Desktop\omr-reader-master\omr-reader-master\omr-candidate2.png');
%imshow(x);
%p = drawpolygon('LineWidth',1,'Color','cyan');
%bw = createMask(p);
%imshow(bw);
x = im2bw(imread('C:\Users\krit\Desktop\omr-reader-master\omr-reader-master\temp\answer.png'),0.2);