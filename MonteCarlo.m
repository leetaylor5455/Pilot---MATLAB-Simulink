runs=5;
startingtime=0;
Gimbal_offset_X(1)=0;
Gimbal_offset_Y(1)=0;
f1 = figure;
tiledlayout(2,4);
a= nexttile;
b= nexttile;
c=nexttile;
d=nexttile;
e=nexttile;
f=nexttile;
g=nexttile;
h=nexttile;

maxdistance=0;
tf_numerator=[1.179415474733569e+05,-7.448404664217674e+05,1.081535468913975e+10];
tf_denominator=[1,2.355092453963941e+02,4.271778657695507e+04,4.659766203065492e+06,2.988724574168830e+08,1.078180281826367e+10];
r=0;
m=1.1;
Ixy = 0.25*m*0.08^2 + 0.33*m*0.5^2; % Approximate inertia of rocket (shortened because mass is focused)
Imatrix=[Ixy 0 0; 0 Ixy 0; 0 0 1000000000000];
k_gains_variation=[1,1.05,0.95,1.1,0.9,0.85,1.15,0.97,1.03,1.01];
roll_variation=[-0.0349066,-0.0174533,0,0.0174533,0.0349066];
pitch_variation=[-0.0349066,-0.0174533,0,0.0174533,0.0349066];
yaw_variation=[-0.0349066,-0.0174533,0,0.0174533,0.0349066];
Position_X = zeros(10);
Position_Y = zeros(10);
Position_Z = zeros(10);
Orientation_about_X= zeros(10);
Orientation_about_Y= zeros(10);
Orientation_about_Z=zeros(10);
time=zeros(1000);
drageq=0.5*1.2256;
A=[0 1 0
   0 0 0
   1 0 0];
B=[0
   1
   0];
Qx=[10 0 0
    0 1 0
    0 0 1];
Qu=0.005;
K=lqr(A, B, Qx, Qu)
size(B);
size(K);




for i=1:runs
    %% edit comments based on what you are varying either: initial attitude, gimbal misalignment or gains
    %%k_variation=k_gains_variation(1+mod(i,10));          
    k_variation=1;
    %%gimbal_offset_yaw=0;
    gimbal_offset_yaw=(randn*0.0174533*0.5);
    %%initialmisalignment1=(randn*0.0174533*0.5);
    %%initialmisalignment2=(randn*0.0174533*0.5);
    initialmisalignment1=0;
    initialmisalignment2=0;
    %%gimbal_offset_pitch=0;
    gimbal_offset_pitch=(randn*0.0174533*0.5);
    %%pitch_variation1=pitch_variation(1+mod(i,5));
    %%roll_variation1=roll_variation(1+mod(i,5));
    %%yaw_variation1=yaw_variation(1+mod(i,5));
    pitch_variation1=0;
    yaw_variation1=0;
    roll_variation1=0;
    torquemultiplier=(randn*0.0174533*15);
    sim("fromscratch.slx")
    Positionvector = load("Position.mat");
    Orientationvector= load("Orientation.mat");
    gimbal_angle_pitch=load("gimbleanglepitch.mat");
    gimbal_angle_yaw=load("gimbalangleyaw.mat");
    gimbalyaw=(gimbal_angle_yaw.angley(2,1:3310)*(360/(2*pi)));
    gimbalpitch=(gimbal_angle_pitch.anglep(2,1:3310)*(360/(2*pi)));
    Position_X = Positionvector.Position(2,:);
    Position_Y = Positionvector.Position(3,:);
    Position_Z = Positionvector.Position(4,:);
    Orientation_about_X= (Orientationvector.Orientation(2,:))*(360/(2*pi));
    Orientation_about_Y= (Orientationvector.Orientation(3,:))*(360/(2*pi));
    Orientation_about_Z= (Orientationvector.Orientation(4,:))*(360/(2*pi));
    time=Orientationvector.Orientation(1,:);
    timeg=gimbal_angle_yaw.angley(1,1:3310);
    axes(a)
    hold on
    txt = ['Offset Pitch: ',num2str(gimbal_offset_pitch*-360/(2*pi))];
    plot(time,Orientation_about_X, 'DisplayName', txt)
    axes(b)
    hold on
    plot(time,Orientation_about_Y)
    axes(c)
    hold on
    plot(time,Orientation_about_Z)
    axes(d)
    hold on
    plot3(Position_X,Position_Y,Position_Z)
    axes(e)
    hold on 
    plot(timeg,gimbalyaw)
    axes(f)
    hold on 
    plot(timeg,gimbalpitch)
    yline(gimbal_offset_pitch*-360/(2*pi))
    axes(g)
    hold on
    plot(Position_X,Position_Y)
    axes(h)
    hold on
    plot(Position_X,Position_Y)
    distance(i)=sqrt((Position_X(end)^2)+(Position_Y(end)^2)) ;
    if distance(i)> maxdistance
        maxdistance=distance(i);
    else
        maxdistance=maxdistance;
    end
   
end
meandistance=sum(distance,"all");
meandistance=meandistance/runs;
axes(d)
title(sprintf('%d Simulated Monte-Carlo Flight Trajectories',runs))
xlabel('Downrange (m)')
ylabel('Crossrange (m)')
zlabel('Altitude (m)')
axis equal 
axes(a)
title('Pitch')
xlabel('Time(s)')
ylabel('Orientation (degrees)')
legend show
axes(b)
title('Yaw')
xlabel('Time(s)')
ylabel('Orientation (degrees)')
axes(c)
title('Roll')
xlabel('Time(s)')
ylabel('Orientation (degrees)')
axes(e)
title('gimbal angle yaw')
xlabel('Time(s)')
ylabel('Orientation (degrees)')
axes(f)
title('gimbal angle pitch')
xlabel('Time(s)')
ylabel('Orientation (degrees)')
axes(g)
title('view from above')
xlabel('x distance m)')
ylabel('y distance m')
axes(h)
hold on
r=maxdistance;
th = 0:pi/50:2*pi;
xunit = r.*cos(th) ;
yunit = r.*sin(th);
plot(xunit, yunit);
r=meandistance;
th = 0:pi/50:2*pi;
xunit = r .* cos(th) ;
yunit = r .* sin(th);
plot(xunit, yunit);
title('view from above')
xlabel('x distance m')
ylabel('y distance m')
legend('maximum rocket dispersion','mean rocket dispersion')


