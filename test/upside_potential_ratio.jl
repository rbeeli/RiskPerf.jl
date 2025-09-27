@testitem "upside_potential_ratio" setup = [TestData] begin
    @test upside_potential_ratio(asset_returns, 0.001; method=:full) ≈ 0.199853514985918        # bug in R's PerformanceAnalytics, corrected here
    @test upside_potential_ratio(asset_returns, rf; method=:full) ≈ 1.49034594998309            # bug in R's PerformanceAnalytics, corrected here
    @test upside_potential_ratio(asset_returns, 0.001; method=:partial) ≈ 0.525105446510415     # bug in R's PerformanceAnalytics, corrected here
    @test upside_potential_ratio(asset_returns, rf; method=:partial) ≈ 1.19157955999556         # bug in R's PerformanceAnalytics, corrected here
end
