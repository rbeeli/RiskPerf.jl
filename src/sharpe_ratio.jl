# https://oxfordstrat.com/coasdfASD32/uploads/2016/03/How-Sharp-Is-the-Sharpe-Ratio.pdf


"""
    sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)

Calculates the Sharpe Ratio (SR) according to the original definition by William F. Sharpe in 1966. For calculating the Sharpe Ratio according to Sharpe's revision in 1994, please see function `information_ratio` (IR).

# Formula

    SR = E[returns - risk_free] / std(returns) * multiplier

    IR = E[asset_returns - benchmark_returns] / std(asset_returns - benchmark_returns) * multiplier

# Arguments
- `returns`:    Vector of asset returns.
- `multiplier`: Optional scalar multiplier, i.e. use `√12` to annualize monthly returns, and use `√252` to annualize daily returns.
- `risk_free`:  Optional vector or scalar value denoting the risk-free return(s). Must have same frequency (e.g. daily) as the provided returns.

# Source
- Sharpe, W. F. (1966). "Mutual Fund Performance". Journal of Business.
- Sharpe, William F. (1994). "The Sharpe Ratio". The Journal of Portfolio Management.
"""
function sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)
    mean(returns .- risk_free) / std(returns) * multiplier
end



"""
    sharpe_ratio_adjusted(returns; multiplier=1.0, risk_free=0.0)

Calculates the adjusted Sharpe Ratio introduced by Pezier and White (2006) by penalizing negative skewness and excess kurtosis.

# Formula

    ASR = SR*[1 + (S/6)SR - (K-3)/24*SR^2] * multiplier

# Arguments
- `returns`:    Vector of asset returns.
- `multiplier`: Optional scalar multiplier, i.e. use `√12` to annualize monthly returns, and use `√252` to annualize daily returns.
- `risk_free`:  Optional vector or scalar value denoting the risk-free return(s). Must have same frequency (e.g. daily) as the provided returns.

# Source
- Pezier, Jaques and White, Anthony (2006). The Relative Merits of Investable Hedge Fund Indices and of Funds of Hedge Funds in Optimal Passive Portfolios. ICMA Centre Discussion Papers in Finance.
"""
function sharpe_ratio_adjusted(returns; multiplier=1.0, risk_free=0.0)
    excess = returns .- risk_free
    SR = mean(excess) / std(excess)
    S = skewness(excess)
    K = kurtosis(excess; method=:excess)
    SR*(1 + (S/6)SR - K/24*SR^2) * multiplier
end
