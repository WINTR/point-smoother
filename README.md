Point Smoother
==============

Create smooth, bezier-like curves between n number of points.  (Meaning, if one were to pass in a set of points representing a pentagon shape, the hard angles between each vertex would be smoothed creating a softer result.)

Usage
------

```
# Pass in a generic canvas context
context = canvas.getContext('2d')

# ...or an EaselJS shape context
shape = new createjs.Shape()
context = shape.graphics

points = [
   { x: 0, y: 0}
   { x: 20, y: 40 }
   { x: 200, y: 90 }
]

options =

  # Reduces the number of points to increase smoothness
  reduction: 5

  # Tension between curved points
  tension: .5

  # Number of bezier segments to draw from
  segments: 15

new PointSmoother(context, points, options)
```


Thanks
------
This utility was adapted from http://stackoverflow.com/a/15528789/1038901