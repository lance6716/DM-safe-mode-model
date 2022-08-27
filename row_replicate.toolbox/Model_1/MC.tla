---- MODULE MC ----
EXTENDS row_replicate, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
v1, v2
----

\* MV CONSTANT definitions Values
const_16616009876199000 == 
{v1, v2}
----

\* SYMMETRY definition
symm_166160098762010000 == 
Permutations(const_16616009876199000)
----

\* CONSTANT definitions @modelParameterConstants:0NumChanges
const_166160098762011000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:3NumColumns
const_166160098762012000 == 
2
----

=============================================================================
\* Modification History
\* Created Sat Aug 27 19:49:47 CST 2022 by lance6716
