tennis=imread('tennis.png');
    ball=imread('ball.png');
%     converting the image to black and white
    t=rgb2gray(tennis);
    b=rgb2gray(ball);
%     finding the correlation between full image and the ball
    c=normxcorr2(b,t);
%     radius of peak
    rmin=60; %got the value by trial and error
    max_ball_in_the_picture=4;
    circles_detected=0;
    i=1;
%     for loop  to detect the xpeak and ypeak 
  while circles_detected~= max_ball_in_the_picture
        find_peak_again=0;
        [ypeak(i),xpeak(i)]=find(c==max(c(:)));
        c(ypeak(i),xpeak(i))=0; 
%   calculating variables for cordinates of radius      
        yp1=ypeak(i)+ rmin; 
        xp1=xpeak(i)+ rmin;
        yp2=ypeak(i)- rmin ;
        xp2=xpeak(i)- rmin ;
        y=ypeak(i); 
        x=xpeak(i);
% checking the condition wheather it is a first iteration or not
    if circles_detected~=1
        for i1=1:1:circles_detected
%     checking wheather the xpeak and ypeak that i found is close to
%     previous xpeak and ypeak or it is in the range of previous xpeak and ypeak
%     radius
           if y<ypeak(i1)+ rmin && y>ypeak(i1)-rmin && x<xpeak(i1)+rmin && x>xpeak(i1)-rmin
               ypeak(i)=0;
               xpeak(i)=0;
%                making the flag = 1 so that i can find the max value again 
               find_peak_again=1;
           end   
        end
    end

%         loop to avoid the multiple xpeak and ypeak from the same peak
    if find_peak_again == 0
        while y <= yp1 && y >= yp2 && x <= xp1 && x >= xp2
           [y,x]=find(c==max(c(:)));
%   if statement to avoid erasing xpeak and ypeak if it is not from same peak
           if y <= yp1 && y >= yp2 && x <= xp1 && x >= xp2
                c(y,x)=0;
           end
        end
    end
%     incrementing the no. of circles detected     
    if find_peak_again == 0;
        i=i+1;
         circles_detected=circles_detected+1;
    end
    
  end
  
% command to show histogram
     figure, surf(c), shading flat
     
%      commands for calculating the xoffset and yoffset
    for j=1:1:4
        yoffset(j)=ypeak(j)-size(b,1);%size(b.1 is length of y=axis
        xoffset(j)=xpeak(j)-size(b,2);%size(b.1 is length of y=axis
    end
    
    hFig = figure;
    hAx  = axes;
    imshow(t,'Parent', hAx);
%     command for drawing the rectangle
    for k=1:1:4
        imrect(hAx, [xoffset(k)+1, yoffset(k)+1, size(b,2), size(b,1)]);
    end           