@testitem "treynor_ratio" setup = [TestData] begin
    @test treynor_ratio(asset_returns, market_returns) ≈ 0.013976666292467
    @test treynor_ratio(asset_returns, market_returns; risk_free=rf) ≈ 0.0137061068404259
end
