"""
    upside_potential_ratio(returns, threshold; method=:partial)

The Upside Potential Ratio is a risk-adjusted performance measure similarly to the Sharpe Ratio and the Sortino Ratio. This ratio considers only upside returns (above `threshold`) in the numerator, and only downside returns (below `threshold`) in the denominator (see `downside_deviation`).

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Scalar value or vector denoting the threshold returns.
- `method`:      One of `:full` (default) or `:partial`. Indicates whether to use the number of all returns (`:full`), or only the number of returns above the threshold (`:partial`) in the denominator.

# Sources
- Plantinga, A., van der Meer, R. and Sortino, F. (2001). The Impact of Downside Risk on Risk-Adjusted Performance of Mutual Funds in the Euronext Markets.
"""
function upside_potential_ratio(returns, threshold; method::Symbol=:partial)
    if method == :full
        n = length(returns)
    elseif method == :partial
        n = count(returns .> threshold)
    else
        throw(ArgumentError("Passed method parameter '$(method)' is invalid, must be one of :full, :partial."))
    end

    dd = downside_deviation(returns, threshold; method=method)
    excess = returns .- threshold
    (sum(map(x -> max(0.0, x), excess)) / n) / dd
end
