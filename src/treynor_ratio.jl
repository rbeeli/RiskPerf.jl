"""
    treynor_ratio(asset_returns, benchmark_returns; multiplier=1.0, risk_free=0.0)

Calculates the Treynor ratio as the ratio of excess return divided by the CAPM beta. This ratio is similar to the Sharpe Ratio, but instead of dividing by the volatility, we devide by the CAPM beta as risk proxy.

# Formula

    TR = E[asset_returns - risk_free] / beta * multiplier

# Arguments
- `asset_returns`:      Vector of asset returns.
- `benchmark_returns`:  Vector of benchmark returns (e.g. market portfolio returns).
- `multiplier`:         Optional scalar multiplier, i.e. use `12` to annualize monthly returns, and use `252` to annualize daily returns. Note that most other measures scale with √, but this ratio not.
- `risk_free`:          Optional vector or scalar value denoting the risk-free return(s). Must have same frequency (e.g. daily) as the provided returns.
"""
function treynor_ratio(asset_returns, benchmark_returns; multiplier=1.0, risk_free=0.0)
    α, β = capm(asset_returns, benchmark_returns; risk_free=risk_free)
    mean(asset_returns .- risk_free) / β * multiplier
end
