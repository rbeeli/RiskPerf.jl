"""
    information_ratio(asset_returns, benchmark_returns; multiplier=1.0)

This function calculates the Information Ratio as the active return divided by the tracking error. The calculation equals William F. Sharpe's revision of the original version of the Sharpe Ratio (see function `sharpe_ratio`).

# Formula

    IR = E[asset_returns - benchmark_returns] / std(asset_returns - benchmark_returns) * sqrt(multiplier)

# Arguments
- `asset_returns`:      Vector of asset returns.
- `benchmark_returns`:  Vector or scalar value of benchmark returns having same same frequency (e.g. daily) as the provided returns.
- `multiplier`:         Optional scalar multiplier, i.e. use `12` to annualize monthly returns, and use `252` to annualize daily returns.

# Sources
- Sharpe, William F. (1994). "The Sharpe Ratio". The Journal of Portfolio Management.
"""
function information_ratio(asset_returns, benchmark_returns; multiplier=1.0)
    mean(asset_returns .- benchmark_returns) / std(asset_returns .- benchmark_returns) * sqrt(multiplier)
end
