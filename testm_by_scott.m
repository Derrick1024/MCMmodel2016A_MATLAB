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
clear
%% Const Define
a=1.2;b=0.7;c=0.4;delta=0.06;
Vw=a*b*c; 
% phi;q;A;
Tc=40;Th=55;Tm=36.5;
Tf1=Tc; Tf2=25;
% Tw1;Tw2; 
h1=200; % 水->陶瓷
h2=3; % 陶瓷->空气
% [h1,h2]=meshgrid(200:800/100:1000,3:7/100:10);
h3=h1; % 水->空气
Lambda1=1.3; % 陶瓷
Lambda2=0.635; % 水
Lambda3=0.0263;%空气
C=4200;
rho=1000;
% S1;
rhom=1020;%人体密度
Lm=1.7;%人的身高
Mm=70;%人的质量
rm=(Mm/rhom/Lm/pi)^(0.5);%假想人体近似于一个圆柱体，则这个圆柱体的底面半径
Hm= 0.2;%人在水里的深度
%% Compute 1（单一水池，无人，假设外加热水加入立刻混合均匀）
% % 陶瓷面面积
A1=2*a*c+a*b+2*b*c;
% % 空气面面积
A2=a*b;
% % 热流量
% phi1=1./(1./h1+delta./Lambda1+1./h2)*A1*(Tf1-Tm)
% phi2=h3*A2*(Tf1-Tf2);
% phi=phi1+phi2;
% % dQH==phi;
% S1=phi./(C*rho*(Th-Tf1));
% S1*1000;
% % mesh(h1,h2,S1*1000);

%% Compute 2（水池中加入人）
% 假定人是一个等温体，与水发生对流换热
phi1=1./(1./h1+delta./Lambda1+1./h2)*A1*(Tf1-Tf2);
phi2=h3*A2*(Tf1-Tf2);
phi3=2*pi*Lm*Lambda2/(log(Hm/rm+sqrt((Hm/rm)^2-1)))*(Tf1-Tm);
phi=phi1+phi2+phi3;
% dQH==phi;
S2=phi./(C*rho*(Th-Tf1))
S2*1000
% mesh(h1,h2,S2*1000);
%% Compute 3（讨论在此模型下tub/person的shape/volume/temperature对模型的影响）
% 计算两种散热面的热流密度
q1=1./(1./h1+delta./Lambda1+1./h2)*(Tf1-Tf2);
q2=h3*(Tf1-Tf2);
q3=h1*(Tf1-Tm);
q2/q1;   % 这个值反应了两种面的散热能力对比，由结果可知水面的散热能力大约是陶瓷面的77倍
q3/q1;   % 这个值反应了两种面的散热能力对比，由结果可知人的散热能力大约是陶瓷面的18倍
%  <在此模型下>
% （1）对tub而言，由shape/volume带来的对模型结果的变化可以归结为与空气/陶瓷面分别接触的表面积的大小的影响
% 例如保持其shape不变（长方体）而改变其volume（a*b*c变化），亦或保持其volume不变（a*b*c不变）而改变其shape
% 其结果都是不确定的，因为两表面积的变化不确定；
% 只有确定的去改变其两表面积的大小，才会使模型的结果产生确定的变化；
% （2）对person而言，对原始模型的影响仅仅是带来了phi3的一项热流量，而这一项也仅与人的表面积有关
% 因此由shape/volume带来的对模型结果的变化可以归结为人的表面积的大小的影响，结论与（1）类似
% 而temperature（Tm）的变化使得q3发生了改变。此时人与水接触面的散热能力发生了变化，其结果会发生确定的改变
% 接下里会在<test2.m>中具体讨论这些变化

%% compute 4(person's motion)
% 人的运动会加快水的流动，使得水变为了强制对流，这时对流传热系数h1、h3会增大
% 根据增程度的不同，可以得到以下图像
h1=200:0.1:1000;
h3=h1;
phi1=1./(1./h1+delta./Lambda1+1./h2)*A1*(Tf1-Tf2);
phi2=h3*A2*(Tf1-Tf2);
phi=phi1+phi2;
% dQH==phi;
S1=phi./(C*rho*(Th-Tf1));
S1*1000;
phi3=2*pi*Lm*Lambda2/(log(Hm/rm+sqrt((Hm/rm)^2-1)))*(Tf1-Tm)*ones(1,8001);
phi=phi1+phi2+phi3;
% dQH==phi;
S2=phi./(C*rho*(Th-Tf1));
S2*1000;
% plot(h1,S1*1000,'r','LineWidth',2');?
% hold on;
% plot(h1,S2*1000,'r','LineWidth',2');
% title('Effect on S1/S2')
% xlabel('h1/ W (m^2 * K)')
% ylabel('S1/S2 / L')
% text(350,0.00018*1000,' Effect on S2 \rightarrow');
% text(600,0.0001*1000,'\leftarrow Effect on S1');
%% compute 5(shape of the person)
% Lm= 1.5:0.005:1.9;
% Mm= 50:0.5:90;
% [Lm,Mm]=meshgrid(1.5:0.005:1.9,50:0.5:90);
% phi1=1./(1./h1+delta./Lambda1+1./h2)*A1*(Tf1-Tf2)
% phi2=h3*A2*(Tf1-Tf2);
% rm=(Mm./rhom./Lm./pi).^(0.5);
% phi3=2*pi*Lm.*Lambda2./(log(Hm./rm+sqrt((Hm./rm).^2-1)))*(Tf1-Tm);
% phi=phi1+phi2+phi3;
% Sm=phi./(C*rho*(Th-Tf1));
% mesh(Lm,Mm,Sm*1000);
% %对于体重在50kg-90kg，身高1.5m-1.9m之间的人而言，热流量φ会随着身高体重的增加而增加，呈现一种线性变化的趋势。
%% compute6 自然对流对对流传导系数h的修正
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
phi1=1./(1./h1+delta./Lambda1+1./h2)*A1*(Tf1-Tf2);
phi2=h3*A2*(Tf1-Tf2);
phi3=2*pi*Lm*Lambda2/(log(Hm/rm+sqrt((Hm/rm)^2-1)))*(Tf1-Tm);
phi=phi1+phi2+phi3;
S2=phi./(C*rho*(Th-Tf1));
S2*1000