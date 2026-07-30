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

@testitem "expected_shortfall selects the historical tail" begin
    returns = [9.0, 1.0, 5.0, 3.0, 3.0, 7.0]

    @test expected_shortfall(returns, 0.5; method=:historical) == 7.0 / 3.0
    @test expected_shortfall(returns, 0.99; method=:historical) == 14.0 / 3.0
end

@testitem "expected_shortfall type stability" begin
    using Test
    using RiskPerf

    returns32 = rand(Float32, 16)
    α32 = Float32(0.05)
    @test @inferred(expected_shortfall(returns32, α32)) isa Float32
    @test @inferred(expected_shortfall(returns32, α32; method=:gaussian)) isa Float32
    @test @inferred(expected_shortfall(returns32, α32; method=:cornish_fisher)) isa Float32
    @test @inferred(expected_shortfall(returns32, α32; multiplier=252)) isa Float32
    @test isnan(@inferred(expected_shortfall(Float32[], α32)))

    cornish_fisher_es(values, probability) =
        expected_shortfall(values, probability; method=:cornish_fisher)
    cornish_fisher_es(returns32, α32)
    if VERSION >= v"1.12"
        @test @allocated(cornish_fisher_es(returns32, α32)) == 0
    end

    returns_big = rand(BigFloat, 16)
    αbig = big(0.05)
    @test @inferred(expected_shortfall(returns_big, αbig)) isa BigFloat
end
