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
  frame {
    fade with
    title = title2 "opam 2.0<br/>and the OCaml platform";
    content = {|
<div style="text-align:center; height:100%;">
Louis Gesbert, Anil Madhavapeddy<br>
<br>
<img src="images/logo.png" width="30%"><br>

<div style="font-size:140%;vertical-align:middle;"><img src="images/ocamllabs.png" style="width:2em;">OCaml Labs</div><br>

<img src="images/janestreet.png" width="40%">

<div style="position:relative; bottom: 0;">
OCaml Workshop 2016, Nara, Japan
</div>
</div>
|}
  } ::

  Multiple [
    mframe ~title:"opam" {|
- Project funded by Jane Street
- Developed at OCamlPro, by Louis Gesbert
- In coordination with OCaml Labs
- OCaml Package Repository maintained by the community
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
- Now more than 1300 packages available (>5500 including all versions)
- 250k package installations per month

<img src="images/unique-packages.png">
|} ::

  mframe ~title:"Lessons from 1.2" ({|
- advanced "pinning" feature was introduced
|}+!{|
- Feedback was extremely good
- Now adopted at scale, but
- Some areas are not flexible enough for some advanced and industrial workflows
- Pinning at scale ?
- Not colorful enough
- API had room for improvement
- Microsoft Windows is hard
|}) ::

  mframe ~title:"Preview release" ({|
Preview release of 2.0 is already available:

<div style="margin-left:2em;">https://opam.ocaml.org/blog/opam-2-0-preview</div>

See also the updated documentation at:

<div style="margin-left:2em;">https://opam.ocaml.org/doc/2.0/Manual.html</div>
|}+!{|
* Compilers as packages
|}) ::

  mframe ~title:"Removing compiler definition files" ({|
* motivations (Coq, Docker scripts...):
  - deduplication
  - flexibility
  - homogeneity
|}+!{|
* consequences:
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

  mframe ~title:"opam files changes" {|
**SORT**

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
|} ::

  mframe ~title:"Migrating the OCaml repository" ({|
* 3 packages implement OCaml
  - `ocaml-base-compiler` the official OCaml releases
  - `ocaml-system` a wrapper over a compiler installed outside of opam
  - `ocaml-variants` any variant of the compiler
|}+!{|
* Plus a virtual `ocaml` package
  - depends on one of the actual OCaml providers
  - matches the actual version
  - defines variables (`ocaml:native-dynlink-available`...)
|}+!{|
* Migration handled automatically
* Automatic compiler choice at `opam init` (configurable)
|}) ::

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
* In-place builds

**WINDOWS**
|});

  mframe ~title:"And even more" {|
* Reorganised switch contents
* Pinnings, even more flexible
* much better URL handling
* extended JSON report of actions
* handle git submodules and shallow repositories
* New internal file parse/print handling library (lenses)
|};
  mframe ~title:"Reorganised internal data" {|
* all switch data within `.opam-switch/` at the prefix corresponding to the
  switch
* separated development package caches per switch
* switch state stored in a single, human-readable file
  `.opam-switch/switch-state`
* all metadata of installed packages stored at `.opam-switch/packages/`, used
  for removal and detection of changes
|};
  mframe ~title:"Error mitigation" ({|
build errors happen

|}+!{|
* clever organisation of actions does removals as late as possible.
  `remove b` → `remove a` → `build/install a` → `rebuild b`
  <br>becomes<br>
  `build a` → `remove b` → `remove a` → `install a` → `rebuild b`

|}+!{|
* opam doesn't forget your setup on failure. `opam install --restore`
|});
  mframe ~title:"More pinning options" {|
* all pinnings now treated the same:
  - fix the package version
  - optionally, provide an alternative package definition
* directly edit package definitions (including URL)
* build packages in-place
* can now be included in `opam switch import/export`
* re-use build artifacts
|}] ::

  mframe ~title:"Missing" ({|
* end-to-end signing (but wait for the 11:45 talk!)
* a `provides:` field
* generation of software bundles
* UI tuned for well-defined workflows
|}+!{|
* performance ?
|}) ::

  mframe ~title:"2.0 roadmap" ({|
All the atoms are here, now let's glue them together!|}+!{|

* **→ October**<br> Gather feedback on the Preview|}+!{|
* **→ November:**<br> Define the new supported workflows, sugar & document them|}+!{|
* **→ December:**<br> Beta relase|}+!{|
* **→ January:**<br> opam 2.0 !


issues + **FAQ** ??Q
|}) ::

  mframe ~title:"Defining workflows: local package build" {|
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

  mframe ~title:"Auxiliary tools" {|
* opam-publish
* opam-user-setup
* Camelus (opam-bot)
* opam weather service (http://ows.irill.org)
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
  Html.make configuration  "opam 2.0 and the OCaml Platform" slides
