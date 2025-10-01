# RiskPerf.jl

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/rbeeli/RiskPerf.jl/blob/main/LICENSE)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://rbeeli.github.io/RiskPerf.jl/stable/)

Quantitative risk and performance analysis package for financial time series powered by the Julia language.

RiskPerf.jl is engineered for high performance: core metrics avoid temporary allocations, exploit SIMD-friendly loops, and specialize on scalar vs. vector inputs. Compared with naïve broadcast-based implementations, typical routines (e.g. Sharpe/Information ratios, partial moments, summary statistics, etc.) are 5–50× faster and allocate virtually nothing, accelerating large backtests and real-time analytics.

### Functions

```julia
simple_returns(prices::AbstractVector; drop_first=false, first_value=NaN)
simple_returns(prices::AbstractMatrix; drop_first=false, first_value=NaN)

log_returns(prices::AbstractVector; drop_first=false, first_value=NaN)
log_returns(prices::AbstractMatrix; drop_first=false, first_value=NaN)

total_return(returns::AbstractVector; method=:simple)
total_return(returns::AbstractVector; method=:log)

cagr(returns::AbstractVector; periods_per_year::Real, method=:simple)

volatility(returns::AbstractVector; multiplier=1.0)

information_ratio(asset_returns::AbstractVector, benchmark_returns::Real; multiplier=1.0)
information_ratio(asset_returns::AbstractVector, benchmark_returns::AbstractVector; multiplier=1.0)

jensen_alpha(asset_returns::AbstractVector, benchmark_returns::Real; risk_free=0.0)
jensen_alpha(asset_returns::AbstractVector, benchmark_returns::AbstractVector; risk_free=0.0)

modified_jensen(asset_returns::AbstractVector, benchmark_returns::Real; risk_free=0.0)
modified_jensen(asset_returns::AbstractVector, benchmark_returns::AbstractVector; risk_free=0.0)

drawdowns_pct(returns::AbstractVector; geometric=false)

drawdowns_pnl(pnl::AbstractVector)

max_drawdown_pct(returns::AbstractVector; geometric=false)

max_drawdown_pnl(pnl::AbstractVector)

capm(asset_returns::AbstractVector, benchmark_returns::Real; risk_free=0.0)
capm(asset_returns::AbstractVector, benchmark_returns::AbstractVector; risk_free=0.0)

sharpe_ratio(returns::AbstractVector; multiplier=1.0, risk_free=0.0)

adjusted_sharpe_ratio(returns::AbstractVector; multiplier=1.0, risk_free=0.0)

sortino_ratio(returns::AbstractVector; multiplier=1.0, MAR=0.0)

tracking_error(asset_returns::AbstractVector, benchmark_returns::Real; multiplier=1.0)
tracking_error(asset_returns::AbstractVector, benchmark_returns::AbstractVector; multiplier=1.0)

treynor_ratio(asset_returns::AbstractVector, benchmark_returns::Real; multiplier=1.0, risk_free=0.0)
treynor_ratio(asset_returns::AbstractVector, benchmark_returns::AbstractVector; multiplier=1.0, risk_free=0.0)

omega_ratio(returns::AbstractVector, target_return::Real)

skewness(x::AbstractVector; method=:moment)
skewness(x::AbstractVector; method=:fisher_pearson)
skewness(x::AbstractVector; method=:sample)

kurtosis(x::AbstractVector; method=:excess)
kurtosis(x::AbstractVector; method=:moment)
kurtosis(x::AbstractVector; method=:cornish_fisher)

upside_potential_ratio(returns::AbstractVector, threshold::Real; method=:full)
upside_potential_ratio(returns::AbstractVector, threshold::AbstractVector; method=:full)
upside_potential_ratio(returns::AbstractVector, threshold::Real; method=:partial)
upside_potential_ratio(returns::AbstractVector, threshold::AbstractVector; method=:partial)

value_at_risk(returns::AbstractVector, α::Real; method=:historical, multiplier=1.0)
value_at_risk(returns::AbstractVector, α::Real; method=:gaussian, multiplier=1.0)
value_at_risk(returns::AbstractVector, α::Real; method=:cornish_fisher, multiplier=1.0)

expected_shortfall(returns::AbstractVector, α::Real; method=:historical, multiplier=1.0)
expected_shortfall(returns::AbstractVector, α::Real; method=:gaussian, multiplier=1.0)
expected_shortfall(returns::AbstractVector, α::Real; method=:cornish_fisher, multiplier=1.0)

mean_excess(x::AbstractArray, y::Real)
mean_excess(x::AbstractArray, y::AbstractArray)

std_excess(x::AbstractArray, y::Real; corrected=true)
std_excess(x::AbstractArray, y::AbstractArray; corrected=true)

lower_partial_moment(returns::AbstractVector, threshold::Real, n::Int, method=:full)
lower_partial_moment(returns::AbstractVector, threshold::AbstractVector, n::Int, method=:full)
lower_partial_moment(returns::AbstractVector, threshold::Real, n::Int, method=:partial)
lower_partial_moment(returns::AbstractVector, threshold::AbstractVector, n::Int, method=:partial)

higher_partial_moment(returns::AbstractVector, threshold::Real, n::Int, method=:full)
higher_partial_moment(returns::AbstractVector, threshold::AbstractVector, n::Int, method=:full)
higher_partial_moment(returns::AbstractVector, threshold::Real, n::Int, method=:partial)
higher_partial_moment(returns::AbstractVector, threshold::AbstractVector, n::Int, method=:partial)

downside_deviation(returns::AbstractVector, threshold::Real; method=:full)
downside_deviation(returns::AbstractVector, threshold::AbstractVector; method=:full)
downside_deviation(returns::AbstractVector, threshold::Real; method=:partial)
downside_deviation(returns::AbstractVector, threshold::AbstractVector; method=:partial)

upside_deviation(returns::AbstractVector, threshold::Real; method=:full)
upside_deviation(returns::AbstractVector, threshold::AbstractVector; method=:full)
upside_deviation(returns::AbstractVector, threshold::Real; method=:partial)
upside_deviation(returns::AbstractVector, threshold::AbstractVector; method=:partial)

relative_risk_contribution(weights::AbstractVector, covariance_matrix::AbstractMatrix)
```

## Bug reports and feature requests

Please report any issues via the [GitHub issue tracker](https://github.com/rbeeli/RiskPerf.jl/issues).

## Acknowledgements

This package was inspired by the **R** package [`PerformanceAnalytics`](https://cran.r-project.org/web/packages/PerformanceAnalytics/index.html) of Peter Carl and Brian G. Peterson.
