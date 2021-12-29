

# calc_returns(x, :simple) calc_returns(x, :arithmetic)
# calc_returns(x, :log)
# calc_returns(x, :diff)



# using CSV
# using DataFrames
#
# path = "/home/rino/Dropbox/portfolio_opt_matthias/sp500_2000-2020.csv"
#
# df = DataFrame(CSV.File(path; header=1, delim=","));
# prices = df[:, 2:12];
# returns = prices[2:end, :] ./ prices[1:end-1, :] .- 1.0;
# returns = Matrix(returns);
# covariance_matrix = cov(returns);






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