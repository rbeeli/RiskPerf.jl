push!(LOAD_PATH, "../src/")

using Documenter
using RiskPerf

makedocs(;
    sitename="RiskPerf.jl",
    # format = Documenter.HTML(prettyurls=false),
    # modules = [RiskPerf]
)

deploydocs(; repo="github.com/rbeeli/RiskPerf.jl.git")
