Require Import Category.Core Functor.Core NaturalTransformation.Paths FunctorCategory.Core Category.Morphisms NaturalTransformation.Core NaturalTransformation.Composition.Core.

Set Universe Polymorphism.
Set Implicit Arguments.
Generalizable All Variables.
Set Asymmetric Patterns.

Local Open Scope category_scope.
Local Open Scope morphism_scope.

Definition NaturalIsomorphism `{Funext} (C D : PreCategory) F G :=
  @Isomorphic (C -> D) F G.

Arguments NaturalIsomorphism {_} [C D] F G / .

Coercion natural_transformation_of_natural_isomorphism `{Funext} C D F G
         (T : @NaturalIsomorphism _ C D F G)
: NaturalTransformation F G
  := T : morphism _ _ _.

Local Infix "<~=~>" := NaturalIsomorphism : natural_transformation_scope.

Definition isisomorphism_components_of `{Funext}
           `{@IsIsomorphism (C -> D) F G T} x
: IsIsomorphism (T x).
Proof.
  exists (T^-1 x).
  - exact (apD10 (ap components_of left_inverse) x).
  - exact (apD10 (ap components_of right_inverse) x).
Defined.

Hint Immediate isisomorphism_components_of : typeclass_instances.

Definition inverse `{Funext}
           C D (F G : Functor C D) (T : NaturalTransformation F G)
           `{forall x, IsIsomorphism (T x)}
: NaturalTransformation G F.
Proof.
  exists (fun x => (T x)^-1);
  abstract (
      intros;
      iso_move_inverse;
      first [ apply commutes
            | symmetry; apply commutes ]
    ).
Defined.

Definition isisomorphism_natural_transformation `{Funext}
           C D F G (T : NaturalTransformation F G)
           `{forall x, IsIsomorphism (T x)}
: @IsIsomorphism (C -> D) F G T.
Proof.
  exists (inverse _);
  abstract (
      path_natural_transformation;
      first [ apply left_inverse
            | apply right_inverse ]
    ).
Defined.

Hint Immediate isisomorphism_natural_transformation : typeclass_instances.

Section idtoiso.
  Context `{Funext}.
  Variable C : PreCategory.
  Variable D : PreCategory.

  Definition idtoiso_natural_transformation
             (F G : object (C -> D))
             (T : F = G)
  : NaturalTransformation F G.
  Proof.
    refine (Build_NaturalTransformation
              F G
              (fun x => idtoiso _ (ap10 (ap object_of T) x))
              _).
    intros; case T; simpl.
    etransitivity; [ | symmetry ];
    first [ apply left_identity
          | apply right_identity ].
  Defined.

  Definition idtoiso
             (F G : object (C -> D))
             (T : F = G)
  : F <~=~> G.
  Proof.
    exists (idtoiso_natural_transformation T).
    exists (idtoiso_natural_transformation (T^)%path);
      abstract (path_natural_transformation; case T; simpl; auto with morphism).
  Defined.

  Lemma eta_idtoiso
        (F G : object (C -> D))
        (T : F = G)
  : Morphisms.idtoiso _ T = idtoiso T.
  Proof.
    case T.
    expand; f_ap.
    exact (center _).
  Qed.
End idtoiso.

Module Export FunctorCategoryMorphismsNotations.
  Infix "<~=~>" := NaturalIsomorphism : natural_transformation_scope.
End FunctorCategoryMorphismsNotations.