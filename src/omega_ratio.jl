"""
    omega_ratio(returns, target_return)

This function calculates the Omega ratio.
Note that the ratio returns `Inf` if all returns are greater or equal to the target return.

# Formula

``\\Omega = -\\dfrac{ \\mathbb{E}\\left[ \\text{max}(\\text{returns} - \\text{target\\_return}, 0) \\right] }{ \\mathbb{E}\\left[ \\text{min}(\\text{target\\_return} - \\text{returns}, 0) \\right] }``

# Arguments
- `returns`:        Vector of asset returns.
- `target_return`:  Scalar value of average benchmark return.
"""
@inline function omega_ratio(returns::AbstractVector, target_return::Real)
    T = float(promote_type(eltype(returns), typeof(target_return)))
    gains = zero(T)
    losses = zero(T)
    tr = T(target_return)
    @inbounds @simd for r in returns
        d = T(r) - tr
        if d >= 0
            gains += d
        else
            losses -= d
        end
    end
    gains / losses
end

"""
    omega_ratio(returns, target_return)

This function calculates the Omega ratio.
Note that the ratio returns `Inf` if all returns are greater or equal to the target return.

# Formula

``\\Omega = -\\dfrac{ \\mathbb{E}\\left[ \\text{max}(\\text{returns} - \\text{target\\_return}, 0) \\right] }{ \\mathbb{E}\\left[ \\text{min}(\\text{target\\_return} - \\text{returns}, 0) \\right] }``

# Arguments
- `returns`:        Vector of asset returns.
- `target_return`:  Vector of benchmark returns having same frequency (e.g. daily) as the provided returns.
"""
@inline function omega_ratio(returns::AbstractVector, target_return::AbstractVector)
    length(returns) == length(target_return) ||
        throw(ArgumentError("returns and target_return must have same length"))
    T = float(promote_type(eltype(returns), eltype(target_return)))
    gains = zero(T)
    losses = zero(T)
    @inbounds @simd for i in eachindex(returns, target_return)
        d = T(returns[i]) - T(target_return[i])
        if d >= 0
            gains += d
        else
            losses -= d
        end
    end
    gains / losses
end
