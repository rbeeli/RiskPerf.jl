@testitem "simple_returns" begin
    using Test
    using RiskPerf

    prices = [100.0, 101.0, 102.0, 101.5]
    simple = simple_returns(prices; drop_first=true)
    expected_simple = [prices[i] / prices[i - 1] - 1 for i in 2:length(prices)]
    @test simple ≈ expected_simple

    prices_matrix = [100.0 50.0; 101.0 49.5; 99.0 48.5; 100.5 49.0]
    matrix_simple = simple_returns(prices_matrix; drop_first=true)
    expected_matrix = [
        prices_matrix[i, j] / prices_matrix[i - 1, j] - 1 for i in 2:size(prices_matrix, 1),
        j in 1:size(prices_matrix, 2)
    ]
    expected_matrix = reshape(expected_matrix, :, size(prices_matrix, 2))
    @test matrix_simple ≈ expected_matrix

    prices32 = Float32[100, 101, 102, 103, 104]
    @test @inferred(simple_returns(prices32)) isa Vector{Float32}
    @test isnan(simple_returns(prices32)[1])
    @test @inferred(simple_returns(prices32; drop_first=true)) isa Vector{Float32}
    @test simple_returns(prices32; first_value=Float32(1.2))[1] === Float32(1.2)

    ints = collect(1:5)
    res_int = simple_returns(ints)
    @test res_int isa Vector{Float64}
    @test res_int[2] == 1.0

    prices_matrix32 = Float32[100 50; 101 49.5; 99 48.5; 100.5 49]
    @test @inferred(simple_returns(prices_matrix32)) isa Matrix{Float32}
    @test @inferred(simple_returns(prices_matrix32; drop_first=true)) isa Matrix{Float32}
end

@testitem "log_returns" begin
    using Test
    using RiskPerf

    prices = [100.0, 101.0, 102.0, 101.5]
    log_simple = log_returns(prices; drop_first=true)
    expected_log = [log(prices[i] / prices[i - 1]) for i in 2:length(prices)]
    @test log_simple ≈ expected_log

    prices_matrix = [100.0 50.0; 101.0 49.5; 99.0 48.5; 100.5 49.0]
    matrix_log = log_returns(prices_matrix; drop_first=true)
    expected_matrix = [
        log(prices_matrix[i, j] / prices_matrix[i - 1, j]) for i in 2:size(prices_matrix, 1),
        j in 1:size(prices_matrix, 2)
    ]
    expected_matrix = reshape(expected_matrix, :, size(prices_matrix, 2))
    @test matrix_log ≈ expected_matrix
end

@testitem "total_return" begin
    using Test
    using RiskPerf

    prices = [100.0, 101.0, 102.0, 101.5]
    simple = simple_returns(prices; drop_first=true)
    log_simple = log_returns(prices; drop_first=true)

    @test total_return(simple) ≈ prices[end] / prices[1] - 1
    @test total_return(simple; method=:simple) ≈ prices[end] / prices[1] - 1
    @test total_return(log_simple; method=:log) ≈ prices[end] / prices[1] - 1
    @test exp(sum(log_simple)) - 1 ≈ total_return(simple)

    prices_matrix = [100.0 50.0; 101.0 49.5; 99.0 48.5; 100.5 49.0]
    matrix_simple = simple_returns(prices_matrix; drop_first=true)
    expected_totals = [
        prices_matrix[end, j] / prices_matrix[1, j] - 1 for j in 1:size(prices_matrix, 2)
    ]
    for j in axes(matrix_simple, 2)
        @test total_return(view(matrix_simple, :, j); method=:simple) ≈ expected_totals[j]
    end

    empty_returns = Float64[]
    @test total_return(empty_returns) == 0.0
    @test_throws ArgumentError total_return(simple; method=:foo)
end

@testitem "cagr" begin
    using Test
    using RiskPerf

    # Simple monthly returns over 3 years (36 periods)
    monthly_growth = 1.5 # Total growth 50%
    periods_per_year = 12
    n_years = 3
    n = periods_per_year * n_years
    monthly_r = fill(monthly_growth^(1 / n) - 1, n)
    # Direct formula
    expected = monthly_growth^(1 / n_years) - 1
    @test cagr(monthly_r; periods_per_year=periods_per_year) ≈ expected atol = 1e-12

    # Log returns variant
    log_r = log.(1 .+ monthly_r)
    @test cagr(log_r; periods_per_year=periods_per_year, method=:log) ≈ expected atol = 1e-12

    # Weekly example using simple returns
    weekly_growth = 2.0  # total double
    weeks_per_year = 52
    years = 2
    n2 = weeks_per_year * years
    weekly_r = fill(weekly_growth^(1 / n2) - 1, n2)
    expected2 = weekly_growth^(1 / years) - 1
    @test cagr(weekly_r; periods_per_year=weeks_per_year) ≈ expected2 atol = 1e-12

    # Empty input
    @test cagr(Float64[]; periods_per_year=12) == 0.0

    # Invalid method
    @test_throws ArgumentError cagr(monthly_r; periods_per_year=12, method=:foo)
end
