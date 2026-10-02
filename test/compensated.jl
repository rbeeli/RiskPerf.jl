@testitem "compensated summation recovers cancelled terms and keeps non-finite results" begin
    @test RiskPerf._compensated_sum([1.0e16, 1.0, -1.0e16], Float64) == 1.0
    @test sum([1.0e16, 1.0, -1.0e16]) == 0.0
    @test RiskPerf._compensated_sum([1.0, Inf], Float64) == Inf
    @test isnan(RiskPerf._compensated_sum([Inf, -Inf], Float64))
    @test isnan(RiskPerf._compensated_sum([1.0, NaN], Float64))
    @test isnan(RiskPerf._compensated_mean(Float64[]))
    @test RiskPerf._compensated_mean(BigFloat[1, 2, 3]) isa BigFloat
end

@testitem "first-order statistics use compensated sums" begin
    values = [1.0e16, 1.0, -1.0e16, 1.0]
    @test RiskPerf.mean_excess(values, 0.0) == 0.5
    @test annualized_return(values, 4) == 2.0
    @test total_return([1.0e16, 1.0, -1.0e16]; method=:log) == expm1(1.0)
end
