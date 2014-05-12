###*
 * Utility to smooth lines an array of points around bezier segments.
 *
 * @author Adapted from http://stackoverflow.com/a/15528789/1038901
 * @author Christopher Pappas <chris@wintr.us>
 * @date   2.9.14
 *
 * Usage:
 *    # Generic canvas context
 *    context = canvas.getContext('2d')
 *
 *    # EaselJS shape context
 *    shape = new createjs.Shape()
 *    context = shape.graphics
 *
 *    points = [
 *       { x: 0, y: 0}
 *       { x: 20, y: 40 }
 *       { x: 200, y: 90 }
 *    ]
 *
 *    new PointSmoother( @pathCanvas.graphics, @mapPoints )
 *
###


class PointSmoother


   # Default parameters.  Can be overwritten
   # by passing in new params in options hash

   defaults:

      # Reduces the number of points to increase smoothness
      reduction: 5

      # Tension between curved points
      tension: .5

      # Number of bezier segments to draw from
      segments: 15




   # Smooths the connections between n sets of points
   # @param  {Context|Easel.Graphics} ctx     The context which to draw upon
   # @param  {Array} points  An array of points in the form of {x: 0, y: 0}
   # @param  {Object} options Options to overwrite defaults

   constructor: (ctx, points, options) ->
      _.extend @, _.defaults( options = options || @defaults, @defaults )

      @ctx    = ctx
      @points = @flattenPoints points

      #@drawLines @points
      @drawLines @getCurvePoints()



   # Flattens an array Points({x, y}) into a one-dimensional array
   # @param  {Array} points The points to flatten
   # @return {Array}        The flattened points array

   flattenPoints: (points) ->
      flattened = []

      _.each points, (point, index) =>
         if index % @reduction == 0
            flattened.push ~~point.x, ~~point.y

      return flattened



   # Transforms the points array into a curved point set
   # @return {Array} Array of transformed points

   getCurvePoints: =>
      _pts = []
      res  = []

      # Clone
      _pts = @points[..]

      # Copy 1st point and insert at beginning
      _pts.unshift @points[1]
      _pts.unshift @points[0]

      # Copy last point and append
      _pts.push @points[@points.length - 2]
      _pts.push @points[@points.length - 1]


      i = inc = 2

      while i < @points.length - 4

         for t in [0..@segments]

            # Calc tension vectors
            t1x = (_pts[i+2] - _pts[i-2]) * @tension
            t2x = (_pts[i+4] - _pts[i])   * @tension

            t1y = (_pts[i+3] - _pts[i-1]) * @tension
            t2y = (_pts[i+5] - _pts[i+1]) * @tension

            # Calc step
            st = t / @segments;

            # Calc cardinals
            c1 =   2 * Math.pow(st, 3)  - 3 * Math.pow(st, 2) + 1
            c2 = -(2 * Math.pow(st, 3)) + 3 * Math.pow(st, 2)
            c3 =       Math.pow(st, 3)  - 2 * Math.pow(st, 2) + st
            c4 =       Math.pow(st, 3)  -     Math.pow(st, 2)

            # Calc x and y cords with common control vectors
            x = c1 * _pts[i]    + c2 * _pts[i+2] + c3 * t1x + c4 * t2x
            y = c1 * _pts[i+1]  + c2 * _pts[i+3] + c3 * t1y + c4 * t2y

            # Store points in array
            res.push(x)
            res.push(y)

         i += inc

      return res



   # Draws the curve upon the context
   # @param  {Array} pts array of points to draw

   drawLines: (points) ->

      @ctx.moveTo points[0], points[1]

      i = inc = 2

      while i < (points.length - 1)
         @ctx.lineTo points[i], points[i+1]
         i += inc



module.exports = PointSmoother