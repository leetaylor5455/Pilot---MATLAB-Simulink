runs=4;
startingtime=0;
Gimbal_offset_X(1)=0;
Gimbal_offset_Y(1)=0;
f1 = figure;
tiledlayout(1,4);
a= nexttile;
b= nexttile;
c=nexttile;
d=nexttile;
k_gains_variation=[1,1.05,0.95,1.1,0.9,0.85,1.15,0.97,1.03,1.01];
roll_variation=[-0.0349066,-0.0174533,0,0.0174533,0.0349066];
pitch_variation=[-0.0349066,-0.0174533,0,0.0174533,0.0349066];
yaw_variation=[-0.0349066,-0.0174533,0,0.0174533,0.0349066];
for i=1:runs
    %% edit comments based on what you are varying either: initial attitude, gimbal misalignment or gains
    %%k_variation=k_gains_variation(1+mod(i,10));          
    k_variation=1;
    Gimbal_offset_X(2)=(randn*0.0174533*0.1);
    %%Gimbal_offset_X(2)=0;
    Gimbal_offset_Y(2)=(randn*0.0174533*0.1);
    %%Gimbal_offset_Y(2)=0;
    %%pitch_variation1=pitch_variation(1+mod(i,5));
    %%roll_variation1=roll_variation(1+mod(i,5));
    %%yaw_variation1=yaw_variation(1+mod(i,5));
    pitch_variation1=0;
    yaw_variation1=0;
    roll_variation1=0;
    sim("sixdof.slx")
    Positionvector = load("Position.mat");
    Orientationvector= load("Orientation.mat");
    Position_X = Positionvector.Position(2,:);
    Position_Y = Positionvector.Position(3,:);
    Position_Z = Positionvector.Position(4,:);
    Orientation_about_X= (Orientationvector.Orientation(2,:))*(360/(2*pi));
    Orientation_about_Y= (Orientationvector.Orientation(3,:))*(360/(2*pi));
    Orientation_about_Z= (Orientationvector.Orientation(4,:))*(360/(2*pi));
    time=Orientationvector.Orientation(1,:);
    axes(a)
    hold on
    plot(time,Orientation_about_X)
    axes(b)
    hold on
    plot(time,Orientation_about_Y)
    axes(c)
    hold on
    plot(time,Orientation_about_Z)
    axes(d)
    hold on
    plot3(Position_X,Position_Y,Position_Z)
    
   
end

title(sprintf('%d Simulated Monte-Carlo Flight Trajectories',runs))
xlabel('Downrange (m)')
ylabel('Crossrange (m)')
zlabel('Altitude (m)')
axis equal 
axes(a)
title('Pitch')
xlabel('Time(s)')
ylabel('Orientation (degrees)')
axes(b)
title('Yaw')
xlabel('Time(s)')
ylabel('Orientation (degrees)')
axes(c)
title('Roll')
xlabel('Time(s)')
ylabel('Orientation (degrees)')