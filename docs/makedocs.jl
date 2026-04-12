using Pkg

cd(@__DIR__)
Pkg.activate(".")
Pkg.develop(; path=joinpath(@__DIR__, ".."))
Pkg.instantiate()

using Documenter: Documenter
using DocumenterVitepress
using RiskPerf

const DOCS_REPO = "github.com/rbeeli/RiskPerf.jl"
const DEPLOY_REPO = "github.com/rbeeli/RiskPerf.jl.git"

pages = [
    "Home" => "index.md",
    "API Reference" => "api.md",
]

function deploy_decision()
    decision = Documenter.deploy_folder(
        Documenter.auto_detect_deploy_system();
        repo=DOCS_REPO,
        devbranch="main",
        devurl="dev",
        push_preview=true,
    )

    if decision.all_ok && !decision.is_preview && decision.subfolder == "dev"
        return Documenter.DeployDecision(;
            all_ok=decision.all_ok,
            branch=decision.branch,
            is_preview=decision.is_preview,
            repo=decision.repo,
            subfolder="",
        )
    end

    return decision
end

deployment = deploy_decision()

Documenter.makedocs(
    sitename="RiskPerf.jl",
    modules=[RiskPerf],
    format=DocumenterVitepress.MarkdownVitepress(;
        repo=DOCS_REPO,
        devurl="dev",
        devbranch="main",
        description="Quantitative risk and performance analysis for financial time series in Julia.",
        deploy_decision=deployment,
    ),
    pages=pages,
    warnonly=get(ENV, "CI", "false") != "true",
    pagesonly=true,
)

Documenter.deploydocs(
    repo=DEPLOY_REPO,
    target=joinpath("build", "1"),
    versions=nothing,
    push_preview=true,
    devbranch="main",
)
