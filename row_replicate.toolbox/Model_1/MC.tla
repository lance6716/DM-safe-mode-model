---- MODULE MC ----
EXTENDS row_replicate, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
v1, v2
----

\* MV CONSTANT definitions Values
const_166160670188116000 == 
{v1, v2}
----

\* SYMMETRY definition
symm_166160670188317000 == 
Permutations(const_166160670188116000)
----

\* CONSTANT definitions @modelParameterConstants:0NumChanges
const_166160670188318000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:3NumColumns
const_166160670188319000 == 
2
----

=============================================================================
\* Modification History
\* Created Sat Aug 27 21:25:01 CST 2022 by lance6716
