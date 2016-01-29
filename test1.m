%%
% 浴缸的长宽高a，b，c；壁厚delta
% 水的体积Vw 人的体积Vm（假定为圆柱，则有rm和hm）
% 热流量phi（陶瓷面热流量phi1，空气面热流量phi2），热流密度q，表面积A(陶瓷面表面积A1，空气面表面积A2)
% 人体沐浴舒适温度Tc，外加水温Th，体温Tm
% 浴缸实际水温Tf1 空气温度Tf2
% 壁内温Tw1，壁外温Tw2
% 对流换热系数 水-陶瓷->h1 陶瓷-空气->h2 水-空气->h3
% 导热系数 陶瓷->Lambda1 水->Lambda2
% 外加水的流量S1
% 水的比热容C
% 水的密度rho

clear;
%% Const Define
a=1.2;b=0.7;c=0.4;delta=0.06;
Vw=a*b*c; 
% rm=; hm=; 
Vm=0.059; % 密度取1.1
% phi;q;A;
Tc=40;Th=55;Tm=36.5;
Tf1=Tc; Tf2=25;
% Tw1;Tw2; 
h1=200; % 水->陶瓷
h2=3; % 陶瓷->空气
h3=1000; % 水->空气
Lambda1=1.3; % 陶瓷
Lambda2=0.63; % 水
C=4200;
rho=1000;
% S1;

%% Compute
% 陶瓷面面积
A1=2*a*c+a*b+2*b*c;
% 空气面面积
A2=a*b;
% 热流量
phi1=1/(1/h1+delta/Lambda1+1/h2)*A1*(Tf1-Tf2);
phi2=h3*A2*(Tf1-Tf2);
phi=phi1+phi2;
% dQH==phi;
S1=phi/(C*rho*(Th-Tf1));

S1*1000























