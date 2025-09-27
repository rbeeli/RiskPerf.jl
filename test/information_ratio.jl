@testitem "information_ratio" setup = [TestData] begin
    @test information_ratio(asset_returns, market_returns) ≈ 0.34034622188359
end
