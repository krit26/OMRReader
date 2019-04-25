clc;
close all;
clear all;

%% segment each portion of the omr sheet
I_omr=imread('omr-candidate2.png');
prop=regionprops(im2bw(imread('./masks/omr-mask-roll.png')));
bounding_roll=prop.BoundingBox;
prop=regionprops(im2bw(imread('./masks/omr-mask-test.png')));
bounding_test=prop.BoundingBox;
prop=regionprops(im2bw(imread('./masks/omr-mask-answer.png')));
bounding_answer=prop.BoundingBox;
imwrite(imcrop(I_omr,bounding_roll),'./temp/roll.png','PNG');
imwrite(imcrop(I_omr,bounding_test),'./temp/test.png','PNG');
imwrite(imcrop(I_omr,bounding_answer),'./temp/answer.png','PNG');

%% Read Roll No.
x=27; % x-coordinate of first bubble
y=13; % y-coordinate of first bubble
s=20; %spacing between each bubble
sr=20; %spacing between consecutive rows

%horizontal scaling valuation
roll=0;
I=im2bw(imread('./temp/roll.png'),0.2);

for i=1:10
    sy=y+(i-1)*sr;
    for j=1:10 
        sx=x+(j-1)*s;
        if I(sy,sx)<0.1
            bub_n=round((sx-x)/s)+1;
            if bub_n==10
                bub_n=0;
            end
            roll=roll*10+bub_n;
        end
    end
end
% disp(roll);

%% Read Test ID
x=28; % x-coordinate of first bubble
y=13; % y-coordinate of first bubble
s=20; %spacing between each bubble
sr=20; %spacing between consecutive rows

test=0;
I=im2bw(imread('./temp/test.png'),0.2);
% figure,imshow(I); %vis
for j=1:3                               
    for i=1:10
        sy=y+(i-1)*sr; 
        sx=x+(j-1)*s;
        if (I(sy,sx)<0.1)
            bub_n=round((sy-y)/sr)+1;
            if bub_n==10
                bub_n=0;
            end
            test=test*10+bub_n;
        end
    end
end
% disp(test);

record_file=fopen(['./temp/' num2str(test) '_' num2str(roll) '_record.csv'],'w');
fprintf(record_file, '%s', ['CRN,' num2str(roll)]);
fprintf(record_file, '\n%s', ['TID,' num2str(test)]);


%% Read Answers
x=32; % x-coordinate of first bubble
y=32; % y-coordinate of first bubble
s=20; %spacing between each bubble
sr=40; %spacing between consecutive rows

I=im2bw(imread('./temp/answer.png'),0.2);
answer_file = importdata('./temp/answers.csv',',');
marks = 0;
for k=1:6 
    for i=1:15
        sy=y+(i-1)*sr;
        answer=[];
        for j=1:4
            sx=x+(j-1)*s;
            if I(sy,sx)<0.1
                bub_n=round((sx-x)/s);
                answer=[answer char(65+bub_n)];
            end
        end
        fprintf(record_file, '\n%s', ['Q' num2str((k-1)*15+i) ',' answer]);
        if strcmp(answer_file((k-1)*15+i,1), ['Q' num2str((k-1)*15+i) ',' answer])
            marks = marks + 1;
        end
    end
    x=x+120;
end

fprintf(record_file,'\n%s',['Total,' num2str(marks)]);
fclose(record_file);
h = msgbox(['Record generated at ./temp/' num2str(test) '_' num2str(roll)  '_record.csv. (Open using Spread Sheet Application)']);
