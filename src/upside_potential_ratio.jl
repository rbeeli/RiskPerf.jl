"""
    upside_potential_ratio(returns, threshold; method=:partial)

The Upside Potential Ratio is a risk-adjusted performance measure similarly
to the Sharpe Ratio and the Sortino Ratio.
This ratio considers only upside returns (above `threshold`) in the numerator,
and only downside returns (below `threshold`) in the denominator (see `downside_deviation`).

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Scalar value or vector denoting the threshold returns.
- `method`:      One of `:full` or `:partial` (default = `:partial`).
                 Indicates whether to use the number of all returns (`:full`), or only
                 the number of returns above the threshold (`:partial`) in the denominator.

# Sources
- Plantinga, A., van der Meer, R. and Sortino, F. (2001). The Impact of Downside Risk on
    Risk-Adjusted Performance of Mutual Funds in the Euronext Markets.
"""
@inline function upside_potential_ratio(returns::AbstractVector, threshold::Real; method::Symbol=:partial)
    num = higher_partial_moment(returns, threshold, 1, method)
    dd = downside_deviation(returns, threshold; method=method)
    num / dd
end

@inline function upside_potential_ratio(returns::AbstractVector, threshold::AbstractVector; method::Symbol=:partial)
    num = higher_partial_moment(returns, threshold, 1, method)
    dd = downside_deviation(returns, threshold; method=method)
    num / dd
end
