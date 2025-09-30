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
@inline volatility(returns; multiplier=1.0) = std(returns) * sqrt(multiplier)
