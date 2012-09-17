function colors = add_random_colors(colors, thresh)    
    N=size(colors,2);
    mindist=0;
    tries=0;

    %This loop iterates until it finds a color further away from existing colors than thresh or 100 iterations is reached
    while and(mindist<thresh,tries<100)
        tries=tries+1;
        newcolor=rand(3,1);
        while sum(newcolor)>1.5
            newcolor=rand(3,1);
        end
        mindist=2*thresh;
        for i=1:N
            dist=newcolor(:,1)-colors(:,i);
            dist=sqrt(sum(dist.^2));
            if dist<mindist
                mindist=dist;
            end
        end
    end
    colors(:,N+1)=newcolor;
end