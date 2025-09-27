@testitem "upside_downside_deviation" setup = [TestData] begin
    @test downside_deviation(asset_returns, 0.001; method=:full) ≈ 0.00102022195386797
    @test downside_deviation(asset_returns, rf; method=:full) ≈ 0.000474556578712896            # bug in R's PerformanceAnalytics, corrected here
    @test downside_deviation(asset_returns, 0.001; method=:partial) ≈ 0.00123267724486424
    @test downside_deviation(asset_returns, rf; method=:partial) ≈ 0.00085648312494845          # bug in R's PerformanceAnalytics, corrected here
end
