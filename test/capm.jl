@testitem "capm" setup = [TestData] begin
    α1, β1 = capm(asset_returns, market_returns)
    @test α1 ≈ 0.000512345109212185
    @test β1 ≈ 0.0370188032088717

    α2, β2 = capm(asset_returns, market_returns; risk_free=rf)
    @test α2 ≈ 0.000502715256287843
    @test β2 ≈ 0.037019963055605
end
