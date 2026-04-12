```@meta
CurrentModule = RiskPerf
```

# Risk-Adjusted Performance

Volatility, Sharpe-family ratios, downside-risk metrics, benchmark-relative
metrics, and CAPM/Jensen measures.

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
