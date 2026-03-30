# The Geometry of What Is Learned  
## Realization Maps, Fiber Structure, and the Semantic Manifold

---

## Executive Summary

The prevailing study of neural networks erroneously treats the parameter vector θ as the primary object of meaning. In reality, parameters are coordinates in a gauge space; meaning resides in the functions a network computes.

This document develops a geometric framework centered on the realization map Φ, which maps parameter vectors to functions.

### Core Takeaways

Semantic invariance: meaning is invariant under implementation. Quantities like flatness, parameter magnitude, and gradient norms are not invariant under symmetry groups and therefore carry no semantic content.

Semantic manifold (𝒩): the space of realizable functions forms a manifold where learning occurs, equipped with a metric induced by the data distribution.

Natural gradient: the correct update rule minimizes parameter motion for a desired functional change.

Entanglement: curvature (Ω) of implementation fibers degrades optimization, generalization, and compression.

Observational equivalence: parameters within the same fiber are statistically indistinguishable under all possible tests.

---

## 1. The Realization Map and System Model

The central object is the realization map:

Φ : Θ → 𝒩  

where:

Θ — parameter space (Euclidean, finite-dimensional)  
𝒩 — semantic manifold (space of functions)  
Φ(θ) = f_θ — realized function  
G_A — architectural symmetry group  
Φ⁻¹(f) — implementation fiber  
V_θ — vertical subspace (redundant directions)  
H_θ — horizontal subspace (semantic directions)  
d = dim(𝒩) — semantic dimension  

---

### Fiber Bundle Structure

The realization map partitions Θ into equivalence classes:

θ ~ θ′  if Φ(θ) = Φ(θ′)

Thus:

𝒩 ≅ Θ / G_A  

Meaning exists only in the quotient space.

When G_A acts freely and properly, Φ defines a smooth principal bundle.

---

## 2. The Failure of Parameter-Centric Metrics

Modern ML relies on quantities that are not semantically invariant.

### Flatness

Flatness depends on parameterization. Scaling symmetries can transform sharp minima into flat ones without changing the function.

### Parameter Magnitude

Magnitude can be redistributed arbitrarily within a fiber. It carries no semantic meaning.

### Gradient Descent

Standard gradient descent is not invariant under reparameterization. Identical functions yield different optimization trajectories.

### Conclusion

Any non-invariant quantity reflects implementation artifacts, not meaning.

---

## 3. Geometry of the Semantic Manifold (𝒩)

The manifold 𝒩 carries geometric, functional, and statistical structure.

### Semantic Metric

g_f(δf₁, δf₂) = Eₓ∼D [ δf₁(x) · δf₂(x) ]

This defines statistical distinguishability.

For probabilistic models, this induces the Fisher Information Matrix on Θ.

---

### Universal Property

𝒩 is the coequalizer of the equivalence relation induced by Φ.

Any semantic invariant Q must factor through 𝒩:

Q(θ) = Q̃(Φ(θ))

If it does not, it depends on implementation.

---

## 4. Learning as Geometric Motion

Learning is motion induced by Φ.

### Vertical vs Horizontal Motion

Vertical directions (V_θ): change parameters but not function.  
Horizontal directions (H_θ): change the function.

Standard gradients lie in H_θ but are still incorrect due to Euclidean geometry.

---

### Natural Gradient

The natural gradient solves:

minimize ‖θ̇‖² subject to a fixed semantic change

Properties:

- invariant under G_A  
- minimizes implementation drift  
- aligns updates with semantic geometry  

---

## 5. Entanglement and Connection Curvature

Entanglement is measured by curvature Ω.

High curvature implies mixing of semantic and implementation directions.

Let:

κ = ‖Ω‖  

### Consequences

Optimization degradation: vertical drift increases  
Generalization degradation: depends on κ, not just parameter count  
Compression inefficiency: navigating fibers becomes costly  

---

### Geometric Disentanglement

Normalization, residual connections, and symmetry constraints reduce curvature and improve learning.

---

## 6. Observational Equivalence and Identifiability

### Indistinguishability Theorem

If:

Φ(θ) = Φ(θ′)

then no statistical test can distinguish θ from θ′.

---

### Observables

All observable quantities are semantic invariants.

Weights and neuron activations tied to parameterizations are fundamentally unobservable.

---

## 7. Global Topology of Function Space

The manifold 𝒩 has nontrivial topology.

### Connected Components

Different function classes (e.g. classifiers) may lie in separate components.

### Topological Holes

Homotopy classes define global invariants.

### Morse Constraints

The number of minima is constrained by topology.

---

## 8. Conclusion: The Invariance Thesis

Meaning is invariant under implementation.

The correct object of study is the equivalence class defined by Φ.

---

### Practical Implications

Model complexity:

d = n − dim(G_A)

Symmetry improves generalization by reducing semantic dimension.

Curvature reduction improves:

- optimization  
- generalization  
- compression  

---

### Final Remark

The central challenge is computational: evaluating the Jacobian of Φ at scale.

However, this framework provides the correct foundation:

learning is navigation on a compressed, curved, topologically structured space of functions.
