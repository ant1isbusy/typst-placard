
// TODO: change back to preview
#import "@local/placard:0.1.0": placard, card

#show: placard.with(
  title: [Project Title],
  authors: ("Author 1", "Author 2"),
  margin: (top: 3cm),
)

#card(title: "Abstract")[
  #lorem(55)

]

// tip: use #colbreak() to manually jump into next column

