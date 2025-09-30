# Changelog

## [0.3.1] – 2025‑09‑30

### Changed

- `lower_partial_moment` and `higher_partial_moment` now return `0.0` when the denominator is zero (previously `NaN`), improving downstream ratio behavior in no-tail or empty-input cases.
- Improved and corrected several docstrings (signatures, defaults, typos, and clarifications).

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
