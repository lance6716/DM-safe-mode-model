---- MODULE MC ----
EXTENDS row_replicate, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
v1, v2
----

\* MV CONSTANT definitions Values
const_16616062017869000 == 
{v1, v2}
----

\* SYMMETRY definition
symm_166160620178610000 == 
Permutations(const_16616062017869000)
----

\* CONSTANT definitions @modelParameterConstants:0NumChanges
const_166160620178611000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:3NumColumns
const_166160620178612000 == 
2
----

=============================================================================
\* Modification History
\* Created Sat Aug 27 21:16:41 CST 2022 by lance6716
