---- MODULE MC ----
EXTENDS row_replicate, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
v1, v2
----

\* MV CONSTANT definitions Values
const_166160717538323000 == 
{v1, v2}
----

\* SYMMETRY definition
symm_166160717538324000 == 
Permutations(const_166160717538323000)
----

\* CONSTANT definitions @modelParameterConstants:0NumChanges
const_166160717538325000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:3NumColumns
const_166160717538326000 == 
2
----

=============================================================================
\* Modification History
\* Created Sat Aug 27 21:32:55 CST 2022 by lance6716
