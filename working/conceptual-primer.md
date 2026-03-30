# The Realization Map  
## Decoding the Geometry of What Is Learned

---

## 1. The Euclidean Parameter Space vs the Riemannian Semantic Manifold

Modern deep learning suffers from a category error: confusing implementation with meaning.

The parameter vector θ is just a coordinate in ℝⁿ. The true meaning of a model lives in the function it computes.

If two parameter settings θ and θ′ produce the same function f, they are semantically identical.

Thus:

parameter space ≠ meaning space  

---

### Two Worlds of Neural Networks

| Parameter Space Θ | Semantic Space 𝒩 |
|------------------|------------------|
| Implementation (weights) | Behavior (function f) |
| Geometry: Euclidean | Geometry: Riemannian |
| High redundancy (fibers) | Unique functions |
| Metrics: often meaningless | Metric: Fisher Information |

---

### Key Insight

Flatness, magnitude, and gradient norms are not semantic invariants.

To understand learning, we must move from Θ to 𝒩.

---

## 2. The Realization Map Φ

The realization map connects parameters to functions:

Φ : Θ → 𝓕(𝓧, 𝓨)

The semantic space 𝒩 is the image of Φ.

---

### Levels of Structure

| Level | Structure |
|------|----------|
| A | Parameter space Θ |
| B | Function space 𝓕 |
| D | Semantic manifold 𝒩 |

---

### Local Behavior

Φ behaves locally like a projection.

At each θ:

- some directions change the function  
- some directions only change representation  

---

## 3. Implementation Fibers

An implementation fiber:

Φ⁻¹(f)

is the set of all parameter vectors that compute the same function.

---

### Recipe Analogy

Different recipes can produce the same dish.

- recipe text → parameters  
- dish → function  

Meaning is the dish, not the wording.

---

### Observational Equivalence

If θ and θ′ are in the same fiber:

- indistinguishable by any experiment  
- identical outputs for all inputs  

---

### Invariance Checklist

A property is semantic only if:

- invariant under scaling transformations  
- independent of parameterization  
- constant along fibers  

Otherwise, it is an artifact.

---

## 4. Role of Symmetry (G_A)

Symmetry transformations preserve the function:

Φ ∘ σ = Φ  

Examples include:

- neuron permutations  
- scaling transformations  

---

### Scaling Example

(w, v) → (αw, v / α)

Output remains unchanged.

---

### Semantic Dimension

d = n − dim(G_A)

Generalization depends on d, not n.

---

## 5. Why Parameter Geometry Fails

Common metrics fail because they are not invariant.

---

### Flat Minima

Hessian spectrum changes under reparameterization.

Flatness is not semantic.

---

### Magnitude Pruning

Magnitude can be redistributed within a fiber.

Pruning by size is arbitrary.

---

### Gradient Norms

Speed in parameter space ≠ speed in function space.

---

## 6. Learning as Geometric Motion

Learning is movement on 𝒩.

---

### Decomposition of Motion

Vertical space V_θ:

V_θ = ker DΦ(θ)  
→ changes implementation only  

Horizontal space H_θ:

→ changes function  

---

### Entanglement

Measured by curvature Ω.

High Ω causes:

- implementation drift  
- slower convergence  
- worse generalization  

---

### Natural Gradient Descent

θ̇ = −DΦ(θ)⁺ grad_g L  

This:

- projects onto horizontal space  
- removes redundant motion  
- ensures semantic learning  

---

## 7. Summary: Meaning is Invariant

The true object of learning is not θ, but the equivalence class:

[θ] = Φ⁻¹(f)

---

### Key Takeaways

Meaning = equivalence class of implementations  

Symmetry reduces semantic dimension:

d = n − dim(G_A)

Learning is navigation on 𝒩  

---

### Final Insight

Parameters are coordinates in a gauge space.

The function is the invariant object.

To understand deep learning, we must study the geometry of that invariance.
