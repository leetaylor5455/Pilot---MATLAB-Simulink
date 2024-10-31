runs=10;
startingtime=0;
f1 = figure;
tiledlayout(1,2);
a= nexttile;
b= nexttile;
for i=1:runs
    Gimbal_offset_X=randn*0.0174533*0.33;
    sim("threedof.slx");
    Positionvector = load("Position3dof.mat");
    Orientationvector= load("Orientation3dof.mat");
    Position_X = Positionvector.position(2,:);
    Position_Z = Positionvector.position(3,:);
    Orientation= Orientationvector.orientation(2,:);
    time=Orientationvector.orientation(1,:);
    axes(a)
    hold on
    plot(time,Orientation)
    axes(b)
    hold on
    plot(Position_X,Position_Z)
    
   
end

title(sprintf('%d Simulated Monte-Carlo Flight Trajectories',runs))
xlabel('Crossrange (m)')
ylabel('Altitude (m)')
axis equal 
axes(a)
title('Orientation ')
xlabel('Time(s)')
ylabel('Orientation (radians)')

