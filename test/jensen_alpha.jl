@testitem "jensen_alpha" setup = [TestData] begin
    α2, β2 = capm(asset_returns, market_returns; risk_free=rf)

    γ = jensen_alpha(asset_returns, market_returns; risk_free=rf)
    @test γ ≈ α2

    γ = modified_jensen(asset_returns, market_returns; risk_free=rf)
    @test γ ≈ α2 / β2
end
