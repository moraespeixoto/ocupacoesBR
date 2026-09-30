# Comments for CRAN submission

This is a resubmission.

## Response to the review of 0.8.1

The manual review of 0.8.1 (Konstanze Lauseker, 2026-09-28) asked: "please
provide an English title and description in addition to the Portuguese
one." Both the `Title` and `Description` fields now contain the Portuguese
text followed by "English: " and an English translation. For `Description`
this follows the precedent of the CRAN package `datos` (Riva Quiroga),
whose `Description` ends with "English: It provides a Spanish translated
version..."; we applied the same convention to `Title`, which `datos` does
not do. `Language: pt-BR` remains declared. The `Title` is longer than the
recommended 65 characters only because it is bilingual, as requested.

## Response to the review of 0.8.0

The manual review of 0.8.0 (Leonore Hochhauser, 2026-09-17) asked for two
corrections. 0.8.1 addressed the first in full and the second only for the
object named explicitly; 0.8.2 completes the second for all 61 exported
functions.

- **References in `Description`.** The field now cites, in the format
  `authors (year) <doi:...>` and `(year, ISBN:...)`, the works that
  describe each method: Ganzeboom and Treiman (1996)
  <doi:10.1006/ssre.1996.0010>, Treiman (1977, ISBN:0-12-698750-5),
  Erikson, Goldthorpe and Portocarero (1979) <doi:10.2307/589632>,
  Ganzeboom, De Graaf and Treiman (1992) <doi:10.1016/0049-089X(92)90017-B>,
  and Peixoto (2026) <doi:10.31235/osf.io/b29kg_v1>. The DOIs were checked
  against Crossref.
- **`\value` explaining structure and meaning, in every exported
  function.** CRAN named only `tse_codigos_autorrotulo.Rd` explicitly,
  which had no `\value` at all (it documents a constant, not a function);
  0.8.1 fixed that one. But CRAN's request was more general — "explain the
  functions results ... write about the structure of the output (class)
  and also what the output means" — and a sweep of all 61 function help
  pages found 41 with a `\value` section that was present but shallow,
  stating only the R class ("Numeric vector.") without its meaning. 0.8.2
  expands all 41.

## Verification

`R CMD check --as-cran` on the final 0.8.2 tarball, x86_64-pc-linux-gnu
(Ubuntu 26.04), R 4.6.1: **0 ERROR, 0 WARNING, 2 NOTEs.** Tests pass with
no failure and no skip, and the vignettes rebuild.

The check was also run in a library with none of the suggested packages
(`testthat`, `knitr`, `rmarkdown`, `readxl`): the package installs, loads and
translates normally, and the examples on every help page run without error.
No exported function depends on a suggested package. In that library the
test suite and the vignettes naturally do not run, because `testthat` and
`knitr` are exactly what is missing there.

## The two NOTEs

**1. "New submission"**, from `checking CRAN incoming feasibility` — this is
the package's first submission.

**2. `checking HTML version of manual`** — the local check machine does not
have `tidy` installed, and the check reports that it skipped HTML
validation. This is a property of the machine, not of the package; it does
not occur on CRAN's own machines.

### What used to appear, and why it no longer does

**The three URLs with 404 status**, up to 0.7.0. The repository was private
while the package went through review, and CRAN's checker is anonymous: both
repository URLs and the documentation site URL returned 404 to any visitor.
On 2026-09-09 the repository was made public and GitHub Pages started
serving <https://moraespeixoto.github.io/ocupacoesBR/>. All three now
resolve, and the NOTE no longer occurs — the `URL` and `BugReports` fields
in `DESCRIPTION` are unchanged.

**The LaTeX error in the PDF manual**, in 0.8.0 itself, before this
submission. Three occurrences of the mathematical minus sign (U+2212) in a
passage of `?tse_para_isei` reporting negative coefficients made `pdflatex`
stop with "Unicode character not set up for use with LaTeX", producing a
WARNING and an ERROR. They were replaced with an ASCII hyphen, which is what
LaTeX expects and reads the same to the eye.

**"Suggests or Enhances not in mainstream repositories: DIGCLASS"**, up to
0.5.2. `DIGCLASS` (Cimentada) is an independent implementation of the same
ISMF syntax, used for a cross-check of the EGP scheme — the package's only
validation against code that is neither its own nor from the source it
itself reads.

It is not distributed through any repository — not CRAN, not Bioconductor,
not r-universe. It installs from the GitHub HEAD. `Additional_repositories:`
therefore does not apply, since that field requires a CRAN-format repository
with a `PACKAGES` index, and keeping it in `Suggests` made `R CMD check`
return

```
* checking package dependencies ... ERROR
Package suggested but not available: 'DIGCLASS'
```

on any machine that did not have it installed, which includes CRAN's.

Since 0.6.0, `DIGCLASS` has been removed from `Suggests` and the test that
uses it (`tests/testthat/test-digclass.R`) is listed in `.Rbuildignore`: it
remains in the repository and runs in development, but does not travel with
the distributed package, which does not mention `DIGCLASS` anywhere. The
version and commit against which the cross-check was performed are recorded
in `inst/extdata/PROVENIENCIA.yml`, section `conferencia_cruzada`.

**"The Title field should be in title case"**, up to 0.2.1. This was not a
defect in the title: the checker applied English capitalization conventions
to a Portuguese sentence, whose convention is the opposite. From 0.3.0
onward, `DESCRIPTION` declares `Language: pt-BR`, as CRAN policy asks for a
package that is not in English, and the warning stopped occurring.
Declaring the language was the right fix; capitalizing "Ao", "Em" and "Da"
would have produced an ungrammatical title.

## Maintainer's e-mail

The `Authors@R` field carries `moraespeixoto@gmail.com`, a personal address,
rather than the author's institutional one. This is deliberate, for a
single reason: it is the address that survives a change of institutional
affiliation. The channel through which CRAN reaches the maintainer needs to
keep working ten years from now, and a university address dies with the
affiliation — the package would then lose its channel and be archived for
silence. The author's ORCID, in the same field, links the package to the
public record where the institutional affiliation can be verified.

## Third-party material

The package redistributes, in `inst/extdata/fontes/`, the published SPSS
syntax files of the International Stratification and Mobility File
(Ganzeboom & Treiman) and a copy of the official occupation conversion table
of Brazil's Ministry of Labor.

They ship with the package **out of methodological necessity**: no data
table is typed by hand, all of them are generated by script from these
sources, and the test suite checks the tables against them line by line,
plus the `sha256` of each file. Without the embedded sources, that check
cannot run in the CRAN check environment.

Authorship and terms are stated in `LICENSE.note`, which also ships with the
package. The ISMF syntax files are distributed by their authors for public
research use, with an explicit request for citation, which
`citation("ocupacoesBR")` satisfies: it returns the package **and** the
references for the scales. The Ministry of Labor table is public
administrative data, produced and published by a Brazilian government
agency.

## Dependencies

Only `stats` and `utils` (base R). No compiled code.
