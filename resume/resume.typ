// Elijah Walker — resume
// Content lives in content.yaml; this file is layout only.
//
// Build (from this folder):
//   typst compile --font-path fonts resume.typ ../resume.pdf
//   typst compile --font-path fonts --input variant=people resume.typ resume-people.pdf
//   typst compile --font-path fonts --input phone="(208) 555-0100" resume.typ resume-apply.pdf
//
// ATS notes baked into this layout:
//   - single reading order top to bottom; the only side-by-side block is the
//     optional "people" skills grid, which is emitted column by column
//   - real text everywhere (no icons, no images, no text in shapes)
//   - standard section names, dates with month + year on both ends
//   - Typst writes ToUnicode maps and a tagged PDF by default, so the text layer
//     extracts cleanly (check with: pdftotext resume.pdf -)

#let data = yaml("content.yaml")
#let variant = sys.inputs.at("variant", default: "ats")
// The phone number is passed at build time so it never lands in this public repo.
#let phone = sys.inputs.at("phone", default: none)
#let cv = data.variants.at(variant)

// ---- design tokens ----
#let ink = rgb("#111111")
#let muted = rgb("#3a3a3a")
#let rule-color = rgb("#111111")
#let body-size = 8.8pt
#let TRACK = float(sys.inputs.at("track", default: "0.25")) * 1em
#let SECTION-GAP = 3.9em
#let sep = h(0.6em) + text(fill: muted)[|] + h(0.6em)

#set document(
  title: data.name + " – Resume",
  author: data.name,
  keywords: ("resume", "machine learning", "AI", "cloud computing"),
)
#set page(paper: "us-letter", margin: (x: 0.5in, top: 0.5in, bottom: 0.5in))
#set text(font: "Montserrat", size: body-size, fill: ink, lang: "en", hyphenate: false)
#set par(leading: 0.6em, spacing: 0.6em, justify: false)
#set list(marker: [•], indent: 1.1em, body-indent: 0.45em, spacing: 0.7em)
#show link: set text(fill: ink)

// ---- building blocks ----
#let section(title, body, first: false) = block(
  above: if first { 0em } else { SECTION-GAP },
  below: 0em,
  width: 100%,
  {
    block(below: 0.9em, {
      text(size: 7.4pt, weight: "bold", tracking: TRACK, upper(title))
      v(-0.15em)
      line(length: 100%, stroke: 0.6pt + rule-color)
    })
    body
  },
)

#let entry(heading, sub, bullets, first: false) = block(above: if first { 0em } else { 1.6em }, below: 0em, breakable: false, {
  text(weight: "bold", size: 9.4pt, heading)
  linebreak()
  text(weight: "semibold", size: 8.4pt, sub)
  if bullets.len() > 0 {
    v(0.2em)
    list(..bullets.map(b => [#b]))
  }
})

// ---- header ----
#align(right, {
  text(size: 20pt, weight: "bold", tracking: 0.05em, upper(data.name))
  v(0.15em)
  set text(size: 8.2pt, weight: "semibold")
  set par(leading: 0.65em)
  let c = data.contact
  let line1 = ()
  if phone != none { line1.push(phone) }
  line1.push(link("mailto:" + c.email, c.email))
  line1.push(c.location)
  line1.join(sep)
  linebreak()
  c.links.map(l => link(l.url, l.label)).join(sep)
})

// ---- summary ----
#v(2.6em)
#section("Summary", first: true, pad(left: 1.1em, cv.summary))

// ---- skills ----
#section("Skills", pad(left: 1.1em, if cv.skills_layout == "columns" {
  grid(
    columns: (1fr,) * cv.skills.len(),
    column-gutter: 1em,
    ..cv.skills.map(g => {
      text(weight: "semibold", g.group)
      list(marker: [·], indent: 0em, body-indent: 0.35em, spacing: 0.5em, ..g.items.map(i => [#i]))
    })
  )
} else {
  stack(spacing: 0.7em, ..cv.skills.map(g => [
    #text(weight: "semibold", g.group + ":") #g.items.join(", ")
  ]))
}))

// ---- education ----
#section("Education", for e in data.education {
  block(breakable: false, {
    text(weight: "bold", size: 9.4pt, e.degree)
    linebreak()
    text(weight: "semibold", size: 8.4pt, ((e.school,) + e.details).join(sep))
    v(0.2em)
    pad(left: 1.1em, stack(spacing: 0.65em, ..e.lines.map(l => [
      #text(weight: "semibold", l.label + ":") #l.text
    ])))
  })
})

// ---- experience ----
#section("Experience", for (i, x) in data.experience.enumerate() {
  entry(x.title, [#x.org, #x.location#sep#x.dates], x.bullets, first: i == 0)
})

// ---- projects ----
#section("Projects", for (i, p) in data.projects.enumerate() {
  entry(p.name, p.stack, p.bullets, first: i == 0)
})
