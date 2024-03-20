# RiskPerf.jl

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Quantitative risk and performance analysis package for financial time series powered by the Julia language.

This package was inspired by the **R** package [`PerformanceAnalytics`](https://cran.r-project.org/web/packages/PerformanceAnalytics/index.html) of Peter Carl and Brian G. Peterson.


## Functions

```julia
log_returns(prices::Vector)

log_returns(prices::Matrix)

simple_returns(prices::Vector)

simple_returns(prices::Matrix)

simple_returns(
    dates           ::Vector{DateTime},
    prices          ::Vector{T};
    drop_overnight  ::Bool=false
)

volatility(returns; multiplier=1.0)

drawdowns(returns; geometric::Bool=false)

drawdowns_pnl(pnl)

expected_shortfall(returns, α, method::Symbol; multiplier=1.0)

information_ratio(asset_returns, benchmark_returns; multiplier=1.0)

jensen_alpha(asset_returns, benchmark_returns; risk_free=0.0)

modified_jensen(asset_returns, benchmark_returns; risk_free=0.0)

skewness(x; method::Symbol=:moment)

kurtosis(x; method::Symbol=:excess)

omega_ratio(returns, target_return)

risk_contribution(weights, covariance_matrix)

sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)

adjusted_sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)

sortino_ratio(returns; multiplier=1.0, MAR=0.0)

tracking_error(asset_returns, benchmark_returns; multiplier=1.0)

treynor_ratio(asset_returns, benchmark_returns; multiplier=1.0, risk_free=0.0)

downside_deviation(returns, threshold; method::Symbol=:full)

upside_deviation(returns, threshold; method::Symbol=:full)

upside_potential_ratio(returns, threshold; method::Symbol=:partial)

value_at_risk(returns, α, method::Symbol; multiplier=1.0)

capm(asset_returns, benchmark_returns; risk_free=0.0)

lower_partial_moment(returns, threshold, n, method::Symbol)

higher_partial_moment(returns, threshold, n, method::Symbol)
```
