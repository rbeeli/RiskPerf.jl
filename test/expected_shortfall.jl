@testitem "expected_shortfall" setup = [TestData] begin
    @test expected_shortfall(asset_returns, 0.05; method=:historical) ≈ -0.00164648648602694
    @test expected_shortfall(asset_returns, 0.05; method=:gaussian) ≈ -0.00156905316259027
    @test expected_shortfall(asset_returns, 0.05; method=:cornish_fisher) ≈ -0.0016287316713825
end

@testitem "expected_shortfall annualisation consistency" setup = [TestData] begin
    α = 0.05
    m = 10.0
    μ = mean(asset_returns)

    for method in (:historical, :gaussian, :cornish_fisher)
        base = expected_shortfall(asset_returns, α; method=method)
        scaled = expected_shortfall(asset_returns, α; method=method, multiplier=m)
        expected = μ * m + sqrt(m) * (base - μ)
        @test scaled ≈ expected atol = 1e-12 rtol = 1e-6
    end
end

@testitem "expected_shortfall handles small tails" begin
    tiny_sample = [-0.01, 0.0, 0.02]
    α = 0.05

    @test expected_shortfall(tiny_sample, α; method=:historical) ≈ minimum(tiny_sample)
end
