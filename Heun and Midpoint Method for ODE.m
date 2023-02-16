close all;
clear all;
clc;

t(1)=0; x(1)=0.5; z(1)=1;   %Initial conditions: when t=0, velocity=1, displacement=0.5
h=0.2;        %Step size is 0.2
t=[0:h:8];    %Create a time array from 0 until 8 with step size h = 0.2
N=length(t);  %Store N as the length of time array

%Heun's Method
for i=1:N-1                           %Do a loop from i=1 until N-1
  dxdt(i) = z(i);                     %Define the 1st equation by introducing z as dxdt
  dzdt(i) = -(2.*dxdt(i) + 5*x(i));   %Define the 2nd equation by substituting z and dzdt into original equation
  t(i+1) = t(1) + i*h;                %Compute the time at the respective iteration

  x0 = x(i) + dxdt(i)*h;              %Compute the displacement predictor,the end point slope
  z0 = z(i) + dzdt(i)*h;              %Compute the velocity predictor,the end point slope

  islope_x = dxdt(i);                 %Compute the initial slope (dxdt or z) of displacement
  ave_slope_x = (islope_x + z0)/2;    %Compute the average slope from the sum of initial point slope and end point slope
  x(i+1) = x(i) + ave_slope_x*h;      %Compute the displacement at the respective iteration

  islope_z = dzdt(i);                            %Compute the initial slope (dzdt) of velocity
  ave_slope_z = (islope_z + (-2*z0 - 5*x0))/2;   %Compute the average slope from the sum of initial point slope and end point slope
  z(i+1) = z(i) + ave_slope_z*h;                 %Compute the velocity at the respective iteration
end

time = t';      %Store the time as transpose of t
d_Heun = x';    %Store the result of Heun displacement as transpose of x
v_Heun = z';    %Store the result of Heun velocity as transpose of z

%The Midpoint Method
for i=1:N-1                           %Do a loop from i=1 until N-1
  dxdt(i) = z(i);                     %Define the 1st equation by introducing z as dxdt
  dzdt(i) = -(2.*dxdt(i) + 5*x(i));   %Define the 2nd equation by substituting z and dzdt into original equation
  t(i+1) = t(1) + i*h;                %Compute the time at the respective iteration

  x_half = x(i) + dxdt(i)*(h/2);      %Compute the displacement slope at the midpoint
  z_half = z(i) + dzdt(i)*(h/2);      %Compute the velocity slope at the midpoint

  x(i+1) = x(i) + z_half*h;                 %Compute the displacement at the respective iteration
  z(i+1) = z(i) - (2*z_half + 5*x_half)*h;  %Compute the velocity at the respective iteration

end
d_midpoint = x';  %Store the result of Midpoint displacement as transpose of x
v_midpoint = z';  %Store the result of Midpoint velocity as transpose of z

%ODE45 Method
function dxdt = twoeq(t,x)            %Create a function dxdt with 2 inputs which are t and x
  dxdt(1) = x(2);                     %Define the 1st equation with x(2) corresponding to the first derivative
  dxdt(2) = -(2*dxdt(1) + 5*x(1));    %Define the 2nd equation by substituting dxdt(1) into it
  dxdt = dxdt';                       %Store the result of dxdt as transpose of dxdt
end

time_span=[0:h:8];            %Create a time span array from 0 until 8 with step size h = 0.2
initial_condition=[1,0.5];    %Store initial condition as velocity(dxdt)=1 and displacement(x)=0.5

[t,x] = ode45(@twoeq,time_span,initial_condition);  %Compute the displacement and velocity using ode45 function

d_ODE45 = x(:,1);   %Store the result of ODE45 displacement from the all row and column 1 from Matrix x
v_ODE45 = x(:,2);   %Store the result of ODE45 velocity from the all row and column 2 from Matrix x

%Print the velocity table
printf("Velocity: \n");
printf("   Time(s)   Heun   Midpoint   ODE45 \n");
printf("============================================\n")
v = [time, v_Heun, v_midpoint, v_ODE45]       %Print time, velocity results from Heun, Midpoint and ode45 function

%Print the displacement table
printf("Displacement: \n");
printf("   Time(s)   Heun   Midpoint   ODE45 \n");
printf("============================================\n")
d = [time, d_Heun, d_midpoint, d_ODE45]     %Print time, displacement results from Heun, Midpoint and ode45 function

figure(1)                 %Create figure plot 1
plot(time,d_Heun, 'g');   %Plot the Heun displacement vs time with green line
grid on;                  %Put the grid on the plot
hold on;
plot(time,v_Heun, 'b');   %Plot the Heun velocity vs time with blue line
xlabel("Time(s)");        %Label x axis with time
ylabel("Displacement(m) & Velocity(m/s)");  %Label y axis with displacement(m) and velocity(m/s)
title("d2x/dt2 + 2(dx/dt) + 5x = 0");       %Label the plot title
legend({"Displacement" "Velocity"});        %Label the line legend

figure(2)                   %Create figure plot 2
plot(d_Heun,v_Heun, 'b');   %Plot Heun velocity vs Heun displacement with blue line
grid on;                    %Put the grid on the plot
xlabel("Displacement(m)");  %Label x axis with displacement
ylabel("Velocity(m/s)");    %Label y axis with velocity
title("d2x/dt2 + 2(dx/dt) + 5x = 0"); %Label the plot title

