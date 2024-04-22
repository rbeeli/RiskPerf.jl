"""
    omega_ratio(returns, target_return)

This function calculates the Omega ratio.
Note that the ratio returns `Inf` if all returns are greater or equal to the target return.

# Formula

``\\Omega = -\\dfrac{ \\mathbb{E}\\left[ \\text{max}(\\text{returns} - \\text{target\\_return}, 0) \\right] }{ \\mathbb{E}\\left[ \\text{min}(\\text{target\\_return} - \\text{returns}, 0) \\right] }``

# Arguments
- `returns`:        Vector of asset returns.
- `target_return`:  Vector or scalar value of benchmark returns having same same frequency (e.g. daily) as the provided returns.
"""
function omega_ratio(returns, target_return)
    excess = returns .- target_return
    gains = sum(map(x -> max(0.0, x), excess))
    losses = -sum(map(x -> min(0.0, x), excess))
    gains / losses
end
