function curve_segments = TraceCurvePoints(x, y, tx, ty, st, parameters)
% curve_segments = TraceCurvePoints(x, y, tx, ty, st, parameters)
% Inputs:
% (x, y, tx, ty, st): inputs from the 'CurvilinearDetector' function.
% parameters: a vector of the parameters
%   parameters = [st_thr alpha max_distance weight_dist cost_thr min_len]
%   st_thr : minimum strength of the starting point
%   alpha  : maximum curvature of the trace
%   max_distance : maximum L1 distance between consecutive points
%   weight_dist  : weight of distance in the cost function
%   cost_thr     : maximum acceptable cost for tracing
%   min_len      : minimum length of curve segment
% Output: 
% curve_segments : a cell array, containing indices of the curve points

st_thr = parameters(1);      % minimum strength of the starting point
alpha = parameters(2);       % maximum curvature of the trace
max_distance = parameters(3);% maximum L1 distance between consecutive points
weight_dist = parameters(4); % weight of distance in the cost function
cost_thr = parameters(5);    % maximum acceptable cost for tracing
min_len = parameters(6);     % minimum length of curve segment

not_traced = true(size(x));  % keep track of points that are not traced yet
direction_thr = cos(alpha);

% memory initialization
traced_segment = zeros(5000,1);
curve_segments = cell(250, 1);

segment_number = 0;
while(segment_number < 250)
    
    [max_st, idx] = max(st);
    start_idx = idx(1);
    if (max_st < st_thr)
        break;
    end;
    
    traced_num = 1;
    traced_segment(traced_num) = start_idx;
    not_traced(start_idx) = false;
    st(start_idx) = 0;

    % tracing in the positive direction
    xcur = x(start_idx); ycur = y(start_idx);
    txcur = tx(start_idx); tycur = ty(start_idx);
    direction = 1;
    while (1)
        % find points that are close enough to the last traced point
        dx = x - xcur;
        dy = y - ycur;
        candid_idx = find((abs(dx) < max_distance) & (abs(dy) < max_distance) & not_traced);
        if isempty(candid_idx),
            break;
        end;
        
        dx = dx(candid_idx);
        dy = dy(candid_idx);
        
        % if direction = 1, the following quantity should be positive,
        % otherwise, it should be negative
        direction_check = (txcur * dx + tycur * dy) * direction;
        idx = find(direction_check > direction_thr);
        if isempty(idx),
            break;
        end;
        
        candid_idx = candid_idx(idx);
        
        % compute the cost function for the candid points
        dist = sqrt(dx(idx).^2 + dy(idx).^2);
        dt = abs(txcur * tx(candid_idx) + tycur * ty(candid_idx));
        dt = acos(min(dt, 0.9999));
        cost = weight_dist * dist + dt;
        
        % find the point with the minimum cost function
        [minvalue, min_idx] = min(cost);
        if (minvalue > cost_thr)
            break;
        end;
        
        new_idx = candid_idx(min_idx);
        
        % update direction of tracing
        direction_check = tx(new_idx) * (xcur - x(new_idx)) + ty(new_idx) * (ycur - y(new_idx));
        if (direction_check > 0),
            direction = -1;
        else
            direction = 1;
        end;
        
        % add new point to the traced seqment
        traced_num = traced_num + 1;
        traced_segment(traced_num) = new_idx;
        not_traced(new_idx) = false;
        st(new_idx) = 0;
        
        % update current points
        xcur = x(new_idx); ycur = y(new_idx);
        txcur = tx(new_idx); tycur = ty(new_idx);
    end;
    
    traced_segment(1:traced_num) = traced_segment(traced_num:-1:1);
    
    % tracing in the negative direction
    xcur = x(start_idx); ycur = y(start_idx);
    txcur = tx(start_idx); tycur = ty(start_idx);
    direction = -1;
    while (1)
        % find points that are close enough to the last traced point
        dx = x - xcur;
        dy = y - ycur;
        candid_idx = find((abs(dx) < max_distance) & (abs(dy) < max_distance) & not_traced);
        if isempty(candid_idx),
            break;
        end;
        
        dx = dx(candid_idx);
        dy = dy(candid_idx);
        
        % if direction = 1, the following quantity should be positive,
        % otherwise, it should be negative
        direction_check = (txcur * dx + tycur * dy) * direction;
        idx = find(direction_check > direction_thr);
        if isempty(idx),
            break;
        end;
        
        candid_idx = candid_idx(idx);
        
        % compute the cost function for the candid points
        dist = sqrt(dx(idx).^2 + dy(idx).^2);
        dt = abs(txcur * tx(candid_idx) + tycur * ty(candid_idx));
        dt = acos(min(dt, 0.9999));
        cost = weight_dist * dist + dt;
        
        % find the point with the minimum cost function
        [minvalue, min_idx] = min(cost);
        if (minvalue > cost_thr)
            break;
        end;
        
        new_idx = candid_idx(min_idx);
        
        % update direction of tracing
        direction_check = tx(new_idx) * (xcur - x(new_idx)) + ty(new_idx) * (ycur - y(new_idx));
        if (direction_check > 0),
            direction = -1;
        else
            direction = 1;
        end;
         
        % add new point to the traced seqment
        traced_num = traced_num + 1;
        traced_segment(traced_num) = new_idx;
        not_traced(new_idx) = false;
        st(new_idx) = 0;
        
        % update current points
        xcur = x(new_idx); ycur = y(new_idx);
        txcur = tx(new_idx); tycur = ty(new_idx);
   end;
    

    if (traced_num >= min_len)
        segment_number = segment_number + 1;
        curve_segments(segment_number) = {traced_segment(1:traced_num)};
    end;
end;

curve_segments = curve_segments(1:segment_number);

clearvars -except curve_segments
end