// lib.typ

// Internal states for global access
#let _placard-colors = state("placard-colors", (:))
#let _placard-sizes = state("placard-sizes", (:))
#let _placard-fonts = state("placard-fonts", (:))

// ------------------------------------------
// THEMES
// 
#let _default-themes = (
  light: (
    paper-fill: rgb("#f7f3ed"), 
    card-fill: rgb("#ffffff"),  
    card-border: rgb("#d9c7c7"),
    title: rgb("#1a1a1a"),      
    heading: rgb("#1a1a1a"),
    text: rgb("#1a1a1a"),
    accent: rgb("#1a1a1a"),
    footer-text: rgb("#535755"),
  ),
  dark: (
    paper-fill: rgb("#1a1a1a"), 
    card-fill: rgb("#141414"),  
    card-border: rgb("#3f3f3f"),
    title: rgb("#ffffff"),      
    heading: rgb("#ffffff"),
    text: rgb("#ffffff"),
    accent: rgb("#fffdfe"),
    footer-text: rgb("#808080"),
  )
)

// ------------------------------------------
// SIZES
// 
#let _default-sizes = (
  title: 65pt,
  authors: 22pt,
  body: 20pt,
  h2: 36pt,
  h3: 28pt,
  card-body: 20pt,
  footer: 24pt,
)

// ------------------------------------------
// FONTS
// 
#let _default-fonts = (
  title: "sans",
  authors: "sans",
  body: "sans",
  headings: "sans",
  card: "sans",
  footer: "sans",
)

// ------------------------------------------
// PLACARD element
// 
#let placard(
  title: "Poster Title",
  authors: (),
  scheme: "light",
  paper: "a1", 
  num-columns: 2,
  gutter: 1.5em,
  scaling: 1.0,
  colors: (:), 
  sizes: (:),
  fonts: (:),
  footer: (
    content: [],
    logo: none,
    logo-placement: right,
    text-placement: left,
  ),
  body,
) = {
  let c = _default-themes.at(scheme) + colors 
  let f = _default-fonts + fonts
  
  let base-s = _default-sizes + sizes
  let s = (:)
  for (k, v) in base-s {
    s.insert(k, v * scaling)
  }

  set page(
    paper: paper,
    margin: (top: 3.5cm, bottom: 6cm, x: 2.5cm),
    fill: c.paper-fill,
    footer: [
      #set text(font: f.footer, size: s.footer, fill: c.footer-text)
      #line(length: 100%, stroke: 2pt + c.accent)
      #v(0.5em)
      #grid(
        columns: (1fr, 1fr, 1fr),
        align(footer.text-placement + horizon, footer.content),
        align(center + horizon, if footer.text-placement == center { footer.content }),
        align(footer.logo-placement + horizon, if footer.logo != none { footer.logo }),
      )
    ],
  )

  set text(font: f.body, weight: "light", size: s.body, fill: c.text)
  set par(justify: true)

  show heading.where(level: 1): it => [
    #set align(center)
    #set text(font: f.title, size: s.title, weight: "bold", fill: c.title)
    #it
    #line(length: 100%, stroke: 3pt + c.accent)
  ]

  show heading.where(level: 2): set text(font: f.headings, fill: c.heading, size: s.h2, weight: "semibold")
  show heading.where(level: 3): set text(font: f.headings, fill: c.accent, size: s.h3, weight: "semibold")

  _placard-colors.update(c)
  _placard-sizes.update(s)
  _placard-fonts.update(f)

  heading(level: 1, title)
  grid(
    columns: authors.map(_ => 1fr),
    gutter: 1em,
    ..authors.map(a => align(center, text(font: f.authors, size: s.authors, weight: "bold", a)))
  )
  v(1.5em)

  columns(num-columns, gutter: gutter, body)
}

// ------------------------------------------
// CARD Element
// 
#let card(title: "", fill: none, border-stroke: none, gap: none, body) = {
  context {
    let c = _placard-colors.get()
    let s = _placard-sizes.get()
    let f = _placard-fonts.get()
    
    let card-bg = if fill != none { fill } else if c != (:) { c.card-fill } else { white }
    let card-stroke = if border-stroke != none { border-stroke } else if c != (:) { c.card-border } else { gray }

    block(
      fill: card-bg,
      width: 100%,
      inset: 2em, 
      radius: 13pt,
      stroke: 2pt + card-stroke, 
      [
        #if title != "" {
          heading(level: 2, title)
          v(0.5em)
        }
        #set text(font: f.card, weight: "regular", size: s.card-body)
        #body
      ],
    )
    v(if gap != none {gap} else {1em})
  }
}