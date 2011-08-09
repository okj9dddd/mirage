(** This module provides functions for creating and using Regular Expression.

   It is in pure OCaml (unlike Pcre_Ocaml) and thus more portable. It is
   reentrant (unlike Str) but not thread-safe in case of preemptive schedulling.
 *)


(** # Basic regexps. *)


(** The type of regexps.*)
type regexp


(** ## Regexp constructors.*)

(** ### Functional constructors.*)

(** The regexp denoting the absence of word.*)
val empty : regexp

(** The regexp denoting the empty word.*)
val epsilon : regexp

(** The regexp matching a given character.*)
val char : char -> regexp

(** The regexp matching any character in the given range. Bounds are included.*)
val char_interv : char -> char -> regexp

(** The regexp matching the exact given string.*)
val string : string -> regexp

(** The regexp matching 0 or more words recognized by the given regexp. *)
val star : regexp -> regexp

(** The regexp matching words matched by either one of the given regexps.*)
val alt : regexp -> regexp -> regexp

(** The regexp matching the concatenation of two words matched by each one of
    the given regexps.*)
val seq : regexp -> regexp -> regexp

(** The regexp matching 0 or 1 word matched by the given regexp.*)
val opt : regexp -> regexp

(** The regexp matching 1 or more words matched by the given regexp.*)
val some : regexp -> regexp

(** ### Parsing constructor.*)

(** [from_string_raw s] parses the string [s] and returns the associated regexp.

    The following constructions can be used in the given string:
      TODO

  *)
val from_string_raw : string -> regexp




(** # Regexp compilation.*)

(** In order to improve the efficiency of regexps, they are compiled to a
    different internal representation.*)

(** The type of compiled regexps.*)
type compiled_regexp

(** ## Constructors for compiled regexps. *)

(** [compile re] compiles the regexp [re]. *)
val compile : regexp -> compiled_regexp

(** [from_string s] is [compile (from_string_raw s)].*)
val from_string : string -> compiled_regexp




(** # Regexp usage. *)

(** [search_forward cre s i] evaluates either to [Some (b, e)] is
    [String.sub s b (e - b)] is matched by [cre] (with [b >= i] or [None] if no
    such tuple exists. In other words, [(e, b)] are the inclusive begining and
    exclusive ending offset of a word of [s] starting from [i] matched by
    [cre].*)
val search_forward : compiled_regexp -> string -> int -> (int * int) option

(** [match_string cre s i] evaluates to either [Some e] if [String.sub s i (e -
    i)] is matched by [cre] or [None] if no such [e] exists.*)
val match_string : compiled_regexp -> string -> int -> int option

(** [list_matches cre s] evaluates to a list of strings in which each element is
    a sub-string of [s] matched by [cre]. None of the sub-string overlap.
    Moreover, they are of maximal size. *)
val list_matches : compiled_regexp -> string -> string list

(** [split_delim cre s] evaluates to a list of string in which each element is a
    sub-string of the original one. Each two consecutive elements of the list of
    sub-string was, in [s] separated by a word matched by [cre].
  *)
val split_delim : compiled_regexp -> string -> string list

(** [replace cre s by] replaces sub-strings of [s] matched by [cre] by [by].*)
val replace : compiled_regexp -> string -> string -> string

(** [substitute cre s map] substitutes sub-strings of [s] matched by [cre] by
    [map w] where [w] is the matched word. *)
val substitute : compiled_regexp -> string -> (string -> string) -> string


