@testitem "value_at_risk" setup = [TestData] begin
    @test value_at_risk(asset_returns, 0.05; method=:historical) ≈ -0.00115939244815142
    @test value_at_risk(asset_returns, 0.05; method=:gaussian) ≈ -0.00114638483011466
    @test value_at_risk(asset_returns, 0.05; method=:cornish_fisher) ≈ -0.00117095813580772
end

@testitem "value_at_risk annualisation consistency" setup = [TestData] begin
    α = 0.05
    m = 10.0
    μ = mean(asset_returns)

    for method in (:historical, :gaussian, :cornish_fisher)
        base = value_at_risk(asset_returns, α; method=method)
        scaled = value_at_risk(asset_returns, α; method=method, multiplier=m)
        expected = μ * m + sqrt(m) * (base - μ)
        @test scaled ≈ expected atol = 1e-12 rtol = 1e-6
    end
end
