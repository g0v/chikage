require! {
  'react': { Component, PropTypes, { svg, g, line }:DOM }:React
  'react/addons': { { PureRenderMixin, classSet:cx }:addons }
}

const buhin-width  = 200
const buhin-height = 200

data =
  id: 'u840c'
  related: 'u840c'
  data:
    * type: 'link'
      src: 'u8279-03'
      leftTop:
        x: 0
        y: 2
      rightBottom:
        x: 200
        y: 175
      data:
        * type: 'line'
          head: 'free'
          tail: 'free'
          controlPoints:
            * x: 13
              y: 39
            * x: 187
              y: 39
        * type: 'line'
          head: 'free'
          tail: 'free'
          controlPoints:
            * x: 72
              y: 13
            * x: 72
              y: 64
        * type: 'line'
          head: 'free'
          tail: 'free'
          controlPoints:
            * x: 128
              y: 13
            * x: 128
              y: 64
    ...

compose-buhin = ({
  key,
  x = 0, y = 0,
  width = buhin-width, height = buhin-height,
  data
}) ->
  ratio-x = width  / buhin-width
  ratio-y = height / buhin-height
  g do
    key: key
    transform: "matrix(#{ratio-x}, 0, 0, #{ratio-y}, #{x}, #{y})"
    for key, op of data
      switch op.type
        | 'line' =>
          [{ x: x1, y: y1 }, { x: x2, y: y2 }] = op.controlPoints
          style =
            stroke: \black
            stroke-width: 1
          line { key, x1, y1, x2, y2, style }
        | 'link' =>
          { leftTop: { x, y }, rightBottom: { x: ex, y: ey }, data } = op
          width  = ex - x
          height = ey - y
          compose-buhin { key, x, y, width, height, data }

class App extends Component implements PureRenderMixin
  (@props) ->
  render: ~>
    { className = '', children = [] } = @props
    svg do
      width:  400
      height: 400
      viewBox: "0 0 #buhin-width #buhin-height"
      compose-buhin data

module.exports = App

