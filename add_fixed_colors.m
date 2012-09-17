function colors = add_fixed_colors( colors, newcolor )
    N=size(colors,2);
    colors(:,N+1)=newcolor;
end

