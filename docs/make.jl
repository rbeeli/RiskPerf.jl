push!(LOAD_PATH, "../src/")

using Documenter
using RiskPerf

makedocs(;
    sitename="RiskPerf.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        sidebar_sitename=false,
        assets=["assets/styles.css"],
        edit_link="main",
    ),
)

deploydocs(; repo="github.com/rbeeli/RiskPerf.jl.git", devbranch="main")
