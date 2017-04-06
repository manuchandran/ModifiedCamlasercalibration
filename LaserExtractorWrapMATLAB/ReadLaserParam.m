function LaserIn = ReadLaserParam(LaserParam)

% Parameter Initialization
    LaserIn.Disp                 =  str2double(LaserParam.LaserExtractorParam.General.Disp.Text);
    LaserIn.Sigma                =  str2double(LaserParam.LaserExtractorParam.CurveDetection.Sigma.Text);
    LaserIn.MinStrength          =  str2double(LaserParam.LaserExtractorParam.CurveDetection.MinStrength.Text);
    LaserIn.FilterWidth          =  str2double(LaserParam.LaserExtractorParam.CurveDetection.FilterWidth.Text);
    LaserIn.Row                  =  str2double(LaserParam.LaserExtractorParam.CurveDetection.Row.Text);
    LaserIn.Col                  =  str2double(LaserParam.LaserExtractorParam.CurveDetection.Col.Text);
    LaserIn.ThrHigh              =  str2double(LaserParam.LaserExtractorParam.CurveTracing.ThrHigh.Text);
    LaserIn.MaxDistance          =  str2double(LaserParam.LaserExtractorParam.CurveTracing.MaxDistance.Text);
    LaserIn.SearchAngle          =  str2double(LaserParam.LaserExtractorParam.CurveTracing.SearchAngle.Text);
    LaserIn.DistanceWeight       =  str2double(LaserParam.LaserExtractorParam.CurveTracing.DistanceWeight.Text);
    LaserIn.MaxCostFunction      =  str2double(LaserParam.LaserExtractorParam.CurveTracing.MaxCostFunction.Text);
    LaserIn.MinimumLength        =  str2double(LaserParam.LaserExtractorParam.CurveTracing.MinimumLength.Text);
    LaserIn.MaxSegmentDistance   =  str2double(LaserParam.LaserExtractorParam.MergeTracedSegments.MaxSegmentDistance.Text);
    LaserIn.NumberEndPtsDiscard  =  str2double(LaserParam.LaserExtractorParam.MergeTracedSegments.NumberEndPtsDiscard.Text);
    LaserIn.AveragingWindowLen   =  str2double(LaserParam.LaserExtractorParam.MergeTracedSegments.AveragingWindowLen.Text);
    LaserIn.MaxDistance2Line     =  str2double(LaserParam.LaserExtractorParam.MergeTracedSegments.MaxDistance2Line.Text);
    LaserIn.MinSlopeDifference   =  str2double(LaserParam.LaserExtractorParam.MergeTracedSegments.MinSlopeDifference.Text);

end