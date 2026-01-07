# MyModule.jl

[![docs: dev](https://img.shields.io/badge/docs-dev-blue.svg)]()
[![Julia](https://img.shields.io/badge/julia-v1.12+-9558b2.svg)](https://julialang.org)
[![Code Style: Blue](https://img.shields.io/badge/Code%20Style-Blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

<a id="badge-top"></a>
[![codecov](https://codecov.io/gh/sotashimozono/Lattices.jl/graph/badge.svg?token=6E7VZ9MJMK)](https://app.codecov.io/gh/sotashimozono)
[![Build Status](https://github.com/sotashimozono/Lattice2D.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/sotashimozono/Lattice2D.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

this repository is made for template folder for developing julia project.  
some of convenient features are available, but you need to fix to your current calculations.

## TODO LIST

1. change module name.
   1. `Project.toml`
      1. Project name
      2. Project uuid
      3. if you re-construct `Project.toml`, you need to add `Test.jl` into `extras` and `target`
   2. `MyModule.jl`
      1. change file name
         1. filename must be consistent with Project.toml
2. Create Test Code
   1. `runtests.jl`
      1. change `using MyModule` into current module name
      2. make directory in `test` directory and add `test_[content].jl`
      3. all testfile will be automaticaly executed.
         1. `activate .` in `julia REPL` package root directory.
         2. `test`
      4. [Codecov](https://app.codecov.io/github/sotashimozono) is convenient to capture how source code is reliable. you can setup
         1. from `codecov > repository`, you can get keys
         2. add keys to `github > repository > settings > secrets and variabeles > Actions > secrets`
         3. get badge link from `codecov > repository > configuration > Badges & Graphs`
         4. Replace the **[codecov badge at the top of this README](#badge-top)** with your new badge link.
3. Make Docs?
   1. No
      1. you need to do Nothing
   2. Yes
      1. add docstring in your source files.
      2. change module name in `docs/make.jl` and `docs/src/index.md`
      3. construct environment for docs
         1. cd `docs` and activate
         2. `add Documenter`
         3. `develop ..`
         4. `include("make.jl")`
      4. it is reccomended to change filename `.github/workflows/Documentation.yml.disabled` into `.github/workflows/Documentation.yml`
      5. you need to change deploy branch from `github > setting > pages`
4. GitHub Settings
   1. Actions Permissions
      - Go to `Settings > Actions > General`
      - Change `Workflow permissions` to `Read and write permissions` (required for Documenter/TagBot).
   2. Secrets
      - If using Codecov, add `CODECOV_TOKEN` to `Settings > Secrets and variables > Actions`.
5. Personalization
   - Update `LICENSE` (Year and Name).
   - Update Badge URLs in `README.md` (Replace `sotashimozono/Lattice2D.jl` with your new repo path).
   - (Optional) Update `.JuliaFormatter.toml` if you prefer different code styles.
6. Development Environment
   - This repo supports **GitHub Codespaces**.
   - Just click `Code > Codespaces > +` to start coding with `Revise.jl`, `IJulia.jl`, and `JuliaFormatter.jl` pre-installed.

## IF YOU HAD SOME TROUBLES PLEASE MAKE `ISSUES` [HERE](https://github.com/sotashimozono/template.jl/issues)