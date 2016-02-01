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
Tc=40;Th=55;Tm=36.5;
Tf1=Tc; Tf2=25;
% Tw1;Tw2;
h1=200; % 水->陶瓷
h2=3; % 陶瓷->空气
h3=h1; % 水->空气
Lambda1=1.3; % 陶瓷
Lambda2=0.635; % 水
Lambda3=0.0263;%空气
C=4200;
rho=1000;
%% Const Define model_improve_1
rhom=1020;%人体密度
Lm=1.7;%人的身高
Mm=70;%人的质量
rm=(Mm/rhom/Lm/pi)^(0.5);%假想人体近似于一个圆柱体，则这个圆柱体的底面半径
Hm= 0.2;%人在水里的深度

%% (要通过理论对h1，h2，h3进行确定)
%首先确定各边界上流体的运动形态
%空气对陶瓷的热对流为自然对流
%上表面水对空气的对流是自然对流
%浴缸壁上水的对流方式由雷诺数Re和格拉晓夫数的大小来确定
vicw=0.659;
vica=15.53;%水和空气的动力粘性系数
g=9.8;%重力加速度
alfaw=3.86;
alfaa=27.23;%水和空气的热膨胀率
Grw=g*alfaw*(Tf1-Tf2)*c/(vicw^2);
Gra=g*alfaa*(Tf1-Tf2)*c/(vica^2);
Rewmax=(Grw/10)^0.5;
vwmax=Rewmax*c/vicw;%可见使强迫对流效应忽略不计是最大的流速为4.38m/s，远大于实际情况，因此水对浴缸壁的流体形式为自然对流
%同时由于Re数很小，远小于临界Re数，所有的流体中不存在湍流
Prw=4.31;
Pra=0.702;%普拉特数
%自然对流下系数的计算
h1=((0.6^5)*(Lambda2*100)^4*g*alfaw*(Tf1-Tf2)*Prw/c/vicw^2)^(0.25);
h2=((0.6^5)*(Lambda3*100)^4*g*alfaa*(Tf1-Tf2)*Pra/c/vica^2)^(0.25);
h3=h1;
%% Compute 1（水中有人，phi3中考虑了人的具体形状）
% % 陶瓷面面积
A1=2*a*c+a*b+2*b*c;
% % 空气面面积
A2=a*b;
% % 热流量
phi1=1./(1./h1+delta./Lambda1+1./h2)*A1*(Tf1-Tf2);
phi2=h3*A2*(Tf1-Tf2);
phi3=2*pi*Lm*Lambda2/(log(Hm/rm+sqrt((Hm/rm)^2-1)))*(Tf1-Tm);
phi=phi1+phi2+phi3;
% dQH==phi;
S1=phi./(C*rho*(Th-Tf1));
S1*1000
% mesh(h1,h2,S2*1000);

%% Compute 3（讨论在此模型下tub/person的shape/volume/temperature对模型的影响）
% 计算两种散热面的热流密度
q1=1./(1./h1+delta./Lambda1+1./h2)*(Tf1-Tf2);
q2=h3*(Tf1-Tf2);
q3=h1*(Tf1-Tm);
q2/q1;   % 这个值反应了两种面的散热能力对比，由结果可知水面的散热能力大约是陶瓷面的131倍
q3/q1;   % 这个值反应了两种面的散热能力对比，由结果可知人的散热能力大约是陶瓷面的31倍

%% compute 4(person's motion)
% 人的运动会加快水的流动，使得水变为了强制对流，这时对流传热系数h1、h3会增大
% 为了方便研究。我们定义一个系数n，h1变为原来的n倍
% n=1:0.01:5;
% % 根据系数的不同，可以得到以下图像
% h1=n.*h1;
% h3=h1;
% phi1=1./(1./h1+delta./Lambda1+1./h2)*A1*(Tf1-Tf2);
% phi2=h3*A2*(Tf1-Tf2);
% phi3=2*pi*Lm*Lambda2/(log(Hm/rm-sqrt((Hm/rm)^2-1)))*(Tf1-Tm);
% phi=phi1+phi2+phi3;
% % dQH==phi;
% S1=phi./(C*rho*(Th-Tf1));
% S1*1000;
% plot(h1,S1*1000,'r','LineWidth',2');
% xlabel('h1/ W (m^2 * K)')
% ylabel('S1 / L')
% text(350,0.00018*1000,' Effect on S1 \rightarrow');

%% compute 5(shape of the person)
% Lm= 1.5:0.005:1.9;
% Mm= 50:0.5:90;
[Lm,Mm]=meshgrid(1.5:0.4/50:1.9,45:45/50:90);
phi1=1./(1./h1+delta./Lambda1+1./h2)*A1*(Tf1-Tf2);
phi2=h3*A2*(Tf1-Tf2);
rm=(Mm./rhom./Lm./pi).^(0.5);
phi3=2*pi*Lm.*Lambda2./(log(Hm./rm+sqrt((Hm./rm).^2-1)))*(Tf1-Tm);
phi=phi1+phi2+phi3;
Sm=phi./(C*rho*(Th-Tf1));
mesh(Lm,Mm,Sm*1000);
xlabel('Lm/ m')
ylabel('Mm / Kg')
%对于体重在50kg-90kg，身高1.5m-1.9m之间的人而言，热流量φ会随着身高体重的增加而增加，呈现一种线性变化的趋势。















