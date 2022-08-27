--------------------------- MODULE row_replicate ---------------------------
EXTENDS TLC, Sequences, Integers, FiniteSets

CONSTANT Values
ASSUME Cardinality(Values) > 0
CONSTANT NumChanges
ASSUME NumChanges > 0
CONSTANT NumColumns
ASSUME NumColumns > 0

CONSTANT Null

\* some logic below is also assuming there're 2 columns 
Columns == 1..NumColumns

ChangeType == {"insert", "update", "delete"}
RowType == [Columns -> Values]
RowChangeType == [type: ChangeType, old: RowType \union {Null}, new: RowType \union {Null}]

(* --algorithm generate_change_log
variables
  round = 0;
  upstream = {};
  downstream = {};
  change_log = <<>>;
  log_index = 1;

define
  TypeInvariant ==
    /\ round >= 0
    /\ upstream \subseteq RowType
    /\ downstream \subseteq RowType
    /\ \A i \in DOMAIN change_log: change_log[i] \in RowChangeType
    
  AllColumnsUniqueInvariant ==
    \A i \in Columns:
      /\ Cardinality({row[i]: row \in upstream}) = Cardinality(upstream) 
      /\ Cardinality({row[i]: row \in downstream}) = Cardinality(downstream) 
  
  ValuesAllUnique(row, rows) ==
    \A col \in Columns: \A r \in rows: row[col] # r[col]
    
  ValidNewRows(current_rows) ==
    {r \in RowType: ValuesAllUnique(r, current_rows)}
    
  ApplyOneChange(rows, one_change) ==
    ((rows \ {one_change.old}) \union {one_change.new}) \ {Null}
  
  Insert(rows, new_row) ==
    rows \union {new_row}
  
  Update(rows, old_row, new_row) ==
    IF old_row \notin rows THEN rows ELSE ((rows \ {old_row}) \union {new_row})
      
  Delete(rows, old_row) ==
    rows \ {old_row}
  
  DeleteByPK(rows, old_row) ==
    {x \in rows: x[1] # old_row[1]}
  
  UpdateByPK(rows, old_row, new_row) ==
    IF old_row[1] \notin {x[1]: x \in rows} THEN rows ELSE DeleteByPK(rows, old_row) \union {new_row}

  DataCorrectness == pc = "Done" => upstream = downstream
    
end define; 

begin
  Iterate:
    while round <= NumChanges do
      either
        \* try to insert a row
        with new_row \in ValidNewRows(upstream) do
          upstream := upstream \union {new_row};
          change_log := Append(change_log, [type |-> "insert", old |-> Null, new |-> new_row]);
        end with;
      or
        \* try to delete a row
        with old_row \in upstream do
          upstream := upstream \ {old_row};
          change_log := Append(change_log, [type |-> "delete", old |-> old_row, new |-> Null]);
        end with;
      or
        \* try to update a row
        with old_row \in upstream do
          with new_row \in ValidNewRows(upstream \ {old_row}) do
            \* for simplicity we allow update to same value
            upstream := (upstream \ {old_row}) \union {new_row};
            change_log := Append(change_log, [type |-> "update", old |-> old_row, new |-> new_row]);
          end with;
        end with;
      end either;
      
      round := round + 1;
    end while;

  Replicate:
    while log_index <= Len(change_log) do
      with change = change_log[log_index] do
        if change.type = "insert" then
          downstream := Insert(downstream, change.new)
        elsif change.type = "delete" then
          downstream := DeleteByPK(downstream, change.old)
        else
          downstream := UpdateByPK(downstream, change.old, change.new)
        end if;
      end with;

      log_index := log_index + 1;
    end while;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "c4f3b0e2" /\ chksum(tla) = "53629871")
VARIABLES round, upstream, downstream, change_log, log_index, pc

(* define statement *)
TypeInvariant ==
  /\ round >= 0
  /\ upstream \subseteq RowType
  /\ downstream \subseteq RowType
  /\ \A i \in DOMAIN change_log: change_log[i] \in RowChangeType

AllColumnsUniqueInvariant ==
  \A i \in Columns:
    /\ Cardinality({row[i]: row \in upstream}) = Cardinality(upstream)
    /\ Cardinality({row[i]: row \in downstream}) = Cardinality(downstream)

ValuesAllUnique(row, rows) ==
  \A col \in Columns: \A r \in rows: row[col] # r[col]

ValidNewRows(current_rows) ==
  {r \in RowType: ValuesAllUnique(r, current_rows)}

ApplyOneChange(rows, one_change) ==
  ((rows \ {one_change.old}) \union {one_change.new}) \ {Null}

Insert(rows, new_row) ==
  rows \union {new_row}

Update(rows, old_row, new_row) ==
  IF old_row \notin rows THEN rows ELSE ((rows \ {old_row}) \union {new_row})

Delete(rows, old_row) ==
  rows \ {old_row}

DeleteByPK(rows, old_row) ==
  {x \in rows: x[1] # old_row[1]}

UpdateByPK(rows, old_row, new_row) ==
  IF old_row[1] \notin {x[1]: x \in rows} THEN rows ELSE DeleteByPK(rows, old_row) \union {new_row}

DataCorrectness == pc = "Done" => upstream = downstream


vars == << round, upstream, downstream, change_log, log_index, pc >>

Init == (* Global variables *)
        /\ round = 0
        /\ upstream = {}
        /\ downstream = {}
        /\ change_log = <<>>
        /\ log_index = 1
        /\ pc = "Iterate"

Iterate == /\ pc = "Iterate"
           /\ IF round <= NumChanges
                 THEN /\ \/ /\ \E new_row \in ValidNewRows(upstream):
                                 /\ upstream' = (upstream \union {new_row})
                                 /\ change_log' = Append(change_log, [type |-> "insert", old |-> Null, new |-> new_row])
                         \/ /\ \E old_row \in upstream:
                                 /\ upstream' = upstream \ {old_row}
                                 /\ change_log' = Append(change_log, [type |-> "delete", old |-> old_row, new |-> Null])
                         \/ /\ \E old_row \in upstream:
                                 \E new_row \in ValidNewRows(upstream \ {old_row}):
                                   /\ upstream' = ((upstream \ {old_row}) \union {new_row})
                                   /\ change_log' = Append(change_log, [type |-> "update", old |-> old_row, new |-> new_row])
                      /\ round' = round + 1
                      /\ pc' = "Iterate"
                 ELSE /\ pc' = "Replicate"
                      /\ UNCHANGED << round, upstream, change_log >>
           /\ UNCHANGED << downstream, log_index >>

Replicate == /\ pc = "Replicate"
             /\ IF log_index <= Len(change_log)
                   THEN /\ LET change == change_log[log_index] IN
                             IF change.type = "insert"
                                THEN /\ downstream' = Insert(downstream, change.new)
                                ELSE /\ IF change.type = "delete"
                                           THEN /\ downstream' = DeleteByPK(downstream, change.old)
                                           ELSE /\ downstream' = UpdateByPK(downstream, change.old, change.new)
                        /\ log_index' = log_index + 1
                        /\ pc' = "Replicate"
                   ELSE /\ pc' = "Done"
                        /\ UNCHANGED << downstream, log_index >>
             /\ UNCHANGED << round, upstream, change_log >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Iterate \/ Replicate
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sat Aug 27 17:28:46 CST 2022 by lance6716
\* Created Thu Aug 25 16:02:35 CST 2022 by lance6716
