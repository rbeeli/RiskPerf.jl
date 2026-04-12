# RiskPerf.jl

`RiskPerf.jl` provides quantitative risk and performance metrics for financial
time series in Julia.

The core routines avoid temporary allocations, use SIMD-friendly loops where
appropriate, and specialize scalar and vector inputs for common portfolio and
strategy analytics workflows.

## Quick Start

```julia
using RiskPerf

returns = [0.012, -0.006, 0.004, 0.018, -0.011, 0.009]

sharpe_ratio(returns; multiplier=252)
sortino_ratio(returns; multiplier=252, MAR=0.0)
value_at_risk(returns, 0.05)
expected_shortfall(returns, 0.05)
```

Convert price series to returns before calculating risk and performance
metrics:

```julia
prices = [100.0, 101.0, 100.5, 99.8, 101.3]
returns = simple_returns(prices; drop_first=true)

total_return(returns)
cagr(returns, 252)
max_drawdown_pct(returns)
```

## Common Conventions

- Return vectors are assumed to be regularly spaced, for example daily, weekly,
  or monthly.
- `multiplier` is used for volatility-style annualization; use `252` for daily
  returns or `12` for monthly returns when those conventions fit the data.
- Functions that accept `risk_free`, `benchmark_returns`, or threshold inputs
  support scalars where a constant reference level is intended and vectors where
  period-by-period reference values are available.
- Drawdown functions use simple-return compounding by default. Set
  `compound=false` for the additive approximation.

## Guides

- [API Reference](api.md): generated from the public docstrings in
  `RiskPerf.jl`

## Development

Run tests with:

```bash
julia --project -e 'using Pkg; Pkg.test()'
```

Build docs with:

```bash
julia --project=docs docs/makedocs.jl
```

## Bug Reports And Feature Requests

Please report issues via the
[GitHub issue tracker](https://github.com/rbeeli/RiskPerf.jl/issues).

## Acknowledgements

This package was inspired by the **R** package
[`PerformanceAnalytics`](https://cran.r-project.org/web/packages/PerformanceAnalytics/index.html)
of Peter Carl and Brian G. Peterson.
