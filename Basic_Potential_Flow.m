clear all;close all;clc;


flow_type=input('Please specify the flow type. \n', 's');

xx=linspace(-0.5,0.5,50);
yy=linspace(-0.5,0.5,50);

[x,y]= meshgrid(xx,yy);

r=sqrt((x.^2)+(y.^2));
theta= atan2(y./r,x./r);

switch flow_type
  case {'sink','source'}
      
    m=input('Please insert the strength of source/sink \n');
    sis = (m*theta)/(2*pi);
    [dx,dy]=gradient(sis);
    contourf(x,y,sis,20),hold on

    quiver(x,y,dx,dy);
    colorbar;
    if m>0
      title('source')
    else
      title('sink')
    end
     
  case {'vortex'}
    k=input('Please input the vortex strength \n');
    sis=-k.*log(r);
    [dx,dy]=gradient(sis);
    contourf(x,y,sis,20),hold on
    quiver(x,y,dx,dy);
    colorbar;

case {'doublet'}
    a=input("distance?");
    m=input('Please input the doublet strength \n');
    k=a.*m./pi;
    sis=-(k./r).*sin(theta);
    [dx,dy]=gradient(sis);
    contourf(x,y,sis,20),hold on
    quiver(x,y,dx,dy);
    colorbar;
  
     
      
end
