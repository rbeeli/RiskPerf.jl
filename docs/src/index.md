# RiskPerf.jl

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/rbeeli/RiskPerf.jl/blob/main/LICENSE)
![Maintenance](https://img.shields.io/maintenance/yes/2026)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://rbeeli.github.io/RiskPerf.jl/stable/)

Quantitative risk and performance analysis package for financial time series powered by the Julia language.

RiskPerf.jl is engineered for high performance: core metrics avoid temporary allocations, exploit SIMD-friendly loops, and specialize on scalar vs. vector inputs. Compared with naïve broadcast-based implementations, typical routines (e.g. Sharpe/Information ratios, partial moments, summary statistics, etc.) are 5–50× faster and allocate virtually nothing, accelerating large backtests and real-time analytics.

## Index

```@index

```

## Functions

```@autodocs
Modules = [RiskPerf]
Order   = [:function, :type]
```

## Bug reports and feature requests

Please report any issues via the [GitHub issue tracker](https://github.com/rbeeli/RiskPerf.jl/issues).

## Acknowledgements

This package was inspired by the **R** package [`PerformanceAnalytics`](https://cran.r-project.org/web/packages/PerformanceAnalytics/index.html) of Peter Carl and Brian G. Peterson.
