/**
 * Created by Rick on 2022-03-31.
 */
'use strict';

import {csv as d3_csv} from 'd3-fetch'
import {select, selectAll} from 'd3-selection';
import {scaleLinear} from 'd3-scale';
import {extent, max, histogram, nice} from 'd3-array';
import {axisBottom, axisLeft} from 'd3-axis';

export default async function create_histogram(
  chart_id,
  data_array,
  x_min,
  x_max,
  n_bins,
  x_label,
  y_label){

  if(chart_id === undefined){
    throw(new ReferenceError('chart_id argument must be defined.'))
  }

  let data;
  let xAccessor;

  if(data_array !== undefined){
    data = data_array;
    xAccessor = (d) => +d;
  }else {
    throw(new ReferenceError('data_array must be defined.'))
  }

  if(n_bins === undefined){
    n_bins = 10;
  }

  let dimensions = {
    width: 750,
    height: 600,
    margin: {
      top: 10,
      bottom: 50,
      left: 60,
      right: 10
    }
  };
  dimensions.ctrWidth = dimensions.width - dimensions.margin.left - dimensions.margin.right;
  dimensions.ctrHeight = dimensions.height - dimensions.margin.top - dimensions.margin.bottom;

  // Draw image
  select('#' + 'svg_' + chart_id).remove();
  const svg = select('#' + chart_id)
    .append('svg')
    .attr('width', dimensions.width)
    .attr('height', dimensions.height)
    .attr('id', 'svg_' + chart_id);

  const ctr = svg.append('g')
    .attr(
      'transform',
      `translate(${dimensions.margin.left}, ${dimensions.margin.top})`);

  // Axes and Scales
  // X axis: scale and draw
  const x_extent = extent(data, xAccessor)
  let xScale;
  if(x_min === undefined || x_max === undefined){
    const nice_x = nice(x_extent[0], x_extent[1], n_bins);
    x_min = nice_x[0];
    x_max = nice_x[1];
    const width = Math.floor((x_max - x_min)/n_bins);
    x_max = n_bins * width;
    n_bins = (x_max - x_min)/width;
    //console.log(`width: ${width}, n_bins: ${n_bins}`)
  }

  xScale = scaleLinear()
    .domain([x_min, x_max])
    .rangeRound([0, dimensions.ctrWidth]);

  const bin_width = Math.ceil((x_max - x_min) / n_bins)

  const thresholdArr = [];
  for (let i = 0; i < n_bins + 1; i++) {
    thresholdArr[i] = x_min + bin_width * i
  }

  const xAxis = axisBottom(xScale)
    .tickValues(thresholdArr)

  const xAxisGroup = ctr.append('g')
    .call(xAxis)
    .style('transform', `translateY(${dimensions.ctrHeight}px)`)
    //.attr('transform',
    //  `translate(0,${dimensions.ctrHeight})`)

  xAxisGroup.append('text')
    .attr('x', dimensions.ctrWidth / 2)
    .attr('y', dimensions.margin.bottom - 10)
    .attr('fill', 'black')
    .text(x_label)

  const a_histogram = histogram()
    .value(xAccessor)
    .domain(xScale.domain())
    .thresholds(thresholdArr.slice(0, thresholdArr.length - 1));

  const bins = a_histogram(data)

  // Y axis: scale and draw
  const yScale = scaleLinear()
    .domain([0, max(bins, d => d.length)])
    .range([dimensions.ctrHeight, 0]);

  const yAxisGroup = ctr.append('g')
    .call(axisLeft(yScale));

  yAxisGroup.append('text')
    .attr('x', -dimensions.ctrHeight / 2)
    .attr('y', -dimensions.margin.left + 15)
    .attr('fill', 'black')
    .html(y_label)
    .style('transform', 'rotate(270deg)')
    .style('text-anchor', 'middle')

  // Append bar rectangles
  ctr.selectAll('rect')
    .data(bins)
    .join('rect')
    .attr('x', 1)
    .attr('transform', function(d) {
      return `translate(${xScale(d.x0)}, ${yScale(d.length)})`
    })
    .attr('width', function(d) {
      return xScale(d.x1) - xScale(d.x0) - 1
    })
    .attr('height', function(d) {
      return dimensions.ctrHeight - yScale(d.length)
    })
    .style('fill', '#69b3a2')
    return {
      'data_min': x_extent[0],
      'data_max': x_extent[1],
      'x_min': x_min,
      'x_max': x_max,
      'n_bins': n_bins,
      'bin_width': bin_width
    }
}
