"""
    volatility(returns; multiplier=1.0)

Calculates the volatility based on the standard deviation of the returns. The optional `multiplier` parameter allows for scaling the resulting volatility metric, i.e. for annualization.

# Formula

``\\sigma_{vol} = \\sigma(\\text{returns}) \\times \\sqrt{\\text{multiplier}}``

where ``\\sigma`` denotes the sample standard deviation.

# Arguments
- `returns`:    Vector of asset returns (usually log-returns).
- `multiplier`: Optional scalar multiplier, i.e. use `12` to annualize monthly returns, and use `252` to annualize daily returns.
"""
@inline volatility(returns; multiplier=1.0) = _standard_deviation(returns) * sqrt(multiplier)

# Sample (`corrected`) or population standard deviation: a compensated mean, then a plain
# sequential sum of squared deviations.
function _standard_deviation(values; corrected::Bool=true)
    T = float(eltype(values))
    n = length(values)
    (n == 0 || (corrected && n == 1)) && return T(NaN)
    μ = _compensated_mean(values, T)
    sum_squares = zero(T)
    for value in values
        difference = T(value) - μ
        sum_squares += difference * difference
    end
    return sqrt(sum_squares / T(corrected ? n - 1 : n))
end
