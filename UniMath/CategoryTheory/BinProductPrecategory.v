
(** **********************************************************

Benedikt Ahrens, Ralph Matthes

SubstitutionSystems

2015


************************************************************)


(** **********************************************************

Contents :

- Definition of the cartesian product of two precategories

- From a functor on a product of precategories to a functor on one of
  the categories by fixing the argument in the other component



************************************************************)


Require Import UniMath.Foundations.Basics.PartD.

Require Import UniMath.CategoryTheory.precategories.
Require Import UniMath.CategoryTheory.functor_categories.
Require Import UniMath.CategoryTheory.UnicodeNotations.

Local Notation "# F" := (functor_on_morphisms F)(at level 3).
Local Notation "F ⟶ G" := (nat_trans F G) (at level 39).
Local Notation "G ∙ F" := (functor_composite _ _ _ F G) (at level 35).

Ltac pathvia b := (apply (@pathscomp0 _ _ b _ )).

Definition binproduct_precategory_ob_mor (C D : precategory_ob_mor) : precategory_ob_mor.
Proof.
  exists (C × D).
  exact (λ cd cd', pr1 cd --> pr1 cd' × pr2 cd --> pr2 cd').
Defined.

Definition binproduct_precategory_data (C D : precategory_data) : precategory_data.
Proof.
  exists (binproduct_precategory_ob_mor C D).
  split.
  - intro cd.
    exact (dirprodpair (identity (pr1 cd)) (identity (pr2 cd))).
  - intros cd cd' cd'' fg fg'.
    exact (dirprodpair (pr1 fg ;; pr1 fg') (pr2 fg ;; pr2 fg')).
Defined.

Section one_binproduct_precategory.

Variables C D : precategory.

Lemma is_precategory_binproduct_precategory_data : is_precategory (binproduct_precategory_data C D).
Proof.
  repeat split; simpl; intros.
  - apply dirprodeq; apply id_left.
  - apply dirprodeq; apply id_right.
  - apply dirprodeq; apply assoc.
Qed.

Definition binproduct_precategory : precategory
  := tpair _ _ is_precategory_binproduct_precategory_data.

Definition has_homsets_binproduct_precategory (hsC : has_homsets C) (hsD : has_homsets D) :
  has_homsets binproduct_precategory.
Proof.
  intros a b.
  apply isasetdirprod.
  - apply hsC.
  - apply hsD.
Qed.

Definition ob1 (x : binproduct_precategory) : C := pr1 x.
Definition ob2 (x : binproduct_precategory) : D := pr2 x.
Definition mor1 (x x' : binproduct_precategory) (f : _ ⟦x, x'⟧) : _ ⟦ob1 x, ob1 x'⟧ := pr1 f.
Definition mor2 (x x' : binproduct_precategory) (f : _ ⟦x, x'⟧) : _ ⟦ob2 x, ob2 x'⟧ := pr2 f.



End one_binproduct_precategory.

Arguments ob1 { _ _ } _ .
Arguments ob2 { _ _ } _ .
Arguments mor1 { _ _ _ _ } _ .
Arguments mor2 { _ _ _ _ } _ .
Local Notation "C × D" := (binproduct_precategory C D) (at level 75, right associativity).

(** Objects and morphisms in the product precategory of two precategories *)
Definition binprodcatpair {C D : precategory} (X : C) (Y : D) : binproduct_precategory C D.
Proof.
  exists X.
  exact Y.
Defined.

Local Notation "A ⊗ B" := (binprodcatpair A B) (at level 10).

Definition binprodcatmor {C D : precategory} {X X' : C} {Z Z' : D} (α : X --> X') (β : Z --> Z')
  : X ⊗ Z --> X' ⊗ Z'.
Proof.
  exists α.
  exact β.
Defined.

(** Isos in product precategories *)
Definition binprodcatiso {C D : precategory} {X X' : C} {Z Z' : D} (α : iso X X') (β : iso Z Z')
  : iso (X ⊗ Z) (X' ⊗ Z').
Proof.
  set (f := binprodcatmor α β).
  set (g := binprodcatmor (iso_inv_from_iso α) (iso_inv_from_iso β)).
  exists f.
  apply (is_iso_qinv f g).
  use tpair.
  - apply pathsdirprod.
    apply iso_inv_after_iso.
    apply iso_inv_after_iso.
  - apply pathsdirprod.
    apply iso_after_iso_inv.
    apply iso_after_iso_inv.
Defined.

Definition binprodcatiso_inv {C D : precategory} {X X' : C} {Z Z' : D}
  (α : iso X X') (β : iso Z Z')
  : binprodcatiso (iso_inv_from_iso α) (iso_inv_from_iso β)
  = iso_inv_from_iso (binprodcatiso α β).
Proof.
  apply inv_iso_unique.
  apply pathsdirprod.
  - apply iso_inv_after_iso.
  - apply iso_inv_after_iso.
Defined.

(** Associativity functors *)
Section assoc.



Definition binproduct_precategory_assoc_data (C0 C1 C2 : precategory_data)
  : functor_data (binproduct_precategory_data C0 (binproduct_precategory_data C1 C2))
                 (binproduct_precategory_data (binproduct_precategory_data C0 C1) C2).
Proof.
  use tpair.
  (* functor_on_objects *) intros c. exact (tpair _ (tpair _ (pr1 c) (pr1 (pr2 c))) (pr2 (pr2 c))).
  (* functor_on_morphisms *) intros a b c. exact (tpair _ (tpair _ (pr1 c) (pr1 (pr2 c))) (pr2 (pr2 c))).
Defined.

Definition binproduct_precategory_assoc (C0 C1 C2 : precategory)
  : functor (C0 × (C1 × C2)) ((C0 × C1) × C2).
Proof.
  exists (binproduct_precategory_assoc_data _ _ _). split.
  (* functor_id *) intros c. simpl; apply paths_refl.
  (* functor_comp *) intros c0 c1 c2 f g. simpl; apply paths_refl.
Defined.

Definition binproduct_precategory_unassoc_data (C0 C1 C2 : precategory_data)
  : functor_data (binproduct_precategory_data (binproduct_precategory_data C0 C1) C2)
                 (binproduct_precategory_data C0 (binproduct_precategory_data C1 C2)).
Proof.
  use tpair.
  (* functor_on_objects *) intros c. exact (tpair _ (pr1 (pr1 c)) (tpair _ (pr2 (pr1 c)) (pr2 c))).
  (* functor_on_morphisms *) intros a b c. exact (tpair _ (pr1 (pr1 c)) (tpair _ (pr2 (pr1 c)) (pr2 c))).
Defined.

Definition binproduct_precategory_unassoc (C0 C1 C2 : precategory)
  : functor ((C0 × C1) × C2) (C0 × (C1 × C2)).
Proof.
  exists (binproduct_precategory_unassoc_data _ _ _). split.
  (* functor_id *) intros c. simpl; apply paths_refl.
  (* functor_comp *) intros c0 c1 c2 f g. simpl; apply paths_refl.
Defined.

End assoc.

(** The terminal precategory *)

Section unit_precategory.

Definition unit_precategory : precategory.
Proof.
  use tpair. use tpair.
  (* ob, mor *) exists unit. intros; exact unit.
  (* identity, comp *) split; intros; constructor.
  (* id_left *) simpl; split; try split; intros; apply isconnectedunit.
Defined.

Definition unit_functor C : functor C unit_precategory.
Proof.
  use tpair. use tpair.
  (* functor_on_objects *) intros; exact tt.
  (* functor_on_morphisms *) intros F a b; apply identity.
  split.
  (* functor_id *) intros x; apply paths_refl.
  (* functor_comp *) intros x y z w v; apply paths_refl.
Defined.

(* TODO: perhaps generalise to constant functors? *)
Definition ob_as_functor_data {C : precategory_data} (c : C) : functor_data unit_precategory C.
Proof.
  use tpair.
  (* functor_on_objects *) intros; exact c.
  (* functor_on_morphisms *) intros F a b; apply identity.
Defined.

Definition ob_as_functor {C : precategory} (c : C) : functor unit_precategory C.
Proof.
  exists (ob_as_functor_data c).
  split.
  (* functor_id *) intros; constructor.
  (* functor_comp *) intros x y z w v; simpl. apply pathsinv0, id_left.
Defined.

End unit_precategory.

(** Fixing one argument of C × D -> E results in a functor *)
Section functor_fix_fst_arg.

Variable C D E : precategory.
Variable F : functor (binproduct_precategory C D) E.
Variable c : C.

Definition functor_fix_fst_arg_ob (d:D): E := F(tpair _ c d).
Definition functor_fix_fst_arg_mor (d d':D)(f: d --> d'): functor_fix_fst_arg_ob d --> functor_fix_fst_arg_ob d'.
Proof.
  apply (#F).
  split; simpl.
  exact (identity c).
  exact f.
Defined.
Definition functor_fix_fst_arg_data : functor_data D E.
Proof.
  red.
  exists functor_fix_fst_arg_ob.
  exact functor_fix_fst_arg_mor.
Defined.

Lemma is_functor_functor_fix_fst_arg_data: is_functor functor_fix_fst_arg_data.
Proof.
  red.
  split; red.
  + intros d.
    unfold functor_fix_fst_arg_data; simpl.
    unfold functor_fix_fst_arg_mor; simpl.
    unfold functor_fix_fst_arg_ob; simpl.
    assert (functor_id_inst := functor_id F).
    rewrite <- functor_id_inst.
    apply maponpaths.
    apply idpath.
  + intros d d' d'' f g.
    unfold functor_fix_fst_arg_data; simpl.
    unfold functor_fix_fst_arg_mor; simpl.
    assert (functor_comp_inst := functor_comp F (dirprodpair c d) (dirprodpair c d') (dirprodpair c d'')).
    rewrite <- functor_comp_inst.
    apply maponpaths.
    unfold compose at 2.
    unfold binproduct_precategory; simpl.
    rewrite id_left.
    apply idpath.
Qed.

Definition functor_fix_fst_arg: functor D E.
Proof.
  exists functor_fix_fst_arg_data.
  exact is_functor_functor_fix_fst_arg_data.
Defined.

End functor_fix_fst_arg.

Section nat_trans_fix_fst_arg.

Variable C D E : precategory.
Variable F F': functor (binproduct_precategory C D) E.
Variable α: F ⟶ F'.
Variable c: C.

Definition nat_trans_fix_fst_arg_data (d:D): functor_fix_fst_arg C D E F c d --> functor_fix_fst_arg C D E F' c d := α (tpair _ c d).

Lemma nat_trans_fix_fst_arg_ax: is_nat_trans _ _ nat_trans_fix_fst_arg_data.
Proof.
  red.
  intros d d' f.
  unfold nat_trans_fix_fst_arg_data, functor_fix_fst_arg; simpl.
  unfold functor_fix_fst_arg_mor; simpl.
  assert (nat_trans_ax_inst := nat_trans_ax α).
  apply nat_trans_ax_inst.
Qed.

Definition nat_trans_fix_fst_arg: functor_fix_fst_arg C D E F c ⟶ functor_fix_fst_arg C D E F' c.
Proof.
  exists nat_trans_fix_fst_arg_data.
  exact nat_trans_fix_fst_arg_ax.
Defined.

End nat_trans_fix_fst_arg.

Section functor_fix_snd_arg.

Variable C D E : precategory.
Variable F: functor (binproduct_precategory C D) E.
Variable d: D.

Definition functor_fix_snd_arg_ob (c:C): E := F(tpair _ c d).
Definition functor_fix_snd_arg_mor (c c':C)(f: c --> c'): functor_fix_snd_arg_ob c --> functor_fix_snd_arg_ob c'.
Proof.
  apply (#F).
  split; simpl.
  exact f.
  exact (identity d).
Defined.
Definition functor_fix_snd_arg_data : functor_data C E.
Proof.
  red.
  exists functor_fix_snd_arg_ob.
  exact functor_fix_snd_arg_mor.
Defined.

Lemma is_functor_functor_fix_snd_arg_data: is_functor functor_fix_snd_arg_data.
Proof.
  split.
  + intros c.
    unfold functor_fix_snd_arg_data; simpl.
    unfold functor_fix_snd_arg_mor; simpl.
    unfold functor_fix_snd_arg_ob; simpl.
    assert (functor_id_inst := functor_id F).
    rewrite <- functor_id_inst.
    apply maponpaths.
    apply idpath.
  + intros c c' c'' f g.
    unfold functor_fix_snd_arg_data; simpl.
    unfold functor_fix_snd_arg_mor; simpl.
    assert (functor_comp_inst := functor_comp F (dirprodpair c d) (dirprodpair c' d) (dirprodpair c'' d)).
    rewrite <- functor_comp_inst.
    apply maponpaths.
    unfold compose at 2.
    unfold binproduct_precategory; simpl.
    rewrite id_left.
    apply idpath.
Qed.

Definition functor_fix_snd_arg: functor C E.
Proof.
  exists functor_fix_snd_arg_data.
  exact is_functor_functor_fix_snd_arg_data.
Defined.

End functor_fix_snd_arg.

Section nat_trans_fix_snd_arg.

Variable C D E : precategory.
Variable F F': functor (binproduct_precategory C D) E.
Variable α: F ⟶ F'.
Variable d: D.

Definition nat_trans_fix_snd_arg_data (c:C): functor_fix_snd_arg C D E F d c --> functor_fix_snd_arg C D E F' d c := α (tpair _ c d).

Lemma nat_trans_fix_snd_arg_ax: is_nat_trans _ _ nat_trans_fix_snd_arg_data.
Proof.
  red.
  intros c c' f.
  unfold nat_trans_fix_snd_arg_data, functor_fix_snd_arg; simpl.
  unfold functor_fix_snd_arg_mor; simpl.
  assert (nat_trans_ax_inst := nat_trans_ax α).
  apply nat_trans_ax_inst.
Qed.

Definition nat_trans_fix_snd_arg: functor_fix_snd_arg C D E F d ⟶ functor_fix_snd_arg C D E F' d.
Proof.
  exists nat_trans_fix_snd_arg_data.
  exact nat_trans_fix_snd_arg_ax.
Defined.

End nat_trans_fix_snd_arg.

(* Define pairs of functors and functors from pr1 and pr2 *)
Section functors.

Definition binproduct_pair_functor_data {A B C D : precategory}
  (F : functor A C) (G : functor B D) :
  functor_data (binproduct_precategory A B) (binproduct_precategory C D).
Proof.
mkpair.
- intro x; apply (binprodcatpair (F (pr1 x)) (G (pr2 x))).
- intros x y f; simpl; apply (binprodcatmor (# F (pr1 f)) (# G (pr2 f))).
Defined.

Definition binproduct_pair_functor {A B C D : precategory}
  (F : functor A C) (G : functor B D) :
  functor (binproduct_precategory A B) (binproduct_precategory C D).
Proof.
apply (tpair _ (binproduct_pair_functor_data F G)).
abstract (split;
  [ intro x; simpl; rewrite !functor_id; apply idpath
  | intros x y z f g; simpl; rewrite !functor_comp; apply idpath]).
Defined.

Definition pr1_functor_data (A B : precategory) :
  functor_data (binproduct_precategory A B) A.
Proof.
mkpair.
- intro x; apply (pr1 x).
- intros x y f; simpl; apply (pr1 f).
Defined.

Definition pr1_functor (A B : precategory) :
  functor (binproduct_precategory A B) A.
Proof.
apply (tpair _ (pr1_functor_data A B)).
abstract (split; [ intro x; apply idpath | intros x y z f g; apply idpath ]).
Defined.

Definition pr2_functor_data (A B : precategory) :
  functor_data (binproduct_precategory A B) B.
Proof.
mkpair.
- intro x; apply (pr2 x).
- intros x y f; simpl; apply (pr2 f).
Defined.

Definition pr2_functor (A B : precategory) :
  functor (binproduct_precategory A B) B.
Proof.
apply (tpair _ (pr2_functor_data A B)).
abstract (split; [ intro x; apply idpath | intros x y z f g; apply idpath ]).
Defined.

Definition bindelta_functor_data (C : precategory) :
  functor_data C (binproduct_precategory C C).
Proof.
mkpair.
- intro x; apply (binprodcatpair x x).
- intros x y f; simpl; apply (binprodcatmor f f).
Defined.

Definition bindelta_functor (C : precategory) :
  functor C (binproduct_precategory C C).
Proof.
apply (tpair _ (bindelta_functor_data C)).
abstract (split; [ intro x; apply idpath | intros x y z f g; apply idpath ]).
Defined.

Definition bindelta_pair_functor_data (C D E : precategory)
  (F : functor C D)
  (G : functor C E) :
  functor_data C (binproduct_precategory D E).
Proof.
  mkpair.
  - intro c. apply (binprodcatpair (F c) (G c)).
  - intros x y f. simpl. apply (binprodcatmor (# F f) (# G f)).
Defined.

Definition bindelta_pair_functor {C D E : precategory}
  (F : functor C D)
  (G : functor C E) :
  functor C (binproduct_precategory D E).
Proof.
  apply (tpair _ (bindelta_pair_functor_data C D E F G)).
  split.
  - intro c.
    simpl.
    rewrite functor_id.
    rewrite functor_id.
    apply idpath.
  - intros c c' c'' f g.
    simpl.
    rewrite functor_comp.
    rewrite functor_comp.
    apply idpath.
Defined.

End functors.
