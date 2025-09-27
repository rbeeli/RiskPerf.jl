@testitem "omega_ratio" setup = [TestData] begin
    @test omega_ratio(asset_returns, 0.001) ≈ 0.297008426326568
end
