# Resume source

The PDF at the repo root (`../resume.pdf`) is built from these files with [Typst](https://typst.app).

- `content.yaml` — all the words. Edit this.
- `resume.typ` — layout only.
- `fonts/` — Montserrat Regular/SemiBold/Bold (SIL Open Font License, see `fonts/OFL.txt`), bundled so every machine builds the same PDF.

## Build

Install Typst 0.14+ (`brew install typst`, `winget install --id Typst.Typst`, `cargo install typst-cli`, or grab a binary from the [releases page](https://github.com/typst/typst/releases)). Then, from this folder:

```sh
# public copy for GitHub (ATS layout, no phone number)
typst compile --font-path fonts resume.typ ../resume.pdf

# for applications: add your phone number (passed in, never stored in the repo)
typst compile --font-path fonts --input phone="(208) 555-0100" resume.typ resume-apply.pdf

# the "people" version: 3-column skills grid, softer summary
typst compile --font-path fonts --input variant=people resume.typ resume-people.pdf
```

`typst watch` instead of `typst compile` rebuilds on every save.

PDFs built inside this folder are git-ignored so the phone-number copy never gets committed by accident.

## Check what an ATS sees

```sh
pdftotext ../resume.pdf - | head -40
```

Section names should come out as plain words (`EXPERIENCE`, not `E X P E R I E N C E`), bullets in order, nothing missing. The heading letter-spacing is set to 0.25em on purpose: at 0.4em and above, `pdftotext` starts splitting the headings into separate letters.
