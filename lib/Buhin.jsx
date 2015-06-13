import React from 'react';
import { assign } from 'lodash';

var { Component, PropTypes, DOM: { svg, g, line, path } } = React;

const buhinWidth  = 200;
const buhinHeight = 200;
const vectorEffect = 'non-scaling-stroke';
const composeBuhin = function composeBuhin({
  id, src,
  x = 0, y = 0,
  width = buhinWidth, height = buhinHeight,
  data
}) {
  var ratioX = width  / buhinWidth;
  var ratioY = height / buhinHeight;
  var children = [];

  for(let key in data) {
    let op = data[key];
    switch(op.type) {
      case 'line':
        var [{ x: x1, y: y1 }, { x: x2, y: y2 }] = op.controlPoints;
        var style = {
          vectorEffect,
          stroke: 'black',
          strokeWidth: 1,
        };
        children.push(<line {...{ key, x1 , y1, x2, y2, style }} />);
        break;
      case 'vert-slash':
        var [
          { x: x0, y: y0 },
          { x: x1, y: y1 },
          { x: x2, y: y2 },
          { x: x3, y: y3 }
        ] = op.controlPoints;
        var style = {
          vectorEffect,
          stroke: 'black',
          strokeWidth: 1,
          fill: 'transparent'
        };
        children.push(
          <path
            key={key}
            d={`M${x0} ${y0} C ${x1} ${y1}, ${x2} ${y2}, ${x3} ${y3}`}
            style={style}
          />
        );
        break;
      case 'link':
        // XXX: babel will not shadow arguments x and y,
        //      so use x0 and y0 for now.
        var { leftTop: { x: x0, y: y0 }, rightBottom: { x: ex, y: ey } } = op;
        var width  = ex - x0;
        var height = ey - y0;
        children.push(composeBuhin(assign({ x: x0, y: y0, width, height }, op)));
        break;
      default:
        console.log('unknown op: ', op);
        children.push(null);
    };
  };

  return (
    <g
      key={id || src}
      transform={`matrix(${ratioX}, 0, 0, ${ratioY}, ${x}, ${y})`}
    >{children}</g>
  );
};

class Buhin extends Component {
  // The props will be changed without modified the root, so one should not use
  // PureRenderMixin in this component.
  static defaultProps = {
    width:  400,
    height: 400
  };
  render() {
    var {
      children = [],
      width, height,
      id, related, data
    } = this.props;
    return (
      <svg
        width={width}
        height={height}
        viewBox={`0 0 ${buhinWidth} ${buhinHeight}`}
      >{
        composeBuhin({ id, related, data })
      }</svg>
    );
  }
}

export default Buhin;

