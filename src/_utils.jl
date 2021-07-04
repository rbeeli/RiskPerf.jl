

# calc_returns(x, :simple) calc_returns(x, :arithmetic)
# calc_returns(x, :log)
# calc_returns(x, :diff)








# using BenchmarkTools

# const prices1 = collect(1.0:0.00001:100.0);

# @benchmark log_returns(prices1) samples=30


# function downsample(dts::Vector{DateTime}, additive_rets::Vector{Return})
#     zipped = zip(dts, additive_rets)
#     sampled = zipped |>
#         @groupby(Dates.Date(_[1])) |>
#         @orderby(key(_)) |>
#         @map(key(_) => sum(map(x -> x[2], _))) |>
#         collect
#     map(x -> x[1], sampled), map(x -> x[2], sampled)
# end
