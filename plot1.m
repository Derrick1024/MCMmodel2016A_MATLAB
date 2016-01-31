%%
% 浴缸的长宽高a，b，c；壁厚delta
% 水的体积Vw 人的体积Vm（假定为圆柱，则有rm和hm）
% 人体表面积 A3
% 热流量phi（水与陶瓷面热流量phi1，水与空气面热流量phi2，水与人的热流量phi3）
% 热流密度q（水与陶瓷面热流密度q1，水与空气面热流密度q2，水与人的热流密度q3）
% 表面积A（陶瓷面表面积A1，空气面表面积A2，人的表面积A3）
% 人体沐浴舒适温度Tc，外加水温Th，体温Tm
% 浴缸实际水温Tf1 空气温度Tf2
% 壁内温Tw1，壁外温Tw2
% 对流换热系数 水-陶瓷->h1 陶瓷-空气->h2 水-空气->h3
% 导热系数 陶瓷->Lambda1 水->Lambda2
% 外加水的流量 model-1 ->S1（单位L）
%             model-2 ->S2（单位L）
% 水的比热容C
% 水的密度rho

clear;
%% Const Define
a=1.2;b=0.7;c=0.4;delta=0.06;
Vw=a*b*c; 
% rm=; hm=; 
Vm=0.059; % 体重65KG，密度取1.1*10^3
A3=1.7161;% 体表面积（m2）= 0.0061×170（cm）＋0.0128×65（kg）－0.1529
% phi;q;A;
Tc=40;Th=55;Tm=30:0.01:37;
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

%% Compute 1（单一水池，无人，假设外加热水加入立刻混合均匀）
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
S1*1000;

%% Compute 2（水池中加入人）
% 假定人是一个等温体，与水发生对流换热
phi1=1/(1/h1+delta/Lambda1+1/h2)*A1*(Tf1-Tf2);
phi2=h3*A2*(Tf1-Tf2);
phi3=h1*A3*(Tf1-Tm);
phi=phi1+phi2+phi3;
% dQH==phi;
S2=phi/(C*rho*(Th-Tf1));
S2*1000;

%% Compute 3（讨论在此模型下tub/person的shape/volume/temperature对模型的影响）
% 计算两种散热面的热流密度
q1=1/(1/h1+delta/Lambda1+1/h2)*(Tf1-Tf2);
q2=h3*(Tf1-Tf2);
q3=h1*(Tf1-Tm);
q2/q1;   % 这个值反应了两种面的散热能力对比，由结果可知水面的散热能力大约是陶瓷面的380倍
q3/q1;   % 这个值反应了两种面的散热能力对比，由结果可知人的散热能力大约是陶瓷面的18倍

plot(Tm,S2*1000,'r','LineWidth',2')
xlabel('Tm / \circC')
ylabel('S1 / L')


















