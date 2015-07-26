React = require 'react'
_ = require 'underscore'

Snake = require '../snake' # can't require this :(
Row = require '../row'
Cell = require '../cell'
{GRID} = require '../settings'


Grid = React.createClass

  propTypes:
    reset: React.PropTypes.bool.isRequired
    snake: React.PropTypes.any.isRequired
    lost: React.PropTypes.oneOf([true, false, null]).isRequired
    on_collision: React.PropTypes.func.isRequired

  statics:
    out_of_bounds: (snake) ->
      head = snake.head()
      head.x < 0 ||
      head.y < 0 ||
      head.x >= GRID.dimension ||
      head.y >= GRID.dimension

  shouldComponentUpdate: (next_props) ->
    if next_props.lost
      true
    else if next_props.reset
      true
    else
      @props.snake.moving()

  componentWillReceiveProps: (next_props) ->
    # Saving this in @state fails; it won't be "ready" in shouldComponentUpdate
    if !next_props.lost && @constructor.out_of_bounds(next_props.snake)
      @props.on_collision Cell.Wall

  render: ->
    <div className="grid">
      {for row in GRID.range()
        <Row {... @props} row={row} key={"row-#{row}"} />}
    </div>


__GRID__ = null

module.exports =

  html_element: (@_html_element) ->
    @

  render: (props) ->
    if !@_html_element?
      throw new Error("Set HTMLElement html_element before rendering!")
    else if __GRID__?
      throw new Error("Grid's already been rendered!")
    __GRID__ = React.render <Grid {... props}/>, @_html_element

  # This is supposed to be an anti-pattern, but I
  # don't find it difficult to reason about.
  #
  # https://facebook.github.io/react/docs/component-api.html
  set_props: (props, callback) ->
    if !__GRID__?
      throw new Error("Grid hasn't been rendered!")
    __GRID__.setProps(props, callback)