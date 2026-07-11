# test/references.jl — Stage 1 of the two-stage citation check (design: WilsonNRG.jl
# / QAtlas.jl). Every paper cited in a `src/` docstring — by journal, volume,
# first-page — must resolve to an entry in docs/references.bib; keys are unique;
# every entry carries a well-formed DOI. Catches a dangling / mistyped / fabricated
# citation OFFLINE, on every PR. Pairs with Stage 2 (.github/workflows/
# VerifyReferences.yml, `doiget verify`: every bib DOI resolves upstream); both read
# the `REFERENCES_BIB` path, so they never disagree on which file is canonical.
#
# Convention: commission each method from a published paper and cite it in the src/
# docstring precisely — e.g. `Phys. Rev. B 66, 045114 (2002)` — then add the matching
# doi2bib-quality entry to docs/references.bib. A fresh package that cites nothing yet
# passes trivially; the check bites the moment you cite a paper.

using MyModule, Test

function references_bib_path()
    return get(ENV, "REFERENCES_BIB", joinpath(pkgdir(MyModule), "docs", "references.bib"))
end

# (key, volume, first-page, doi) for each @entry in the .bib.
function bib_entries(path::AbstractString)
    entries = NamedTuple{
        (:key, :vol, :page, :doi),Tuple{String,Union{Int,Nothing},Union{Int,Nothing},String}
    }[]
    key = ""
    vol = nothing
    page = nothing
    doi = ""
    flush!() = isempty(key) || push!(entries, (; key, vol, page, doi))
    for line in eachline(path)
        m = match(r"^@\w+\{\s*([^,\s]+)\s*,", line)
        if m !== nothing
            flush!()
            key = String(m.captures[1])
            vol = nothing
            page = nothing
            doi = ""
            continue
        end
        v = match(r"volume\s*=\s*\{(\d+)\}", line)
        v !== nothing && (vol = parse(Int, v.captures[1]))
        p = match(r"pages\s*=\s*\{0*(\d+)", line)
        p !== nothing && (page = parse(Int, p.captures[1]))
        d = match(r"doi\s*=\s*\{([^}]+)\}", line)
        d !== nothing && (doi = String(d.captures[1]))
    end
    flush!()
    return entries
end

# (volume, first-page) cited in any src/ docstring, keyed on a journal token so stray
# numbers ("Eq. (3)", "arXiv:1101.5895") never match.
function src_citations()
    pat = r"(?:PRB|PRL|RMP|Rev\. ?Mod\. ?Phys\.|Phys\. ?Rev\. ?Lett\.|Phys\. ?Rev\. ?B|Phys\. ?Rev\.|J\. ?Phys\.:? ?Condens\.? ?Matter)\s+(\d+),?\s+0*(\d+)\s+\((\d{4})\)"
    srcdir = joinpath(pkgdir(MyModule), "src")
    cited = Set{Tuple{Int,Int}}()
    for f in readdir(srcdir; join=true)
        endswith(f, ".jl") || continue
        for mt in eachmatch(pat, read(f, String))
            push!(cited, (parse(Int, mt.captures[1]), parse(Int, mt.captures[2])))
        end
    end
    return cited
end

@testset "references.bib integrity (citation check, stage 1)" begin
    path = references_bib_path()
    @test isfile(path)
    entries = bib_entries(path)

    # ---- bibliography well-formed: unique keys, every entry a well-formed DOI ----
    keys = [e.key for e in entries]
    @test length(unique(keys)) == length(keys)                       # no duplicate keys
    @testset "every entry has a well-formed DOI" begin
        for e in entries
            @test !isempty(e.doi)
            @test occursin(r"^10\.\d{4,9}/\S+$", e.doi)              # well-formed DOI
        end
    end

    # ---- every paper cited in src/ has a matching bib entry (volume, first-page) ----
    # A fresh package cites nothing yet ⇒ vacuously satisfied; enforced as methods accrue.
    bibvp = Set((e.vol, e.page) for e in entries if e.vol !== nothing && e.page !== nothing)
    cited = src_citations()
    missing_refs = filter(vp -> !(vp in bibvp), collect(cited))
    if isempty(cited)
        @info "citation check: no src/ citations yet — cite each commissioned method's paper here"
    elseif !isempty(missing_refs)
        @info "src citations with no references.bib entry (volume, page)" missing_refs
    end
    @test isempty(missing_refs)
end
