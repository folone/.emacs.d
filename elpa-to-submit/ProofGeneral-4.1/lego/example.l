(*
    Example proof script for Lego Proof General.
 
    example.l,v 11.0 2010/10/10 22:57:08 da Exp
*)

Module example Import lib_logic;

Goal {A,B:Prop}(A /\ B) -> (B /\ A);
intros;
Refine H;
intros;
andI;
Immed;
Save and_comms;
