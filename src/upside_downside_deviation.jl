"""
    downside_deviation(returns, threshold; method=:full)

Calculates the downside deviation, also called semi-standard deviation, which captures the downside risk.

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Scalar value or vector denoting the threshold returns.
- `method`:      One of `:full` (default) or `:partial`. Indicates whether to use the number of all returns (`:full`), or only the number of returns below the threshold (`:partial`) in the denominator.

# Formula

``\\text{Downside Deviation} = \\sqrt{\\text{Lower Partial Moment}}``

"""
function downside_deviation(returns, threshold; method::Symbol=:full)
    sqrt(lower_partial_moment(returns, threshold, 2, method))
end

"""
    upside_deviation(returns, threshold; method=:full)

Calculates the upside deviation, also called semi-standard deviation, which captures the upside "risk".

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Scalar value or vector denoting the threshold returns.
- `method`:      One of `:full` (default) or `:partial`. Indicates whether to use the number of all returns (`:full`), or only the number of returns above the threshold (`:partial`) in the denominator.

# Formula

``\\text{Upside Deviation} = \\sqrt{\\text{Higher Partial Moment}}``
"""
function upside_deviation(returns, threshold; method::Symbol=:full)
    sqrt(higher_partial_moment(returns, threshold, 2, method))
end
