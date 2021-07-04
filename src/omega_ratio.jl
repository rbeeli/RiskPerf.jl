"""
    omega_ratio(returns, target_return)

This function calculates the Omega ratio.

# Formula

    E[max(returns - target_return, 0)] / E[max(target_return - returns, 0)]

# Arguments
- `returns`:        Vector of asset returns.
- `target_return`:  Vector or scalar value of benchmark returns having same same frequency (e.g. daily) as the provided returns.
"""
function omega_ratio(returns, target_return)
    excess = returns .- target_return
    sum1 = sum(map(x -> max(0.0, x), excess))
    sum2 = -sum(map(x -> min(0.0, x), excess))
    sum1 / sum2
end
