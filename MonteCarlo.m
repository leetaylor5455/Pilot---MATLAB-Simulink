runs=10;
startingtime=0;
Gimbal_offset_X(1)=0;
Gimbal_offset_Y(1)=0;
f1 = figure;
tiledlayout(1,4);
a= nexttile;
b= nexttile;
c=nexttile;
d=nexttile;
for i=1:runs
    Gimbal_offset_X(2)=randn*0.0174533*0.33
    Gimbal_offset_Y(2)=randn*0.0174533*0.33
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