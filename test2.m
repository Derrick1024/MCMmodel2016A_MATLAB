%% 
clear;
syms a b c h1 h2 h3 delta Lambda1 Tf1 Tf2 Tm

A1=2*a*c+a*b+2*b*c;
A2=a*b;

q1=1/(1/h1+delta/Lambda1+1/h2)*(Tf1-Tf2);
q2=h3*(Tf1-Tf2);
q3=h1*(Tf1-Tm);
f=q1*A1+q2*A2;

f1=diff(f,a);
f2=diff(f,b);
f3=diff(f,c);
k1=vpa(subs(f1,{a,b,c,h1,h2,h3,delta,Lambda1,Tf1,Tf2,Tm}, {1.2,0.7,0.4,200,3,1000,0.06,0.63,40,25,36.5}))
k2=vpa(subs(f2,{a,b,c,h1,h2,h3,delta,Lambda1,Tf1,Tf2,Tm}, {1.2,0.7,0.4,200,3,1000,0.06,0.63,40,25,36.5}))
k3=vpa(subs(f3,{a,b,c,h1,h2,h3,delta,Lambda1,Tf1,Tf2,Tm}, {1.2,0.7,0.4,200,3,1000,0.06,0.63,40,25,36.5}))
x=0:0.1:10;
y=k1*x;
plot(x,y,'r','LineWidth',2)
hold on;
y=k2*x;
plot(x,y,'r','LineWidth',2)
hold on;
y=k3*x;
plot(x,y,'r','LineWidth',2)
title('Effect of tub shape/volume')
% \leftarrow k2=\partial\phi/\partialb=18069.19
% text(6,100000,'$\leftarrow \frac{\partial\phi}{\partial b}=18069.19$','interpreter','latex','FontName','Times New Roman','FontSize',16);
text(6,100000,'\leftarrow k2=\partial\phi/\partialb=18069.19');
text(6,60000,' \leftarrow k1=\partial\phi/\partiala=10551.89');
text(6,10000,' \downarrow k3=\partial\phi/\partialc=131.46');

