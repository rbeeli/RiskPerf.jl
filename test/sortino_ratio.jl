@testitem "sortino_ratio" setup = [TestData] begin
    @test sortino_ratio(asset_returns) ≈ 1.10000435875069
    @test sortino_ratio(asset_returns; MAR=rf) ≈ 1.0692077438794
end
