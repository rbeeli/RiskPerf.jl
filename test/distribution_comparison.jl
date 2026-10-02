@testitem "distribution comparison sums sequentially and leaves an empty active set undefined" begin
    config = DistributionComparisonConfig(252.0, 1.0e-6, [2], 50, 50, UInt64(7), 0.025, 0.975)
    reference = [0.01, -0.02, 0.015, 0.003, -0.004, 0.02]
    inactive = [0.0, 0.0, 0.0, 0.0]
    comparison = compare_return_distributions(reference, inactive, config)
    active_mean = only(filter(row -> row.metric == :active_mean_return_difference_bp, comparison.permutation_diagnostics))
    @test isnothing(active_mean.statistic) && isnothing(active_mean.p_value)
    @test comparison.comparison_active.observations == 0 && isnothing(comparison.comparison_active.mean_bp)
    wealth = foldl((wealth, value) -> wealth * (1.0 + value), reference; init=1.0)
    @test comparison.reference.total_return_pct == (wealth - 1.0) * 100.0
    mean = foldl(+, reference; init=0.0) / length(reference)
    @test comparison.reference.annualized_mean_pct == mean * 252.0 * 100.0
end

@testitem "distribution comparison is deterministic for a seed and validates its inputs" begin
    config = DistributionComparisonConfig(252.0, 1.0e-6, [1, 3], 40, 40, UInt64(11), 0.05, 0.95)
    reference = [0.01, -0.02, 0.015, 0.003, -0.004, 0.02, 0.0, 0.007]
    comparison = [0.002, -0.01, 0.004, 0.0, 0.006]
    first_run = compare_return_distributions(reference, comparison, config)
    second_run = compare_return_distributions(reference, comparison, config)
    @test [(band.lower, band.upper) for band in first_run.bootstrap_bands] ==
          [(band.lower, band.upper) for band in second_run.bootstrap_bands]
    @test length(first_run.bootstrap_bands) == 10
    @test all(row -> 0 < something(row.p_value) <= 1, first_run.permutation_diagnostics)
    @test_throws ArgumentError compare_return_distributions(reference, [0.0], config)
    @test_throws ArgumentError compare_return_distributions([0.0, 0.0], comparison, config)
    @test_throws ArgumentError DistributionComparisonConfig(252.0, -1.0, [1], 1, 1, UInt64(1), 0.05, 0.95)
    @test_throws ArgumentError DistributionComparisonConfig(252.0, 0.0, [1], 1, 1, UInt64(1), 0.6, 0.95)
end

@testitem "paired sign test counts ties and returns the exact two-sided p-value" begin
    result = paired_sign_test([1.0, 2.0, 3.0, 4.0, 5.0], [0.0, 1.0, 2.0, 4.0, 6.0])
    @test (result.paired_observations, result.positive_differences, result.negative_differences, result.ties) == (5, 3, 1, 1)
    @test result.p_value ≈ 0.625
    @test paired_sign_test([1.0], [1.0]).p_value == 1.0
    @test_throws ArgumentError paired_sign_test(Float64[], Float64[])
    @test_throws ArgumentError paired_sign_test([1.0], [1.0, 2.0])
end
