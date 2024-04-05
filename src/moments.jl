"""
    skewness(x; method=:moment)

Calculates the skewness using the specified method.

# Methods
- Moment (default)
- Fisher-Pearson
- Sample

# Arguments
- `x`:          Vector of values.
- `method`:     Estimation method: `:moment`, `:fisher_pearson` or `:sample`.
"""
function skewness(x; method::Symbol=:moment)
    n = length(x)
    mean_devs = x .- mean(x)

    if method == :moment
        # Moment
        return mean(mean_devs.^3) / sqrt(mean(mean_devs.^2))^3  # sqrt(x)^3 faster than x^1.5 !
    elseif method == :fisher_pearson
        # Fisher-Pearson
        if n > 2
            return sqrt(n*(n-1))/(n-2) * mean(mean_devs.^3) / sqrt(mean(mean_devs.^2))^3  # sqrt(x)^3 faster than x^1.5 !
        else
            return NaN
        end
    elseif method == :sample
        # Sample
        return n/((n-1)*(n-2)) * sum(mean_devs.^3 / sqrt(mean(mean_devs.^2))^3)
    end

    throw(ArgumentError("Passed method parameter '$(method)' is invalid, must be one of :moment, :fisher_pearson, :sample."))
end

"""
    kurtosis(x; method=:excess)

Calculates the kurtosis using on the specified method.

# Methods
- Excess (default)
- Moment
- Cornish-Fisher

# Arguments
- `x`:          Vector of values.
- `method`:     Estimation method: `:excess`, `:moment` or `:cornish_fisher`.
"""
function kurtosis(x; method::Symbol=:excess)
    n = length(x)
    mean_devs = x .- mean(x)

    if method == :excess
        # Excess
        return sum(mean_devs.^4 / mean(mean_devs.^2)^2 ) / n - 3
    elseif method == :moment
        # Moment
        return sum(mean_devs.^4 / mean(mean_devs.^2)^2 ) / n
    elseif method == :cornish_fisher
        # Cornish-Fisher
        return ((n+1)*(n-1)*((sum(x.^4)/n)/(sum(x.^2)/n)^2 -
            (3*(n-1))/(n+1)))/((n-2)*(n-3))
    end

    throw(ArgumentError("Passed method parameter '$(method)' is invalid, must be one of :excess, :moment, :cornish_fisher."))
end

"""
    lower_partial_moment(returns, threshold, n, method)

This function calculates the Lower Partial Moment (LPM) for a given threshold.

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Scalar value or vector denoting the threshold returns.
- `n`:           `n`-th moment to calculate.
- `method`:      One of `:full` or `:partial`. Indicates whether to use the number of all returns (`:full`), or only the number of returns below the threshold (`:partial`) in the denominator.

# Formula
    
``\\text{LPM}_n = \\frac{1}{D} \\sum_{i=1}^N \\max(0, \\text{threshold} - \\text{returns}_i)^n``

where `N` is the number of returns, and `D` is the denominator.
"""
function lower_partial_moment(returns, threshold, n, method::Symbol)
    if method == :full
        denominator = length(returns)
    elseif method == :partial
        denominator = count(returns .< threshold)
    else
        throw(ArgumentError("Passed method parameter '$(method)' is invalid, must be one of :full, :partial."))
    end
    excess = threshold .- returns
    sum(map(x -> max(0.0, x)^n, excess)) / denominator
end

"""
    higher_partial_moment(returns, threshold, n, method)

This function calculates the Higher Partial Moment (HPM) for a given threshold.

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Scalar value or vector denoting the threshold returns.
- `n`:           `n`-th moment to calculate.
- `method`:      One of `:full` or `:partial`. Indicates whether to use the number of all returns (`:full`), or only the number of returns above the threshold (`:partial`) in the denominator.

# Formula

``\\text{HPM}_n = \\frac{1}{D} \\sum_{i=1}^N \\max(0, \\text{returns}_i - \\text{threshold})^n``

where `N` is the number of returns, and `D` is the denominator.
"""
function higher_partial_moment(returns, threshold, n, method::Symbol)
    if method == :full
        denominator = length(returns)
    elseif method == :partial
        denominator = count(returns .> threshold)
    else
        throw(ArgumentError("Passed method parameter '$(method)' is invalid, must be one of :full, :partial."))
    end
    excess = returns .- threshold
    sum(map(x -> max(0.0, x)^n, excess)) / denominator
end
