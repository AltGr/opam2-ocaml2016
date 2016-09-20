open Html
open Slides

let mframe ?title content =
  frame {
    fade with
    title = (match title with Some t -> t | None -> fate.title);
    content
  }

let slides =
  frame {
    fade with
    title = title3 "opam 2.0: what's new ?";
  } ::
  mframe ~title:"opam: the OCaml package manager" @@ {|
- Project started in 2012
- Release 1.0.0 was out in 2013
- Last stable release, 1.2.2, in May 2015
- Funded by Jane Street and, initially, the EU DORM grant
- Public repository available on github, licensed under LGPL 2.1 with linking
  exception
|} ::

  mframe ~title:"Authors"
    {|
+-------------------+--------------------+
| Pietro Abate      | Vincent Bernardoff
| Roberto Di Cosmo  | Thomas Gazagnaire
| Louis Gesbert     | Fabrice Le Fessant
| Anil Madhavapeddy | Guillem Rieu
| Frederic Tuong    | Ralf Treinen

and 60 more contributors on Github!

Developed at OCamlPro, by Louis Gesbert since summer '14

With design work, feedback, repository management, platform integration, thanks
to OCaml Labs and the community.

Now licensed under LGPL 2.1 with linking exception
|} ::

  mframe ~title:"Some usage metrics" @@ {|
- Now more than 1300 packages available (<5500 including all versions)
- 250k package installations per month
|} ::

  mframe ~title:"Lessons from 1.2" @@ {|
1.2 introduced an advanced "pinning" feature and new packaging/development
workflows.

- Feedback was extremely good
- Some areas were not flexible enough for some advanced and industrial workflows
- Not colorful enough
- Scriptability and API had some room for improvement
|} ::

  mframe ~title:"Preview release" @@ {|
A preview release of 2.0 is already available:

https://opam.ocaml.org/blog/opam-2-0-preview

See also the updated documentation at:

https://opam.ocaml.org/doc/2.0/Manual.html
|} ::

  mframe ~title:"Removing compiler definition files" @@ {|
* motivations: deduplication, flexibility, homogeneity |}^pause{|
* consequences:
  - opam switches and compilers now untied
  - some extensions for packages (opam files, <pkgname>.conf files)
  - simpler, flat repository layout
  - new ways to handle switch creation
|} ::

  mframe ~title:"New uses of switches" @@ {|
* switch creation, empty switches
* handling of switch contents:
  - compiler: "base" packages
  - root packages (no longer have to be installed)
  - installed packages
  - pinned packages |}^pause{|
* re-setting or modification of the compiler
* custom compilers (e.g. Coq, ...)
* compiler upgrade and testing branches of OCaml
* repositories can be configured per-switch
|} ::

  mframe ~title:"Reorganised internal data" @@ {|
* all switch data within `.opam-switch/` at the prefix corresponding to the
  switch
* separated development package caches per switch
* switch state stored in a single, human-readable file
  `.opam-switch/switch-state`
* all metadata of installed packages stored at `.opam-switch/packages/`, used
  for removal and detection of changes
|} ::

  mframe ~title:"Local switches" @@ {|
Defined simply by using directories as switch names:

    opam switch create ~/src/project 4.03.0

|}^pause{|
* the above command creates a prefix at `~/src/project/_opam`
* the switch is auto-selected by opam when `PWD` is below `~/src/project`
* convenient to sort your switches. Symlinks work.
* opens possibilities for various new workflows (sugar will be added)
|} ::

  mframe ~title:"More pinning options" @@ {|
* all pinnings now treated the same:
  - fix the package version
  - optionally, provide an alternative package definition
* directly edit package definitions (including URL)
* build packages in-place
* can now be included in `opam switch import/export`
* re-use build artifacts
|} ::

  mframe ~title:"`opam` files changes" @@ {|
* One-file definitions: `opam` can now include `url` and `descr` information
  (`url {}`, `synopsis:`, `description:`)
* can export environment variables (`setenv:`)
* `x-foo:` fields
* conditional and parameterized dependencies:

    `depends: "foo" { = _:version & os = "Linux" }`

* `remove:` field generally unneeded
* `extra-sources:` to specify URLs of additional files needed
* `available:` can no longer depend on `ocaml-version`. That's now a
  `depends:`!
* allow variables referencing the package being defined with `%{_:varname}%`
|} ::

  mframe ~title:"Wrappers" @@ {|
* global or switch local commands controlling or analysing package actions when
  processed by opam
* Allows many advanced uses:
  - control file system accesses (e.g. for CI)
  - build in containers
  - generate a cache of pre-built binaries...
* Can be defined in advance to affect `opam init`
|} ::

  mframe ~title:"Error mitigation" @@ {|
build errors happen

|} ^pause {|
* clever organisation of actions does removals as late as possible.
  `remove b` → `remove a` → `build/install a` → `rebuild/install b`
  becomes
  `build a` → `remove b` → `remove a` → `install a` → `rebuild/install b`

|} ^pause {|
* opam doesn't forget your setup on failure. `opam install --restore` can be
  used to recover what was installed.
|} ::

  mframe ~title:"Migrating the OCaml repository" @@ {|
* separating the OCaml compiler variants:
  - `ocaml-base-compiler` the official OCaml releases
  - `ocaml-system` a wrapper over a compiler installed outside of opam
  - `ocaml-variants` any variant of the compiler, encoded as a `+variant-name`
    suffix in the version
* `ocaml` is now a virtual package used for dependencies that:
  - depends on one of the actual OCaml providers
  - matches version (e.g. `ocaml.4.03.0` works with `ocaml-variants.4.03.0+flambda`)
  - polls some specifics of the compiler (`ocaml:native-dynlink-available`...)
* this makes the compiler selection transparent to the packages
* migration handled automatically
* automatic compiler choice at `opam init` (configurable!)
|} ::

  mframe ~title:"And much more" @@ {|
* better support for more external solvers
* fully reorganised, largely rewritten API
* much enhanced query CLI
* installed file tracking
* rewritten state loads, with improved granularity
* rewritten locking system, safer and much more flexible
* handle git submodules and shallow repositories
* rewritten config file r/w library; allow computed file updates to produce
  reduced diffs
* much better URL handling
* extended JSON report of actions
* defining global and switch variables
|} ::

  mframe ~title:"Missing"
    {|
* end-to-end signing (but wait for the 11:45 talk!)
* a `provides:` field
* generation of software bundles
|}^pause{|

2.0 has large refactorings, but cycle for further point releases will be much
  shorter

* performance ?
|} ::

  mframe ~title:"2.0 roadmap" @@ {|
* All the atoms are here, now let's glue them together!
* → October: Gather feedback on the Preview
* → November: Define the new supported workflows, sugar & document them
* → December: Beta relase
* → January: opam 2.0 !
|} ::

  mframe ~title:"Defining workflows: local package build" @@ {|
```
git clone myproject
cd myproject/
opam switch create ./ 4.03.0
opam pin add myproject.dev .
opam install myproject --inplace-build
```

Once we have a clear story and feedback, we'll make this shorter!
|} ::

  mframe ~title:"Defining workflows: Docker builds"
    {|

|} ::

  mframe ~title:"Auxiliary tools" @@ {|
* opam-publish
* opam-user-setup
* Camelus (opam-bot)
* http://bench.flambda.ocamlpro.com/
|} ::

  []

(* Configuration *)
let configuration =
  let open Reveal in
  { default_global_config with
    slide_number = true;
    history = true;
    progress = true;
  }

(* Build the presentation with the given configuration *)
let () =
  Html.make configuration  "Signing opam" slides
