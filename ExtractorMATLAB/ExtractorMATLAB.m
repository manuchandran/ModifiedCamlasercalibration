function LaserOut   =  LaserExtractorWrapMATLAB(LaserIn)

Disp                = LaserIn.Disp;
sigma               = LaserIn.Sigma;
detection_thr       = LaserIn.MinStrength;

trace_parameters    = [LaserIn.ThrHigh LaserIn.SearchAngle*pi/180 LaserIn.MaxDistance LaserIn.DistanceWeight LaserIn.MaxCostFunction LaserIn.MinimumLength];
trace_parametersNew = [LaserIn.ThrHigh LaserIn.SearchAngle*pi/180 LaserIn.MaxDistance LaserIn.MinimumLength];
merge_parameters    = [LaserIn.MaxSegmentDistance LaserIn.NumberEndPtsDiscard LaserIn.AveragingWindowLen  LaserIn.MinSlopeDifference];

% 2- create filters
%filter_width        = round((sqrt(LaserIn.FilterWidth) * sigma));
filter_width        = round(LaserIn.FilterWidth * sqrt(LaserIn.FilterWidth) * sigma);

x                   = -filter_width:filter_width;
[g, gp, gpp]        = CreateFilters(x, sigma);



% % Input Image
I = LaserIn.Im;
I = double(I);

[Row,Col]   = size(I);


% 3- load mask
mask                            = true([Row Col]);
mask(1:filter_width, :)         = false; mask(:, 1:filter_width) = false;
mask((end-filter_width):end, :) = false; mask(:, (end-filter_width):end) = false;






% 2- Running curve detection, tracing and merging algorithm
[x, y, tx, ty, st]      = CurvilinearDetector(I, mask, g, gp, gpp, detection_thr);
% 
% figure(400),imshow(I, []); hold on;
% plot(x,y,'r.');

if ~isempty(x)
    
    curve_segments      = TraceCurvePoints(x, y, tx, ty, st, trace_parameters);
    
    
    % A slightly modified tracing algorithm (Can be used as an alternate in future)
    % curve_segmentsN = TraceCurvePointsNew(x, y, tx, ty, st, trace_parametersNew);
    
    %segments           = MergeCurveSegments(x, y, curve_segments, merge_parameters);
    segments           = MergeCurveSegmentsModified(x, y, curve_segments, merge_parameters,I);
    %segments            = MergeCurveSegmentsModified(x, y, segments1, merge_parameters,I);
    LaserOut.trace      = [];
    
    for k = 1:length(segments),
        idx = segments{k};
        %LaserOut.trace = [LaserOut.trace; x(idx) y(idx) tx(idx) ty(idx) st(idx)];
        LaserOut.trace  = [LaserOut.trace; x(idx) y(idx)];
        LaserOut.traceseg{k} = [(x(idx)),(y(idx))];
    end
else
    LaserOut.trace     = [];
end

if Disp
    if ~isempty(x)
        
        %3- Displaying results
        color = ['b.';'r.';'g.';'m.';'c.'];
        
        figure(100); imshow(I, []); hold on;
        for k = 1:length(curve_segments),
            idx = curve_segments{k};
            plot(x(idx)+1, y(idx)+1,color(mod(k,5)+1, :));% color(mod(k,5)+1, :))
            title('Traced Segments');
            
        end;
        
        
        figure(200); %imshow(I, []); 
        hold on;
        for k = 1:length(segments),
            idx = segments{k};
            %plot(x(idx)+1, y(idx)+1,color(mod(k,5)+1, :));
            plot(x(idx)+1, y(idx)+1,'r.');
            title('Merged Segments');
        end
    end
end
clearvars -except LaserOut
end
