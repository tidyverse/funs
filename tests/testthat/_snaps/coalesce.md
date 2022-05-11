# `.size` overrides the common size

    Code
      coalesce(x, 1:2, .size = vec_size(x))
    Condition
      Error in `coalesce()`:
      ! Can't recycle `..2` (size 2) to size 1.

# must have at least one non-`NULL` vector

    Code
      coalesce()
    Condition
      Error in `coalesce()`:
      ! `...` must contain at least one input.

---

    Code
      coalesce(NULL, NULL)
    Condition
      Error in `coalesce()`:
      ! `...` must contain at least one input.

# inputs must be vectors

    Code
      coalesce(1, environment())
    Condition
      Error in `coalesce()`:
      ! `..2` must be a vector, not an environment.

