@testitem "calmar_ratio" begin
    using Test
    using RiskPerf

    returns = [0.1, -0.05, 0.02, -0.01, 0.03]
    expected = cagr(returns, 12) / max_drawdown_pct(returns)
    @test calmar_ratio(returns, 12) ≈ expected atol = 1e-12

    expected_linear = cagr(returns, 12) / max_drawdown_pct(returns; compound=false)
    @test calmar_ratio(returns, 12; compound=false) ≈ expected_linear atol = 1e-12

    declines = fill(-0.01, 12)
    @test calmar_ratio(declines, 12) ≈ cagr(declines, 12) / max_drawdown_pct(declines) atol = 1e-12

    flat = zeros(12)
    @test calmar_ratio(flat, 12) == 0.0

    monotonic = fill(0.01, 12)
    @test calmar_ratio(monotonic, 12) == Inf

    @test calmar_ratio(Float64[], 12) == 0.0
    @test_throws ArgumentError calmar_ratio(returns, 0)
end
