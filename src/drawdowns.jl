


function drawdowns(returns; geometric::Bool=true)
    if geometric
        cum_rets = cumprod(1.0 .+ returns)
    else
        cum_rets = 1.0 .+ cumsum(returns)
    end

    cum_max = accumulate(max, cum_rets)
    cum_rets ./ cum_max .- 1.0
end


# # [1] 1.0 0.9 1.1 0.6 0.5 0.7 1.0 0.8 1.4 2.2 2.4 1.6
# # [1] 1.0 1.0 1.1 1.1 1.1 1.1 1.1 1.1 1.4 2.2 2.4 2.4
# returns = [0.0, -0.1, 0.2, -0.5, -0.1, 0.2, 0.3, -0.2, 0.6, 0.8, 0.2, -0.8];
# cum_rets = 1.0 .+ cumsum(returns)
# cum_max = accumulate(max, cum_rets)


# display(a)
# display(drawdowns(a; geometric=false))
