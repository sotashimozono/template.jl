ENV["GKSwstype"] = "100"

using MyModule
using Test, Aqua
const dirs = []

const FIG_BASE = joinpath(pkgdir(MyModule), "docs", "src", "assets")
const PATHS = Dict()
mkpath.(values(PATHS))

@testset "tests" begin
    # ----- Test the module itself. -----
    @testset "Aqua tests" begin
        Aqua.test_all(MyModule)
    end
    # ----- Stage-1 citation check: every src/ docstring citation resolves to a
    #       docs/references.bib entry (pairs with the doiget Stage 2, in CI). -----
    include("references.jl")
    # ----- Test files in the "test" directory. -----
    test_args = copy(ARGS)
    println("Passed arguments ARGS = $(test_args) to tests.")
    @time for dir in dirs
        dirpath = joinpath(@__DIR__, dir)
        println("\nTest $(dirpath)")
        files = sort(
            filter(f -> startswith(f, "test_") && endswith(f, ".jl"), readdir(dirpath))
        )
        if isempty(files)
            println("  No test files found in $(dirpath).")
            @test false
        else
            for f in files
                @testset "$f" begin
                    filepath = joinpath(dirpath, f)
                    @time begin
                        println("  Including $(filepath)")
                        include(filepath)
                    end
                end
            end
        end
    end
end
