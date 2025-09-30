"""
    treynor_ratio(asset_returns, benchmark_returns; multiplier=1.0, risk_free=0.0)

Calculates the Treynor ratio as the ratio of excess return divided by the CAPM beta.
This ratio is similar to the Sharpe Ratio, but instead of dividing by the volatility,
we divide by the CAPM beta as risk proxy.

# Formula

``\\text{TR} = \\dfrac{ \\mathbb{E}\\left[ \\text{asset\\_returns} - \\text{risk\\_free} \\right]}{\\beta} \\times \\text{multiplier}``

# Arguments
- `asset_returns`:      Vector of asset returns.
- `benchmark_returns`:  Vector of benchmark returns (e.g. market portfolio returns).
- `multiplier`:         Optional scalar multiplier, i.e. use `12` to annualize monthly returns,
                        and use `252` to annualize daily returns.
- `risk_free`:          Optional vector or scalar value denoting the risk-free return
                        (must have same frequency as the provided returns, e.g. daily).
"""
@inline function treynor_ratio(asset_returns, benchmark_returns; multiplier=1.0, risk_free=0.0)
    α, β = capm(asset_returns, benchmark_returns; risk_free=risk_free)
    mean(asset_returns .- risk_free) / β * multiplier
end
