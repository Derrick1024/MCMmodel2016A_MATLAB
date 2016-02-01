%% 
clear;
syms a b c h1 h2 h3 delta Lambda1 Tf1 Tf2 Tm

A1=2*a*c+a*b+2*b*c;
A2=a*b;
A3=1.7161;

q1=1/(1/h1+delta/Lambda1+1/h2)*(Tf1-Tf2);
q2=h3*(Tf1-Tf2);
q3=h1*(Tf1-Tm);
f=q1*A1+q2*A2+q3*A3;

f1=diff(f,a)*a/f;
f2=diff(f,b)*b/f;
f3=diff(f,c)*c/f;

k1=vpa(subs(f1,{a,b,c,h1,h2,h3,delta,Lambda1,Tf1,Tf2,Tm}, {1.2,0.7,0.4,200,3,1000,0.06,0.63,40,25,36.5}))
k2=vpa(subs(f2,{a,b,c,h1,h2,h3,delta,Lambda1,Tf1,Tf2,Tm}, {1.2,0.7,0.4,200,3,1000,0.06,0.63,40,25,36.5}))
k3=vpa(subs(f3,{a,b,c,h1,h2,h3,delta,Lambda1,Tf1,Tf2,Tm}, {1.2,0.7,0.4,200,3,1000,0.06,0.63,40,25,36.5}))


x=0:0.1:10;
y=k1*x;
plot(x,y,'r','LineWidth',2)
hold on;
y=k2*x;
plot(x,y,'g','LineWidth',2)
hold on;
y=k3*x;
plot(x,y,'b','LineWidth',2);
text(5,4,'\leftarrow k2 = 0.911');
text(4,6,' k1 = 0.912 \rightarrow');
text(6,0.50,' \downarrow k3 = 0.003');

