@testitem "tracking_error" setup = [TestData] begin
    @test tracking_error(asset_returns, market_returns) ≈ 0.00111905105002574
end
