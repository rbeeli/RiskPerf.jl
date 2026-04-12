```@meta
CurrentModule = RiskPerf
```

# API Reference

The public docstrings are grouped by metric family. The same text is available
in the Julia REPL with help mode, for example `?sharpe_ratio`,
`?value_at_risk`, and `?simple_returns`.

## Reference Pages

- [Returns And Drawdowns](reference/returns.md): return conversion, growth
  metrics, period summaries, drawdowns, and Calmar ratio
- [Risk-Adjusted Performance](reference/performance.md): volatility, Sharpe,
  Sortino, Omega, tracking error, information ratio, CAPM, Treynor, and Jensen
  metrics
- [Tail Risk And Moments](reference/tail_risk.md): skewness, kurtosis, partial
  moments, upside/downside deviations, Value-at-Risk, and Expected Shortfall
- [Portfolio Risk](reference/portfolio.md): relative risk contribution

## Function Groups

| Group | Functions |
| --- | --- |
| Returns and growth | `simple_returns`, `log_returns`, `total_return`, `cagr`, `annualized_return`, `hit_rate`, `best_period_return`, `worst_period_return`, `best_worst_period_return` |
| Drawdowns | `drawdowns_pct`, `drawdowns_pnl`, `max_drawdown_pct`, `max_drawdown_pnl`, `average_drawdown_pct`, `ulcer_index`, `calmar_ratio` |
| Risk-adjusted performance | `volatility`, `sharpe_ratio`, `adjusted_sharpe_ratio`, `sortino_ratio`, `omega_ratio`, `upside_potential_ratio`, `tracking_error`, `information_ratio`, `treynor_ratio` |
| Benchmark models | `capm`, `jensen_alpha`, `modified_jensen` |
| Tail risk and moments | `skewness`, `kurtosis`, `lower_partial_moment`, `higher_partial_moment`, `downside_deviation`, `upside_deviation`, `value_at_risk`, `expected_shortfall` |
| Portfolio risk | `relative_risk_contribution` |
