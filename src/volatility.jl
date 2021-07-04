"""
    volatility(returns; multiplier=1.0)

Calculates the volatility based on the standard deviation of the returns. The optional `multiplier` parameter allows for scaling the resulting volatility metric, i.e. for annualization.

# Formula

    Vol = std(returns) * multiplier

# Arguments
- `returns`:    Vector of asset returns (usually log-returns).
- `multiplier`: Optional scalar multiplier, i.e. use `12` to annualize monthly returns, and use `252` to annualize daily returns.
"""
function volatility(returns; multiplier=1.0)
    std(returns) * sqrt(multiplier)
end
