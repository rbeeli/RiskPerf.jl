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

@testitem "value_at_risk type stability" begin
    using Test
    using RiskPerf

    returns32 = rand(Float32, 16)
    α32 = Float32(0.05)
    @test @inferred(value_at_risk(returns32, α32)) isa Float32
    @test @inferred(value_at_risk(returns32, α32; method=:gaussian)) isa Float32
    @test @inferred(value_at_risk(returns32, α32; method=:cornish_fisher)) isa Float32
    @test @inferred(value_at_risk(returns32, α32; multiplier=252)) isa Float32
    @test isnan(@inferred(value_at_risk(Float32[], α32)))

    returns_big = rand(BigFloat, 16)
    αbig = big(0.05)
    @test @inferred(value_at_risk(returns_big, αbig)) isa BigFloat
end
