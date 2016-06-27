# Outdated?

It appears that this is now handled by a native property on UITableView and UICollectionView, although I haven't investigated.

```Swift
var remembersLastFocusedIndexPath: Bool
```
---------------------------------------

# FocusGuideTest
Focus back on the previously selected UITableViewCell.

When you navigate away from a UITableView and then back again, it doesn't put you back on the last cell you were on. 
This was not the behaviour I expected or needed, so in this mini test project is code that solves that problem.

There is a table view on the left hand side, and various focusable elements on the right hand side (collection view, and a couple of buttons). 
When navigating from the table view to the buttons, and back, you should notice that you end up back on your original cell.

## How it works

It works by creating a very thin focusable layer (focus guide) and placing it to the right hand side of the table view, between it and the other focusable elements.
The focus guide catches the focus events between these elements and then there is some logic for deciding which cell should be active and highlighted and for passing the focus event along the chain.

## About

This is a tvOS project using Swift.
