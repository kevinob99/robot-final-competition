function [exp] = hBeacon(pose,beaconNums,beaconLoc,map,robotRad)
%%
%hBeaconSonar finds the expected beacon data for a series of robot poses based
%on a list of beacons

% ASSUMPTIONS 
% Assume that this function will only be used for positive identification
% Assume the robot can only see one beacon at a time
% 
% INPUTS
% pose - robot pose 3x1 or 1x3
% beaconNums - tag numbers of beacons in question 
% beaconLoc - locations of beacons on the map [Nx3] - 
% 
% OUTPUTS
% expBeacons - expected camera readings [z_camera;-x_camera] 

%% constants 
camViewAngle = 2*pi/3; %view angle on a single side of the camera
camViewDist = 2; %maximum distance the camera can see in meters
bigNum = 100;

if size(pose,1) ~= 3
    pose = pose';
end

beacon = [];
for i = 1:length(beaconNums)
    beacon = [beacon; beaconLoc(beaconLoc(:,1) == beaconNums(i),:)];
end





%transition matrix to robot pose
R_Q_G = [cos(pose(3)) sin(pose(3));  -sin(pose(3)) cos(pose(3))];

%beacons in the camera frame
C_beacons = R_Q_G*(beacon(:,2:3)'-pose(1:2))-[robotRad;0];
exp = C_beacons;
%camera position in the global frame
camera = pose(1:2)+R_Q_G'*[robotRad;0];
%check whether there is a wall on the direct line between the beacon and
%the camera - if there is, set the expected measurement to a rediculous
%number
for i = 1:size(map,1)
    for j = 1:size(beacon,1)
        [isect,x,y,ua]= intersectPoint(camera(1),camera(2),...
            beacon(j,2),beacon(j,3),...
            map(i,1),map(i,2),map(i,3),map(i,4));
        if isect == 1
            exp(j*2-1:j*2,:) = bigNum;
        end
    end
end


end



