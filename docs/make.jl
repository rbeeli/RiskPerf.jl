push!(LOAD_PATH,"../src/")

using Documenter
using RiskPerf

makedocs(
    sitename = "RiskPerf.jl",
    # format = Documenter.HTML(prettyurls=false),
    # modules = [RiskPerf]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
