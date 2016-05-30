function [T,pop1_x,pop1_y,pop1_z]=solve_ode_20160527173911_620
% ------------------------------------------------------------
% Parameters:
% ------------------------------------------------------------
p=load('params.mat','p'); p=p.p;



downsample_factor=p.downsample_factor;
dt=p.dt;
T=(p.tspan(1):dt:p.tspan(2))';
ntime=length(T);
nsamp=length(1:downsample_factor:ntime);
% ------------------------------------------------------------
% Initial conditions:
% ------------------------------------------------------------
% seed the random number generator
rng(p.random_seed);
t=0; k=1;
% STATE_VARIABLES:
pop1_x = zeros(nsamp,p.pop1_Npop,'gpuArray');
  pop1_x(1,:) = [1];
pop1_y = zeros(nsamp,p.pop1_Npop,'gpuArray');
  pop1_y(1,:) = [2];
pop1_z = zeros(nsamp,p.pop1_Npop,'gpuArray');
  pop1_z(1,:) = [0.5];
  
% ###########################################################
% Numerical integration:
% ###########################################################
n=2;
for k=2:ntime
  t=T(k-1);
  pop1_x_k1=p.pop1_s*(pop1_y(n-1)-pop1_x(n-1));
  pop1_y_k1=p.pop1_r*pop1_x(n-1)-pop1_y(n-1)-pop1_x(n-1)*pop1_z(n-1);
  pop1_z_k1=-p.pop1_b*pop1_z(n-1)+pop1_x(n-1)*pop1_y(n-1);
  t=t+.5*dt;
  pop1_x_k2=p.pop1_s*(pop1_y(n-1)-pop1_x(n-1));
  pop1_y_k2=p.pop1_r*pop1_x(n-1)-pop1_y(n-1)-pop1_x(n-1)*pop1_z(n-1);
  pop1_z_k2=-p.pop1_b*pop1_z(n-1)+pop1_x(n-1)*pop1_y(n-1);
  pop1_x_k3=p.pop1_s*(pop1_y(n-1)-pop1_x(n-1));
  pop1_y_k3=p.pop1_r*pop1_x(n-1)-pop1_y(n-1)-pop1_x(n-1)*pop1_z(n-1);
  pop1_z_k3=-p.pop1_b*pop1_z(n-1)+pop1_x(n-1)*pop1_y(n-1);
  t=t+.5*dt;
  pop1_x_k4=p.pop1_s*(pop1_y(n-1)-pop1_x(n-1));
  pop1_y_k4=p.pop1_r*pop1_x(n-1)-pop1_y(n-1)-pop1_x(n-1)*pop1_z(n-1);
  pop1_z_k4=-p.pop1_b*pop1_z(n-1)+pop1_x(n-1)*pop1_y(n-1);
  % ------------------------------------------------------------
  % Update state variables:
  % ------------------------------------------------------------
  pop1_x(n)=pop1_x(n-1)+(dt/6)*(pop1_x_k1+2*(pop1_x_k2+pop1_x_k3)+pop1_x_k4);
  pop1_y(n)=pop1_y(n-1)+(dt/6)*(pop1_y_k1+2*(pop1_y_k2+pop1_y_k3)+pop1_y_k4);
  pop1_z(n)=pop1_z(n-1)+(dt/6)*(pop1_z_k1+2*(pop1_z_k2+pop1_z_k3)+pop1_z_k4);
  n=n+1;
end
T=T(1:downsample_factor:ntime);
