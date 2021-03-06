function [ X_obs, X_close] = obsInfo(obs,X,mapType)
%OBSINFO extracts relevant information about an obstacle from an obstacle
%vector based on the map type
%   INPUTS
%   obs - 1xM vector defining the obsticle 
%   X   - point of interest [2x1]
%   mapType - type of obstacle - string
%       'sphere' - obs = [Xmid, Ymid, Radius]
%       'wall' [x1 y1 x2 y2];
%   OUTPUTS
%   X_obs - a single point that can define the obstacle 
%   X_close - the closest point on the obstacle to the point of interest

if strcmp(mapType,'sphere')
    %the characteristic point of the sphere is its middle
    X_obs = [obs(1);obs(2)];
    vec = (X-X_obs)/findDist(X,X_obs); %unit vector pointing from middle of sphere to point
    X_close = obs(3)*vec+[obs(1);obs(2)];
    %if you're at the center of the sphere, the 'closest point' is just the
    %point at theta = 0 on the sphere
    if X(1) == X_obs(1) && X(2) == X_obs(2)
        X_close = [obs(3)+obs(1);obs(2)];
    end
    
    
elseif strcmp(mapType,'wall')
    %the characteristic point of a wall is its middle
    X_obs = [mean(obs(1),obs(3));mean(obs(2),obs(4))];
    %find the shortest distance between a point and a line
    if obs(1) == obs(3)
        x = obs(1);
        y = X(2);
    else
        k = (obs(4)-obs(2))/(obs(3)-obs(1));
        x = (k*obs(1)-obs(2)+1/k*X(1)+X(2))/(k + 1/k);
        y = k*(x-obs(1))+obs(2);
    end
    X_close = [x;y];
    %make sure X_close is actually on the wall - if not, use the closest
    %endpoint as the closet point
    if (x > max(obs(1),obs(3)) || x < min(obs(2),obs(4)) || ...
            y > max(obs(2),obs(4)) || y < min(obs(2),obs(4)) )
        if findDist(X,[obs(1);obs(2)]) < findDist(X,[obs(3);obs(4)])
            X_close = [obs(1);obs(2)];
        else
            X_close = [obs(3);obs(4)];
        end
    end

end


end

