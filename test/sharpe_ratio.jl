@testitem "sharpe_ratio" setup = [TestData] begin
    @test sharpe_ratio(asset_returns) ≈ 0.511256629034303
    @test sharpe_ratio(asset_returns; risk_free=rf) ≈ 0.501375462696111
    @test adjusted_sharpe_ratio(asset_returns) ≈ 0.5069731154546914  # slightly different to R's PerformanceAnalytics due to their annualization (0.506476646827294)
end
