# Distribution comparison of a return sample against a reference sample.

"""
    DistributionComparisonConfig(periods_per_year, active_threshold, block_lengths,
        bootstrap_samples, permutation_samples, seed, lower_quantile, upper_quantile)

Validated settings of [`compare_return_distributions`](@ref). `active_threshold` is the
absolute return above which an observation counts as active; `seed` makes the circular-block
bootstrap and random-label draws deterministic.
"""
struct DistributionComparisonConfig
    periods_per_year::Float64
    active_threshold::Float64
    block_lengths::Vector{Int}
    bootstrap_samples::Int
    permutation_samples::Int
    seed::UInt64
    lower_quantile::Float64
    upper_quantile::Float64

    function DistributionComparisonConfig(periods_per_year, active_threshold, block_lengths, bootstrap_samples,
        permutation_samples, seed, lower_quantile, upper_quantile)
        isfinite(periods_per_year) && periods_per_year > 0 || throw(ArgumentError("periods_per_year must be positive and finite."))
        isfinite(active_threshold) && active_threshold >= 0 || throw(ArgumentError("active_threshold must be nonnegative and finite."))
        !isempty(block_lengths) && all(>(0), block_lengths) || throw(ArgumentError("block_lengths must be nonempty and positive."))
        bootstrap_samples > 0 && permutation_samples > 0 || throw(ArgumentError("Bootstrap and permutation samples must be positive."))
        0 < lower_quantile < 0.5 < upper_quantile < 1 || throw(ArgumentError("Comparison quantiles must satisfy 0 < lower < 0.5 < upper < 1."))
        return new(Float64(periods_per_year), Float64(active_threshold), collect(Int, block_lengths), Int(bootstrap_samples),
            Int(permutation_samples), UInt64(seed), Float64(lower_quantile), Float64(upper_quantile))
    end
end

struct ReturnDistributionSummary
    observations::Int
    total_return_pct::Float64
    annualized_mean_pct::Float64
    volatility_pct::Float64
    sharpe::Union{Nothing,Float64}
    maximum_drawdown_pct::Float64
    active_observations_pct::Float64
    q01_pct::Float64
    q05_pct::Float64
    median_pct::Float64
    q95_pct::Float64
    q99_pct::Float64
    worst_pct::Float64
    best_pct::Float64
end

const BOOTSTRAP_METRICS = (:total_return_pct, :sharpe, :maximum_drawdown_pct, :volatility_pct, :active_observations_pct)
const TWO_SAMPLE_METRICS = (:mean_return_difference_bp, :active_mean_return_difference_bp, :volatility_difference_bp,
    :active_rate_difference_pct_points, :kolmogorov_smirnov)

struct BootstrapBand
    block_length::Int
    metric::Symbol
    comparison_value::Union{Nothing,Float64}
    lower::Union{Nothing,Float64}
    median::Union{Nothing,Float64}
    upper::Union{Nothing,Float64}
    comparison_percentile::Union{Nothing,Float64}
end

struct PermutationDiagnostic
    metric::Symbol
    statistic::Union{Nothing,Float64}
    p_value::Union{Nothing,Float64}
end

struct ActiveReturnSummary
    observations::Int
    mean_bp::Union{Nothing,Float64}
    volatility_bp::Union{Nothing,Float64}
    q05_bp::Union{Nothing,Float64}
    median_bp::Union{Nothing,Float64}
    q95_bp::Union{Nothing,Float64}
    worst_bp::Union{Nothing,Float64}
    best_bp::Union{Nothing,Float64}
end

struct DistributionComparison
    reference::ReturnDistributionSummary
    comparison::ReturnDistributionSummary
    bootstrap_bands::Vector{BootstrapBand}
    permutation_diagnostics::Vector{PermutationDiagnostic}
    reference_active::ActiveReturnSummary
    comparison_active::ActiveReturnSummary
end

function _quantile_sorted(sorted::AbstractVector{Float64}, probability::Float64)::Float64
    index = (length(sorted) - 1) * probability
    lower, upper = floor(Int, index), ceil(Int, index)
    weight = index - lower
    return sorted[lower + 1] * (1 - weight) + sorted[upper + 1] * weight
end

# Sums are sequential left folds so non-random summaries are reproducible across implementations.
_mean(values) = foldl(+, values; init=0.0) / length(values)
_finite_or_nothing(value) = isfinite(value) ? value : nothing

function _sample_standard_deviation(values)
    length(values) < 2 && return nothing
    mean = _mean(values)
    return _finite_or_nothing(sqrt(foldl((sum, value) -> sum + (value - mean)^2, values; init=0.0) / (length(values) - 1)))
end

_compound_return(returns) = foldl((wealth, value) -> wealth * (1.0 + value), returns; init=1.0) - 1.0

function _maximum_drawdown_magnitude(returns)
    wealth, peak, maximum = 1.0, 1.0, 0.0
    for value in returns
        wealth *= 1.0 + value
        peak = max(peak, wealth)
        maximum = max(maximum, 1.0 - wealth / peak)
    end
    return maximum
end

_active_rate(returns, threshold) = count(value -> abs(value) > threshold, returns) / length(returns)

function _active_mean(returns, threshold)
    sum, count = 0.0, 0
    for value in returns
        if abs(value) > threshold
            sum += value
            count += 1
        end
    end
    return count > 0 ? sum / count : nothing
end

function _summarize_returns(returns, config::DistributionComparisonConfig)
    mean = _mean(returns)
    volatility = something(_sample_standard_deviation(returns), 0.0)
    sorted = sort(returns)
    return ReturnDistributionSummary(length(returns), _compound_return(returns) * 100.0,
        mean * config.periods_per_year * 100.0, volatility * sqrt(config.periods_per_year) * 100.0,
        volatility > 0 ? mean / volatility * sqrt(config.periods_per_year) : nothing,
        _maximum_drawdown_magnitude(returns) * 100.0, _active_rate(returns, config.active_threshold) * 100.0,
        _quantile_sorted(sorted, 0.01) * 100.0, _quantile_sorted(sorted, 0.05) * 100.0, _quantile_sorted(sorted, 0.5) * 100.0,
        _quantile_sorted(sorted, 0.95) * 100.0, _quantile_sorted(sorted, 0.99) * 100.0, first(sorted) * 100.0, last(sorted) * 100.0)
end

function _path_metric(metric::Symbol, returns, config::DistributionComparisonConfig)
    metric == :total_return_pct && return _finite_or_nothing(_compound_return(returns) * 100.0)
    if metric == :sharpe
        volatility = _sample_standard_deviation(returns)
        return isnothing(volatility) || volatility <= 0 ? nothing : _mean(returns) / volatility * sqrt(config.periods_per_year)
    end
    metric == :maximum_drawdown_pct && return _finite_or_nothing(_maximum_drawdown_magnitude(returns) * 100.0)
    if metric == :volatility_pct
        volatility = _sample_standard_deviation(returns)
        return isnothing(volatility) ? nothing : _finite_or_nothing(volatility * sqrt(config.periods_per_year) * 100.0)
    end
    return _finite_or_nothing(_active_rate(returns, config.active_threshold) * 100.0)
end

function _two_sample_statistic(metric::Symbol, reference, comparison, threshold)
    metric == :mean_return_difference_bp && return _finite_or_nothing((_mean(comparison) - _mean(reference)) * 10_000.0)
    if metric == :active_mean_return_difference_bp
        left, right = _active_mean(comparison, threshold), _active_mean(reference, threshold)
        return isnothing(left) || isnothing(right) ? nothing : (left - right) * 10_000.0
    elseif metric == :volatility_difference_bp
        left, right = _sample_standard_deviation(comparison), _sample_standard_deviation(reference)
        return isnothing(left) || isnothing(right) ? nothing : (left - right) * 10_000.0
    elseif metric == :active_rate_difference_pct_points
        return _finite_or_nothing((_active_rate(comparison, threshold) - _active_rate(reference, threshold)) * 100.0)
    end
    return _finite_or_nothing(_kolmogorov_smirnov(reference, comparison))
end

function _kolmogorov_smirnov(left, right)
    left, right = sort(left), sort(right)
    i = j = 0
    maximum = 0.0
    while i < length(left) || j < length(right)
        value = j == length(right) || (i < length(left) && left[i + 1] <= right[j + 1]) ? left[i + 1] : right[j + 1]
        while i < length(left) && left[i + 1] <= value
            i += 1
        end
        while j < length(right) && right[j + 1] <= value
            j += 1
        end
        maximum = max(maximum, abs(i / length(left) - j / length(right)))
    end
    return maximum
end

function _active_summary(returns, threshold)
    active = sort([value for value in returns if abs(value) > threshold])
    isempty(active) && return ActiveReturnSummary(0, ntuple(_ -> nothing, 7)...)
    volatility = _sample_standard_deviation(active)
    return ActiveReturnSummary(length(active), _finite_or_nothing(_mean(active) * 10_000.0),
        isnothing(volatility) ? nothing : volatility * 10_000.0, _quantile_sorted(active, 0.05) * 10_000.0,
        _quantile_sorted(active, 0.5) * 10_000.0, _quantile_sorted(active, 0.95) * 10_000.0, first(active) * 10_000.0,
        last(active) * 10_000.0)
end

function _validate_comparison_returns(operation::AbstractString, returns)
    length(returns) >= 2 || throw(ArgumentError("$(operation) requires at least 2 observations; received $(length(returns))."))
    for (index, value) in pairs(returns)
        isfinite(value) && value > -1.0 || throw(ArgumentError("$(operation) observation $(index) is invalid: $(value)."))
    end
    return nothing
end

"""
    compare_return_distributions(reference, comparison, config)

Compare a comparison return sample with a reference sample: summaries of both samples,
circular-block bootstrap bands of path metrics resampled from the reference, random-label
two-sample diagnostics (comparison minus reference), and active-return summaries.

Seeded draws are deterministic within this package but are not bit-compatible with other
implementations' random number generators.
"""
function compare_return_distributions(reference::AbstractVector{Float64}, comparison::AbstractVector{Float64},
    config::DistributionComparisonConfig)::DistributionComparison
    _validate_comparison_returns("Comparison reference", reference)
    _validate_comparison_returns("Comparison sample", comparison)
    for block_length in config.block_lengths
        block_length <= length(reference) ||
            throw(ArgumentError("Block length $(block_length) exceeds the reference sample of $(length(reference))."))
    end
    bands = BootstrapBand[]
    sample = zeros(length(comparison))
    for block_length in config.block_lengths
        rng = Xoshiro(config.seed + UInt64(block_length))
        simulated = [Float64[] for _ in BOOTSTRAP_METRICS]
        for _ in 1:config.bootstrap_samples
            index = 1
            while index <= length(sample)
                start = rand(rng, 0:(length(reference) - 1))
                for offset in 0:(block_length - 1)
                    index > length(sample) && break
                    sample[index] = reference[mod(start + offset, length(reference)) + 1]
                    index += 1
                end
            end
            for (position, metric) in pairs(BOOTSTRAP_METRICS)
                value = _path_metric(metric, sample, config)
                isnothing(value) || push!(simulated[position], value)
            end
        end
        for (position, metric) in pairs(BOOTSTRAP_METRICS)
            values = sort!(simulated[position])
            observed = _path_metric(metric, comparison, config)
            band_quantile(probability) = isempty(values) ? nothing : _quantile_sorted(values, probability)
            percentile = isnothing(observed) || isempty(values) ? nothing :
                searchsortedlast(values, observed) / length(values) * 100.0
            push!(bands, BootstrapBand(block_length, metric, observed, band_quantile(config.lower_quantile), band_quantile(0.5),
                band_quantile(config.upper_quantile), percentile))
        end
    end
    observed = [_two_sample_statistic(metric, reference, comparison, config.active_threshold) for metric in TWO_SAMPLE_METRICS]
    exceedances = zeros(Int, length(TWO_SAMPLE_METRICS))
    shuffled = vcat(reference, comparison)
    rng = Xoshiro(config.seed + UInt64(101))
    for _ in 1:config.permutation_samples
        shuffle!(rng, shuffled)
        permuted_reference, permuted_comparison = view(shuffled, 1:length(reference)), view(shuffled, (length(reference) + 1):length(shuffled))
        for (position, metric) in pairs(TWO_SAMPLE_METRICS)
            isnothing(observed[position]) && continue
            value = _two_sample_statistic(metric, permuted_reference, permuted_comparison, config.active_threshold)
            !isnothing(value) && abs(value) >= abs(something(observed[position])) && (exceedances[position] += 1)
        end
    end
    diagnostics = [PermutationDiagnostic(metric, observed[position],
        isnothing(observed[position]) ? nothing : (exceedances[position] + 1) / (config.permutation_samples + 1))
        for (position, metric) in pairs(TWO_SAMPLE_METRICS)]
    return DistributionComparison(_summarize_returns(reference, config), _summarize_returns(comparison, config), bands,
        diagnostics, _active_summary(reference, config.active_threshold), _active_summary(comparison, config.active_threshold))
end

"""
    PairedSignTestResult

Counts of paired sign differences with the exact two-sided binomial p-value under equal sign
probability.
"""
struct PairedSignTestResult
    paired_observations::Int
    positive_differences::Int
    negative_differences::Int
    ties::Int
    p_value::Float64
end

"""
    paired_sign_test(left, right)

Exact two-sided sign test of `left - right` pairs. Ties are counted and excluded from the trials.
"""
function paired_sign_test(left::AbstractVector{<:Real}, right::AbstractVector{<:Real})::PairedSignTestResult
    isempty(left) && throw(ArgumentError("paired_sign_test requires at least one pair."))
    length(left) == length(right) || throw(ArgumentError("paired_sign_test inputs have lengths $(length(left)) and $(length(right))."))
    positive = negative = ties = 0
    for (index, (left_value, right_value)) in enumerate(zip(left, right))
        isfinite(left_value) && isfinite(right_value) || throw(ArgumentError("paired_sign_test value at index $(index - 1) is not finite."))
        left_value == right_value ? (ties += 1) : left_value > right_value ? (positive += 1) : (negative += 1)
    end
    trials = positive + negative
    p_value = if trials == 0
        1.0
    else
        successes = max(positive, negative)
        upper_tail = sum(binomial(big(trials), k) for k in successes:trials) / big(2)^trials
        min(2.0 * Float64(upper_tail), 1.0)
    end
    return PairedSignTestResult(length(left), positive, negative, ties, p_value)
end

