require! {
  'react': { Component, PropTypes, { svg, g, line, path }:DOM }:React
  'react/addons': { { PureRenderMixin, classSet:cx }:addons }
}

const buhin-width  = 200
const buhin-height = 200
const compose-buhin = ({
  id, src,
  x = 0, y = 0,
  width = buhin-width, height = buhin-height,
  data
}) ->
  ratio-x = width  / buhin-width
  ratio-y = height / buhin-height
  g do
    key: id or src
    transform: "matrix(#{ratio-x}, 0, 0, #{ratio-y}, #{x}, #{y})"
    for key, op of data
      switch op.type
        | 'line' =>
          [{ x: x1, y: y1 }, { x: x2, y: y2 }] = op.controlPoints
          style =
            stroke: \black
            stroke-width: 1
          line { key, x1, y1, x2, y2, style }
        | 'vert-slash' =>
          [
            { x: x0, y: y0 },
            { x: x1, y: y1 },
            { x: x2, y: y2 },
            { x: x3, y: y3 }
          ] = op.controlPoints
          style =
            stroke: \black
            stroke-width: 1
            fill: \transparent
          path do
            key: key
            d: "M#x0 #y0 C #x1 #y1, #x2 #y2, #x3 #y3"
            style: style
        | 'link' =>
          { leftTop: { x, y }, rightBottom: { x: ex, y: ey } } = op
          width  = ex - x
          height = ey - y
          compose-buhin { x, y, width, height } <<< op
        | otherwise =>
          console.log 'unknown op: ', op

class Buhin extends Component
  # The props will be changed without modified the root, so one should not use
  # PureRenderMixin in this component.
  @defaultProps =
    width:  400
    height: 400
  (@props) ->
  render: ~>
    {
      className = '', children = [],
      width, height,
      id, related, data
    } = @props
    svg do
      width:  width
      height: height
      viewBox: "0 0 #buhin-width #buhin-height"
      compose-buhin { id, related, data }

module.exports = Buhin

