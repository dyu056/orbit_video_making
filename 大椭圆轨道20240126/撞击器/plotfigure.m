clear;
clc;
close all

linewidth = 1.5;
fontsize = 16;

y_prop = load("prop.txt");
y_Earth = load("Earth.txt");
y_Venus = load("Venus.txt");
y_Ast = load("Asteroid.txt");

figure(1)
plot3(y_Ast(:,2),y_Ast(:,3),y_Ast(:,4),'m','linewidth',linewidth);
hold on
plot3(y_Earth(:,2),y_Earth(:,3),y_Earth(:,4),'b','linewidth',linewidth);
hold on
plot3(y_Venus(:,2),y_Venus(:,3),y_Venus(:,4),'y','linewidth',linewidth);
hold on
plot3(y_prop(:,2),y_prop(:,3),y_prop(:,4),'k','linewidth',linewidth);
hold on
plot3(0,0,0,'or','markersize',6,'markerfacecolor',[1,0,0]);
hold on
legend("小行星","地球","金星","航天器","太阳",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
xlabel('x (km)','FontName','Times New Roman','FontSize',fontsize);
ylabel('y (km)','FontName','Times New Roman','FontSize',fontsize);
zlabel('z (km)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("日心赤道系下的轨道",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on

for i = 1:length(y_prop)
    distance_Sun_Prop(i,1) = norm(y_prop(i,2:4));
end
figure
plot((y_prop(:,1)-y_prop(1,1)) / 86400,distance_Sun_Prop,'linewidth',linewidth)
hold on
xlabel('t (day)','FontName','Times New Roman','FontSize',fontsize);
ylabel('distance (km)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("日器距离",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on

dy = y_prop;
dy(:,2:7) = y_prop(:,2:7) - y_Earth(:,2:7);
for i = 1:length(dy)
    distance_Earth_Prop(i,1) = norm(dy(i,2:4));
end
figure
plot((dy(:,1)-dy(1,1)) / 86400,distance_Earth_Prop,'linewidth',linewidth)
hold on
xlabel('t (day)','FontName','Times New Roman','FontSize',fontsize);
ylabel('distance (km)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("器地距离",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on

dy_Ast_Earth(:,1) = y_Ast(:,1);
dy_Ast_Earth(:,2:7) = y_Ast(:,2:7)-y_Earth(:,2:7);
figure
plot3(dy(:,2),dy(:,3),dy(:,4),'k','linewidth',linewidth);
hold on
plot3(dy_Ast_Earth(:,2),dy_Ast_Earth(:,3),dy_Ast_Earth(:,4),'m','linewidth',linewidth);
hold on
plot3(0,0,0,'ob','markersize',6,'markerfacecolor',[0,1,0]);
hold on
xlabel('x (km)','FontName','Times New Roman','FontSize',fontsize);
ylabel('y (km)','FontName','Times New Roman','FontSize',fontsize);
zlabel('z (km)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
legend("航天器","小行星","地球",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
title("地心赤道系下的轨道",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on
axis equal

figure
plot3(dy(1:40003,2),dy(1:40003,3),dy(1:40003,4),'k','linewidth',linewidth);
hold on
plot3(0,0,0,'ob','markersize',6,'markerfacecolor',[0,1,0]);
hold on
xlabel('x (km)','FontName','Times New Roman','FontSize',fontsize);
ylabel('y (km)','FontName','Times New Roman','FontSize',fontsize);
zlabel('z (km)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("地心赤道系下的轨道(局部)",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
xlim([-1000000, 1000000])
ylim([-1000000, 1000000])
zlim([-1000000, 1000000])
grid on
% axis equal

r1 = -y_Ast(:,2:4);
r2 = y_prop(:,2:4)-y_Ast(:,2:4);
for i = 1:length(r1)
    angle(i, 1) = acos(dot(r1(i,:), r2(i,:))/norm(r1(i,:))/norm(r2(i,:)));
end
figure
plot((dy(1:end-1,1)-dy(1,1)) / 86400,angle(1:end-1,1) * 180 / pi,'linewidth',linewidth)
hold on
xlabel('t (day)','FontName','Times New Roman','FontSize',fontsize);
ylabel('angle (deg)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("太阳-小行星-航天器夹角",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on

r1 = -y_Ast(:,2:4);
r2 = y_Earth(:,2:4)-y_Ast(:,2:4);
for i = 1:length(r1)
    angle(i, 1) = acos(dot(r1(i,:), r2(i,:))/norm(r1(i,:))/norm(r2(i,:)));
end
figure
plot((dy(:,1)-dy(1,1)) / 86400,angle * 180 / pi,'linewidth',linewidth)
hold on
xlabel('t (day)','FontName','Times New Roman','FontSize',fontsize);
ylabel('angle (deg)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("太阳-小行星-地球夹角",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on

r1 = y_Ast(:,2:4)-y_prop(:,2:4);
r2 = y_Earth(:,2:4)-y_prop(:,2:4);
for i = 1:length(r1)
    angle(i, 1) = acos(dot(r1(i,:), r2(i,:))/norm(r1(i,:))/norm(r2(i,:)));
end
figure
plot((dy(1:end-1,1)-dy(1,1)) / 86400,angle(1:end-1,1) * 180 / pi,'linewidth',linewidth)
hold on
xlabel('t (day)','FontName','Times New Roman','FontSize',fontsize);
ylabel('angle (deg)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("小行星-航天器-地球夹角",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on

r1 = -y_prop(:,2:4);
r2 = y_Earth(:,2:4)-y_prop(:,2:4);
for i = 1:length(r1)
    angle(i, 1) = acos(dot(r1(i,:), r2(i,:))/norm(r1(i,:))/norm(r2(i,:)));
end
figure
plot((dy(1:end-1,1)-dy(1,1)) / 86400,angle(1:end-1,1) * 180 / pi,'linewidth',linewidth)
hold on
xlabel('t (day)','FontName','Times New Roman','FontSize',fontsize);
ylabel('angle (deg)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("太阳-航天器-地球夹角",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on

dy(:,1) = y_prop(:,1);
dy(:,2:7) = y_prop(:,2:7)-y_Earth(:,2:7);
dy_Ast_Earth(:,1) = y_Ast(:,1);
dy_Ast_Earth(:,2:7) = y_Ast(:,2:7)-y_Earth(:,2:7);
dy_Erotate = dy;
dy_Ast_Erotate = dy_Ast_Earth;
for i = 1:length(dy_Erotate)
    M=zeros(3);
    M(1:3,1)=y_Earth(i,2:4)/norm(y_Earth(i,2:4));
    h = cross(y_Earth(i,2:4), y_Earth(i,5:7));
    M(1:3,3)=h'/norm(h);
    M(1:3,2)=cross(M(1:3,3),M(1:3,1));
    dy_Erotate(i,2:4) = dy(i,2:4)*M;
    dy_Erotate(i,5:7) = dy(i,5:7)*M;
    dy_Ast_Erotate(i,2:4) = dy_Ast_Earth(i,2:4)*M;
    dy_Ast_Erotate(i,5:7) = dy_Ast_Earth(i,5:7)*M;
end
figure
plot3(dy_Erotate(:,2),dy_Erotate(:,3),dy_Erotate(:,4),'k','linewidth',linewidth);
hold on
plot3(dy_Ast_Erotate(:,2),dy_Ast_Erotate(:,3),dy_Ast_Erotate(:,4),'m','linewidth',linewidth);
hold on
plot3(0.0,0.0,0.0,'o','color',[0,0,1],'markersize',6,'markerfacecolor',[0,0,1]);
hold on
plot3(dy_Erotate(end,2),dy_Erotate(end,3),dy_Erotate(end,4),'o','color','m','markersize',6,'markerfacecolor','m');
hold on
axis equal
legend("航天器轨迹","小行星轨迹","地球","小行星",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
xlabel('x (km)','FontName','Times New Roman','FontSize',fontsize);
ylabel('y (km)','FontName','Times New Roman','FontSize',fontsize);
zlabel('z (km)','FontName','Times New Roman','FontSize',fontsize);
set(gca,'FontName','Times New Roman','FontSize',fontsize,'LineWidth',linewidth,'FontWeight','bold');
title("日地回合坐标系下的轨道",'FontName','宋体',"fontsize",fontsize,'FontWeight','bold')
grid on
