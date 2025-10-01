# Contributing

Pull requests and issues are welcome.

## TODOs

- marginal risk contribution
  - <https://cran.r-project.org/web/packages/riskParityPortfolio/vignettes/slides-ConvexOptimizationCourseHKUST.pdf> page 31
- add support for working with DataFrame / Tables.jl
  - returns calculations
- add more drawdown measures (page 88+)
- Kelly criterion and maybe more advanced versions

## Building documentation

The documentation is built using [Documenter.jl](https://documenter.juliadocs.org/stable/).

To rebuild, run the following command from the root of the repository:

```bash
cd docs && julia --project=. make.jl && cd ..
```
