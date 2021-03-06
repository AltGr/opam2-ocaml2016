open Html
open Slides

let mframe ?title content =
  frame {
    default with
    transition = Slides.None;
    title = (match title with Some t -> title3 t | None -> fade.title);
    content;
  }

let (+!) a b =
  Omd.to_html
    (Omd.of_string a @ [
        Omd_representation.Html ("div",["class",Some "fragment";"style",Some "width:100%;"],
                                 Omd.of_string b)
      ])

let slides =
  (* TITRE *)
  frame {
    fade with
    title = title2 "opam 2.0<br/>and the OCaml platform";
    content = {|
<div style="text-align:center; height:100%;">
Louis Gesbert, Anil Madhavapeddy<br>
<br>
<img src="images/logo.png" style="height:3.6ex;vertical-align:middle;"/><br>

<img src="images/ocamllabs.png" style="height:4ex;vertical-align:middle;"/><span style="font-size:140%;">OCaml Labs</span><br>

<img src="images/janestreet.png" style="height:5ex;vertical-align:middle;"/>

<div style="position:fixed;bottom: 0;left: 0; right:0; text-align: center">
OCaml Workshop 2016, Nara, Japan
</div>
</div>
|}
  } ::

  (* INTRO *)
  Multiple [
    mframe ~title:"opam" {|
- Project funded by Jane Street
- Developed at OCamlPro, by Louis Gesbert
- In coordination with OCaml Labs
- OCaml Package Repository maintained by the community
- Lots of useful feedback and contributions from the community
- Public repository available on github, <br>
  licensed under LGPL 2.1 with linking exception

<div style="margin-top:2ex;width:100%;text-align:center">https://opam.ocaml.org</div>
|};
    mframe ~title:"Authors" {|
<table>
<tr><td> Pietro Abate      <td> Vincent Bernardoff
<tr><td> Roberto Di Cosmo  <td> Thomas Gazagnaire
<tr><td> Louis Gesbert     <td> Fabrice Le Fessant
<tr><td> Anil Madhavapeddy <td> Guillem Rieu
<tr><td> Frederic Tuong
</table>

<div style="text-align:center;width:100%;">and 60 more contributors on Github!</div>

- Developed at OCamlPro, by Louis Gesbert
- In coordination with OCaml Labs
|};
  mframe ~title:"opam: the OCaml package manager" ({|
- Project started in 2012
- Release 1.0.0 was out in 2013
- Last stable release, 1.2.2, in May 2015
- Funded by Jane Street and, initially, the EU DORM grant
- Public repository available on github, <br>
  licensed under LGPL 2.1 with linking exception

<div style="margin-top:2ex;width:100%;text-align:center">https://opam.ocaml.org</div>
|})] ::


  mframe ~title:"Some metrics" {|
- Now more than 1300 packages available<br/>(>5500 including all versions)
- 250k package installations per month

<img class="fragment current-visible" data-fragment-index="0" src="images/unique-packages.png" style="position:fixed;bottom:0;margin:auto;left:0;right:0;"/>
<img class="fragment current-visible" data-fragment-index="1" src="images/packages.png" style="position:fixed;bottom:0;margin:auto;left:0;right:0;"/>
<img class="fragment current-visible" data-fragment-index="2" src="images/contributors.png" style="position:fixed;bottom:0;margin:auto;left:0;right:0;"/>

|} ::

  mframe ~title:"Lessons from 1.2" ({|
- advanced "pinning" feature was introduced
|}+!{|
- Feedback was extremely good
- Now adopted at scale, but
|}+!{|
- Some areas are not flexible enough for some advanced and industrial workflows
- Pinning at scale ?
- Not colorful enough
- API had room for improvement
- Microsoft Windows is hard
|}) ::

  mframe ~title:"Preview release" ({|
Preview release of **opam 2.0** is available:

<div style="margin-left:2em;">https://opam.ocaml.org/blog/opam-2-0-preview</div>

See also the updated documentation at:

<div style="margin-left:2em;">https://opam.ocaml.org/doc/2.0/Manual.html</div>
|}+!{|

A few highlights:

* Compilers as packages
* Local switches
* Command wrappers
* Installation tracking
* Better error mitigation...

|}) ::

(* NEW FEATURES *)
  mframe ~title:"Removing compiler definition files" ({|
* Motivations (Coq, Docker scripts...):
  - deduplication
  - flexibility
  - homogeneity
|}+!{|
* Consequences:
  - opam switches and compilers now untied
  - some extensions for packages (`opam` files, `<pkgname>.conf` files)
  - simpler, flat repository layout
  - new ways to handle switch creation
|}) ::

  mframe ~title:"New uses of switches" ({|
* switch creation, empty switches
* handling of switch contents:
  - compiler: "base" packages
  - root packages (no longer have to be installed)
  - installed packages
  - pinned packages |}+!{|
* re-setting or modification of the compiler
* custom compilers (e.g. Coq, ...)
* compiler upgrade and testing branches of OCaml
* repositories can be configured per-switch
|}) ::

  mframe ~title:"Local switches" ({|
Defined simply by using directories as switch names:

    opam switch create ~/src/project 4.03.0

|}+!{|
* the above command creates a prefix at `~/src/project/_opam`
|}+!{|
* the switch is auto-selected by opam when `PWD` is below `~/src/project`
|}+!{|
* convenient to sort your switches. Symlinks work.
* opens possibilities for various new workflows (sugar will be added)
|}) ::

  mframe ~title:"Wrappers" {|
* Alter commands from packages
* Can access the package's variables
* Allow many advanced uses:
  - control file system accesses (e.g. for CI)
  - build in containers
  - generate a cache of pre-built binaries...
* Global or per switch
* Can be defined in advance to affect `opam init`
|} ::

  Multiple [
  mframe ~title:"And much more" ({|
* Error mitigation|}+!{|
* More external solvers supported|}+!{|
* Fully reorganised, largely rewritten API|}+!{|
* Enhanced query CLI|}+!{|
* Installed file tracking|}+!{|
* Improved granularity of state loads|}+!{|
* New file-locking system|}+!{|
* Defining global and switch variables|}+!{|
* In-place builds|}+!{|
* Fully OCaml-agnostic
|});

  mframe ~title:"And even more" {|
* Reorganised switch contents
* Pinnings, even more flexible
* much better URL handling
* extended JSON report of actions
* handle git submodules and shallow repositories
* New internal file parse/print handling library (lenses)
|};

  mframe ~title:"Error mitigation" ({|
build errors happen

|}+!{|
* Clever organisation of actions does removals as late as possible.
  `remove b` → `remove a` → `build/install a` → `rebuild b`
  <br>becomes<br>
  `build a` → `remove b` → `remove a` → `install a` → `rebuild b`

|}+!{|
* opam doesn't forget your setup on failure. `opam install --restore`
|});

  mframe ~title:"More pinning options" {|
* All pinnings now treated the same:
  - fix the package version
  - optionally, provide an alternative package definition
* Directly edit package definitions (including URL)
* Build packages in-place
* Can now be included in `opam switch import/export`
* Re-use build artifacts
|}] ::

(* CHANGES & MIGRATION *)
  Multiple [
    mframe ~title:"opam files changes" {|
* One-file definitions: `url {}`, `synopsis:`, `description:`
* Can export environment variables: `setenv:`
* Self-references: `%{_:varname}%`
* `x-foo:` fields
* conditional and parameterized dependencies:
```
depends: "foo" { = _:version & os = "Linux" }
```
* `remove:` field generally unneeded
* `extra-sources:` to specify URLs of additional files needed
* `available:` can no longer depend on `ocaml-version`
|};
  mframe ~title:"Reorganised internal data" {|
* all switch data within `.opam-switch/` at the prefix corresponding to the
  switch
* separated development package caches per switch
* switch state stored in a single, human-readable file
  `.opam-switch/switch-state`
* all metadata of installed packages stored at `.opam-switch/packages/`, used
  for removal and detection of changes
|}] ::

  mframe ~title:"Migrating the OCaml repository" ({|
* 3 packages implement OCaml
  - `ocaml-base-compiler` the official OCaml releases
  - `ocaml-system` a wrapper over a compiler installed outside of opam
  - `ocaml-variants` any variant of the compiler
|}+!{|
* Plus a virtual `ocaml` package
  - depends on one of the actual OCaml providers
  - has the matching version
  - defines variables (`ocaml:native-dynlink-available`...)
|}+!{|
* Migration handled automatically
* Automatic compiler choice at `opam init` (configurable)
|}) ::

  mframe ~title:"Missing (but soon!)" ({|
* UI tuned for well-defined workflows
* Windows support
* End-to-end signing (but wait for the 11:45 talk!)
* Generation of software bundles
* A `provides:` field
|}) ::

  mframe ~title:"2.0 roadmap" ({|
All the atoms are here, now let's glue them together!|}+!{|

* **→ October**<br> Gather feedback on the Preview|}+!{|
* **→ November:**<br> Define the new supported workflows, sugar & document them|}+!{|
* **→ December:**<br> Beta relase|}+!{|
* **→ January:**<br> opam 2.0 !|}+!{|

Gathering feedback at:
- bug tracker:
<div style="text-align:center">https://github.com/ocaml/opam/issues</div>
- dedicated wiki page:
<div style="text-align:center">https://github.com/ocaml/opam/wiki/opam-2.0-FAQ</div>
|}) ::

  mframe ~title:"Defining workflows:<br/>local package build" {|
```
git clone myproject
cd myproject/
opam switch create ./ 4.03.0
opam pin add myproject.dev .
opam install myproject --inplace-build
```

Once we have a clear story and feedback, we'll make this shorter!
|} ::
(*
  mframe ~title:"Defining workflows: Docker builds"
    {|

|} ::
*)
  mframe ~title:"Auxiliary tools" {|
* opam-publish
* opam-user-setup
* opam-manager
* Camelus (opam-bot)
* opam weather service (http://ows.irill.org)
* http://bench.flambda.ocamlpro.com/
|} ::

(*
  mframe ~title:"Odoc" {|
...
|} ::

  mframe ~title:"Other ?" {|
...
|} ::
*)
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
  Html.make configuration  "opam 2.0 and the OCaml Platform" slides
