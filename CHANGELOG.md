# Changelog

## [0.3.1] – 2025‑09‑30

### Added

- `mean_excess` and `std_excess` helpers for allocation‑free mean and standard deviation of differences.
- `cagr` function for calculating the compound annual growth rate of a series of returns, with support for simple and log returns.
- `annualized_return` function for calculating the annualized return of a series of returns, with support for simple and log returns.

### Changed

- `lower_partial_moment` and `higher_partial_moment` now return `0.0` when the denominator is zero (previously `NaN`), improving downstream ratio behavior in no-tail or empty-input cases.
- Improved and corrected several docstrings (signatures, defaults, typos, and clarifications).
- Reimplemented `capm` with SIMD-friendly, allocation-free loops and scalar/vector dispatch for `risk_free`, yielding order-of-magnitude speedups on large portfolios.
- Refactored Sharpe, Sortino, Information, Tracking Error, Treynor ratios and omega/drawdown/partial-moment helpers to eliminate intermediate arrays and specialise on scalar vs. vector inputs.
- Improve type-stability.
- Changed param `geometric=false` to `compound=true` in `drawdowns_pct` and `max_drawdown_pct`.

## [0.3.0] – 2025‑09‑27

### Breaking changes ⚠️

- Changed `expected_shortfall` function to use keyword argument for `method` instead of positional argument
- Renamed `drawdowns` to `drawdowns_pct` for clarity

### Added

- Added functions `max_drawdown_pnl` and `max_drawdown_pct` for calculating maximum drawdown metric in absolute and percentage terms
- Added function `total_return` for calculating total return of a series

### Changed

- Migrated to `TestItemRunner.jl` for improved testing framework

### Fixed

- Harmonised `value_at_risk` and `expected_shortfall` annualisation to eliminate inconsistent multiplier outputs
- Prevented historical expected shortfall from returning `NaN` when the tail sample is smaller than the requested confidence level

## [0.2.0] – 2025‑07‑20

### Changed

- Static exports list of package symbols instead of dynamic export for better static analysis and IDE integration

## [0.1.0] – 2024-04-22

### Added

- First release of package
