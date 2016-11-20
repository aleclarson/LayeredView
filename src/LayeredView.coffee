
{Component} = require "modx"
{View} = require "modx/views"

assertType = require "assertType"

Layer = require "./Layer"

type = Component "LayeredView"

type.defineValues ->

  _index: -1

  _layers: []

  _elements: []

type.defineListeners ->

  if isType @props.layer, AnimatedValue
    @props.layer.didSet (layer, oldLayer) =>
      assertType layer, Layer.Kind
      oldLayer.hide() if oldLayer
      if layer is null
        @_index = -1
      else if layer.index is null
        @_index = -1 + @_layers.push layer
        @_elements.push null
        try @forceUpdate()
      else
        @_index = layer.index
        layer.show()
      return

#
# Rendering
#

type.defineProps
  layer: Layer.Kind
  style: Style
  layerStyle: Style

type.render ->
  return View
    style: @props.style
    children: @_renderLayers()

type.defineMethods

  _renderLayers: ->
    @_renderLayer @_index, @props.layerStyle
    return @_elements

  _renderLayer: (index, style) ->
    if index >= 0
      @_elements[index] ?= @_layers[index].render {style}
    return

module.exports = type.build()
