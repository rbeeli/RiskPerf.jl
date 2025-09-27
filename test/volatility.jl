@testitem "volatility" setup = [TestData] begin
    @test std(rf) ≈ 1.03135983021606e-07

    @test volatility(asset_returns) ≈ 0.0010120151595378
end
