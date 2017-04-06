function segments = MergeCurveSegmentsModified(x, y, segments, parameters,I)
% segments = MergeCurveSegments(x, y, segments, parameters)
% (x, y)  : the input (raw) points from curve detection algorithm
% segments: original curve segments from curve tracing algorithm
% parameters = [max_distance num_discardpts line_avglen slope_diff]
%   max_distance : maximum distance between end points of the segments
%   num_discardpts: number of the end points to discard (possibly noisy
%   points) for calculations
%   line_avglen : number of end points of the curve to use for line fitting
%   and determining the average direction of the curve segment
%   slope_diff : maximum slop difference between the direction of two
%   segments
n = 1;
while (n <= length(segments)),
    idx1 = segments{n};
    x1 = x(idx1);
    y1 = y(idx1);
%     figure(101),imshow(I,[])
%     hold on;
%     plot(x1(:),y1(:),'y.');
    Flag = 1;
    %MergedSegment = 0;
    while(Flag == 1)
        m = 1;
        DistanceParam = zeros(1,length(segments));
        while (m <= length(segments))
            if m ~= n
                idx2 = segments{m};
                x2 = x(idx2);
                y2 = y(idx2);
%                 figure(101),
%                 plot(x2(:),y2(:),'r.');
                [minD, result] = CheckMergeDistance(x1, y1, x2, y2,I);
                if result == 3
                    DistanceParam(m) = minD;
                    m = m + 1;
                else
                    DistanceParam(m) = 999999999;
                    m = m + 1;
                end
            else
                 DistanceParam(m) = 999999999;
                m = m + 1;
            end           
        end
        [minDis DisIdx] = min(DistanceParam);
        
        if minDis == 999999999
            Flag = 0;
        else
          idx2 = segments{DisIdx};
          x2 = x(idx2);
          y2 = y(idx2);  
          MergeResult = CheckMergeConditionsNew(x1, y1, x2, y2, parameters,I);
          if MergeResult == 1
              MergedSegment = DisIdx;
              
            % merge two curve segments
            idx1 = [idx1 ; idx2]; %#ok
            segments{n} = idx1;
            segments(DisIdx) = '';
            if n > MergedSegment
                  n = n-1;
              end
            % start over merging
            m =  1;
            x1 = x(idx1);
            y1 = y(idx1);
%             figure(101),plot(x1(:),y1(:),'g.');
            Flag = 1;
          else
              Flag = 0;
          end
                         
        end
            
            
        
        
    end
    
    n = n + 1;
end

end



%% check merging distance
function [minD, result] = CheckMergeDistance(x1, y1, x2, y2,I)

max_checkpoints = 100;

% % determine which sides of the segments are closer 
d1 = (x1(1) - x2(1))^2 + (y1(1) - y2(1))^2;
d2 = (x1(1) - x2(end))^2 + (y1(1) - y2(end))^2;
d3 = (x1(end) - x2(1))^2 + (y1(end) - y2(1))^2;
d4 = (x1(end) - x2(end))^2 + (y1(end) - y2(end))^2;

[minD, result] = min([d1, d2, d3, d4]);
end

%% check merging conditions

function MergeResult = CheckMergeConditionsNew(x1, y1, x2, y2, parameters,I)

max_distance = parameters(1);
num_discardpts = parameters(2);
line_avglen = parameters(3);
slope_diff = parameters(4);

max_checkpoints = 100;

len1 = min(length(x1), max_checkpoints);
len2 = min(length(x2), max_checkpoints);

ex1 = x1(end-num_discardpts:-1:(end-len1+1)); ey1 = y1(end-num_discardpts:-1:(end-len1+1));
ex2 = x2(1:len2-num_discardpts); ey2 = y2(1:len2-num_discardpts);

% fit a line to the end of curve segments
linex1 = ex1(num_discardpts:min(end, num_discardpts+line_avglen));
liney1 = ey1(num_discardpts:min(end, num_discardpts+line_avglen));
linex2 = ex2(num_discardpts:min(end, num_discardpts+line_avglen));
liney2 = ey2(num_discardpts:min(end, num_discardpts+line_avglen));
[a1, b1, c1] = FitLine(linex1, liney1);
[a2, b2, c2] = FitLine(linex2, liney2);
% figure(230),imshow(I,[]);
% hold on;
% plot(linex1(:),liney1(:),'r.');
% plot(linex2(:),liney2(:),'r.');
slope = (a1*a2 + b1*b2);

% check distance from the fitted line to the other curve
Dis1 = median(abs(a1 * linex2 + b1 * liney2 + c1));
Dis2 = median(abs(a2 * linex1 + b2 * liney1 + c2));

if ((Dis1 <= max_distance) || Dis2 <= max_distance) & slope > slope_diff
    MergeResult = 1;
else
    MergeResult = 0;
    return
end
end

%% fit a line to input points
function [a, b, c] = FitLine(x, y)

mx = mean(x);
my = mean(y);
m0 = mean(x.^2) - mx^2;
m1 = mean(x.*y) - mx * my;
m2 = mean(y.^2) - my^2;

% find the eigenvector corresponding to the minimum eigenvalue.
% note that m0 > 0 and m2 > 0
lambda = ((m0+m2) - sqrt((m0-m2)^2 + 4 * m1^2)) / 2;
a = m1;
b = lambda - m0;
r = norm([a b]);
a = a / r;
b = b / r;
c = -a * mx - b * my;
end




