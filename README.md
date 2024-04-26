# RiskPerf.jl

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
![Maintenance](https://img.shields.io/maintenance/yes/2024)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://rbeeli.github.io/RiskPerf.jl/docs/build/index.html)

Quantitative risk and performance analysis package for financial time series powered by the Julia language.

## Documentation

Full documentation is available [here](https://rbeeli.github.io/RiskPerf.jl/docs/build/index.html).

### Functions

```julia
simple_returns(prices::AbstractVector; drop_first=false, first_value=NaN)

simple_returns(prices::AbstractMatrix; drop_first=false, first_value=NaN)

log_returns(prices::AbstractVector; drop_first=false, first_value=NaN)

log_returns(prices::AbstractMatrix; drop_first=false, first_value=NaN)

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

relative_risk_contribution(weights, covariance_matrix)

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

## Bug reports and feature requests

Please report any issues via the [GitHub issue tracker](https://github.com/rbeeli/RiskPerf.jl/issues).

## Acknowledgements

This package was inspired by the **R** package [`PerformanceAnalytics`](https://cran.r-project.org/web/packages/PerformanceAnalytics/index.html) of Peter Carl and Brian G. Peterson.
