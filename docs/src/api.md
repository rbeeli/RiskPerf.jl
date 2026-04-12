```@meta
CurrentModule = RiskPerf
```

# API Reference

This page is generated from the public docstrings in `RiskPerf.jl`. The same
text is available in the Julia REPL with help mode, for example `?sharpe_ratio`,
`?value_at_risk`, and `?simple_returns`.

## Returns, Drawdowns, And Growth

```@autodocs
Modules = [RiskPerf]
Pages = ["returns.jl", "drawdowns.jl", "calmar_ratio.jl"]
Private = false
Order = [:function]
```

## Moments, Partial Moments, And Tail Risk

```@autodocs
Modules = [RiskPerf]
Pages = [
    "moments.jl",
    "upside_downside_deviation.jl",
    "value_at_risk.jl",
    "expected_shortfall.jl",
]
Private = false
Order = [:function]
```

## Risk-Adjusted Performance

```@autodocs
Modules = [RiskPerf]
Pages = [
    "volatility.jl",
    "sharpe_ratio.jl",
    "sortino_ratio.jl",
    "omega_ratio.jl",
    "upside_potential_ratio.jl",
    "tracking_error.jl",
    "information_ratio.jl",
    "treynor_ratio.jl",
    "capm.jl",
    "jensen_alpha.jl",
]
Private = false
Order = [:function]
```

## Portfolio Risk Contribution

```@autodocs
Modules = [RiskPerf]
Pages = ["risk_contribution.jl"]
Private = false
Order = [:function]
```
