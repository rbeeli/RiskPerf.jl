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
