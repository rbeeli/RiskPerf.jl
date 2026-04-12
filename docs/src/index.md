# RiskPerf.jl

`RiskPerf.jl` provides quantitative risk and performance metrics for financial
time series in Julia.

The core routines avoid temporary allocations, use SIMD-friendly loops where
appropriate, and specialize scalar and vector inputs for common portfolio and
strategy analytics workflows.

## At A Glance

```julia
using RiskPerf

prices = [100.0, 101.0, 100.5, 99.8, 101.3]
returns = simple_returns(prices; drop_first=true)

metrics = (
    total_return=total_return(returns),
    volatility=volatility(returns; multiplier=252),
    sharpe=sharpe_ratio(returns; multiplier=252),
    max_drawdown=max_drawdown_pct(returns),
    value_at_risk=value_at_risk(returns, 0.05),
)
```

## Guides

- [Getting Started](getting_started.md): a compact workflow from prices to
  performance and tail-risk metrics
- [Conventions](conventions.md): frequency, annualization, scalar references,
  vector references, and drawdown behavior
- [API Reference](api.md): public docstrings grouped by metric family

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
