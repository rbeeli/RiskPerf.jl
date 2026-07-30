@testitem "moments" setup = [TestData] begin
    @test skewness(asset_returns) ≈ -0.0904045109144944
    @test skewness(asset_returns; method=:moment) ≈ -0.0904045109144944
    @test skewness(asset_returns; method=:fisher_pearson) ≈ -0.09054037810903758 # bug in R's PerformanceAnalytics, corrected here
    @test skewness(asset_returns; method=:sample) ≈ -0.0906763586376902

    @test kurtosis(asset_returns) ≈ 0.0619856901585289
    @test kurtosis(asset_returns; method=:excess) ≈ 0.0619856901585289
    @test kurtosis(asset_returns; method=:moment) ≈ 3.06198569015853
    @test kurtosis(asset_returns; method=:cornish_fisher) ≈ 0.06832082235970004

    @test lower_partial_moment(asset_returns, 0.001, 2, :full) ≈ 1.04085283515417e-06
    @test lower_partial_moment(asset_returns, rf, 2, :full) ≈ 2.25203946399689e-07
    @test lower_partial_moment(asset_returns, 0.001, 2, :partial) ≈ 1.51949319000609e-06
    @test lower_partial_moment(asset_returns, rf, 2, :partial) ≈ 7.33563343321463e-07

    @test higher_partial_moment(asset_returns, 0.001, 2, :full) ≈ 2.15200955473486e-07
    @test higher_partial_moment(asset_returns, rf, 2, :full) ≈ 1.0554005124107e-06
    @test higher_partial_moment(asset_returns, 0.001, 2, :partial) ≈ 6.83177636423766e-07
    @test higher_partial_moment(asset_returns, rf, 2, :partial) ≈ 1.5229444623531e-06

    data32 = Float32[-0.02, 0.01, 0.03, -0.04, 0.05]
    @test @inferred(skewness(data32)) isa Float32
    @test @inferred(kurtosis(data32)) isa Float32

    data_big = BigFloat[-0.02, 0.01, 0.03, -0.04, 0.05]
    @test @inferred(skewness(data_big)) isa BigFloat
    @test @inferred(kurtosis(data_big; method=:moment)) isa BigFloat
    @test isnan(@inferred(skewness(BigFloat[])))
    @test isnan(@inferred(kurtosis(BigFloat[])))
end

@testitem "Cornish-Fisher kurtosis is translation invariant" begin
    values = [-2.0, -1.0, 1.0, 2.0]
    translated_values = values .+ 100.0

    value_kurtosis = kurtosis(values; method=:cornish_fisher)
    translated_kurtosis = kurtosis(translated_values; method=:cornish_fisher)

    @test value_kurtosis ≈ -3.3
    @test translated_kurtosis ≈ value_kurtosis
end

@testitem "moment summary" begin
    values = [-2.0, -1.0, 1.0, 2.0]

    summary = @inferred RiskPerf.moment_summary(values)

    @test summary isa RiskPerf.MomentSummary{Float64}
    @test summary.mean == 0.0
    @test summary.variance == 2.5
    @test summary.third_moment == 0.0
    @test summary.fourth_moment == 8.5
    @test @inferred(RiskPerf.moment_standard_deviation(summary)) == sqrt(2.5)
    @test @inferred(RiskPerf.moment_skewness(summary)) == 0.0
    @test @inferred(RiskPerf.moment_excess_kurtosis(summary)) ≈ -1.64

    summary_mean(input) = RiskPerf.moment_summary(input).mean
    summary_mean(values)
    if VERSION >= v"1.12"
        @test @allocated(summary_mean(values)) == 0
    end

    empty_summary = @inferred RiskPerf.moment_summary(Float32[])
    @test empty_summary isa RiskPerf.MomentSummary{Float32}
    @test all(isnan, (
        empty_summary.mean,
        empty_summary.variance,
        empty_summary.third_moment,
        empty_summary.fourth_moment,
    ))
end

@testitem "moments zero-denominator" begin
    using Test
    using RiskPerf

    # Empty returns: denominator is zero for both methods
    empty_returns = Float64[]
    @test lower_partial_moment(empty_returns, 0.0, 2, :full) == 0.0
    @test lower_partial_moment(empty_returns, 0.0, 2, :partial) == 0.0
    @test higher_partial_moment(empty_returns, 0.0, 2, :full) == 0.0
    @test higher_partial_moment(empty_returns, 0.0, 2, :partial) == 0.0

    # No observations below threshold for LPM with :partial
    # All returns above threshold -> denominator = 0
    returns_above = [0.02, 0.01, 0.015]
    threshold_low = 0.005
    @test lower_partial_moment(returns_above, threshold_low, 2, :partial) == 0.0

    # No observations above threshold for HPM with :partial
    # All returns below or equal to threshold -> denominator = 0
    returns_below = [-0.01, -0.02, 0.0]
    threshold_zero = 0.0
    @test higher_partial_moment(returns_below, threshold_zero, 2, :partial) == 0.0
end

@testitem "kurtosis invalid method throws" setup = [TestData] begin
    @test_throws ArgumentError kurtosis(asset_returns; method=:invalid_method)
end
