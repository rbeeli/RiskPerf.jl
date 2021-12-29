module RiskPerf
   using Dates
   using Statistics
   using Distributions

   include("returns.jl")
   include("moments.jl")
   include("volatility.jl")
   include("upside_downside_deviation.jl")
   include("tracking_error.jl")
   include("sharpe_ratio.jl")
   include("information_ratio.jl")
   include("sortino_ratio.jl")
   include("treynor_ratio.jl")
   include("omega_ratio.jl")
   include("capm.jl")
   include("jensen_alpha.jl")
   include("value_at_risk.jl")
   include("expected_shortfall.jl")
   include("upside_potential_ratio.jl")
   include("drawdowns.jl")
   include("risk_contribution.jl")

   # export all
   for n in names(@__MODULE__; all=true)
      if Base.isidentifier(n) && n ∉ (Symbol(@__MODULE__), :eval, :include)
          @eval export $n
      end
   end
end
