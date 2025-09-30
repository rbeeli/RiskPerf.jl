# https://oxfordstrat.com/coasdfASD32/uploads/2016/03/How-Sharp-Is-the-Sharpe-Ratio.pdf

"""
    sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)

Calculates the Sharpe Ratio (SR) according to the original definition by William F. Sharpe in 1966. For calculating the Sharpe Ratio according to Sharpe's revision in 1994, please see function `information_ratio` (IR).

# Formula

``\\text{SR} = \\dfrac{\\mathbb{E}\\left[\\text{returns} - \\text{risk\\_free} \\right]}{\\sigma(\\text{returns})} \\times \\sqrt{\\text{multiplier}}``

``\\text{IR} = \\dfrac{\\mathbb{E}\\left[\\text{asset\\_returns} - \\text{benchmark\\_returns} \\right]}{\\sigma(\\text{asset\\_returns} - \\text{benchmark\\_returns})} \\times \\sqrt{\\text{multiplier}}``

# Arguments
- `returns`:        Vector of asset returns.
- `multiplier`:     Optional scalar multiplier, i.e. use `12` to annualize monthly returns, and use `252` to annualize daily returns.
- `risk_free`:      Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).

# Sources
- Sharpe, W. F. (1966). Mutual Fund Performance. Journal of Business.
- Sharpe, William F. (1994). The Sharpe Ratio. The Journal of Portfolio Management.
"""
@inline sharpe_ratio(returns; multiplier=1.0, risk_free=0.0) =
    mean_excess(returns, risk_free) / std(returns) * sqrt(multiplier)

"""
    adjusted_sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)

Calculates the adjusted Sharpe Ratio introduced by Pezier and White (2006) by penalizing negative skewness and excess kurtosis.

# Formula

``\\text{SR} = \\dfrac{\\mathbb{E}\\left[ \\text{returns} - \\text{risk\\_free}\\right ]}{\\sigma(\\text{returns} - \\text{risk\\_free})}``

``\\text{ASR} = \\text{SR} \\left[1 + \\frac{S}{6}\\text{SR} - \\frac{K-3}{24}\\text{SR}^2\\right] \\times \\sqrt{\\text{multiplier}}``

# Arguments
- `returns`:        Vector of asset returns.
- `multiplier`:     Optional scalar multiplier, i.e. use `12` to annualize monthly returns, and use `252` to annualize daily returns.
- `risk_free`:      Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).

# Sources
- Pezier, Jaques and White, Anthony (2006). The Relative Merits of Investable Hedge Fund Indices and of Funds of Hedge Funds in Optimal Passive Portfolios. ICMA Centre Discussion Papers in Finance.
"""
function adjusted_sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)
    excess = returns .- risk_free
    SR = mean(excess) / std(excess)
    S = skewness(excess)
    K = kurtosis(excess; method=:excess)
    SR * (1 + (S / 6)SR - K / 24 * SR^2) * sqrt(multiplier)
end
