
{Component} = require "modx"
{View} = require "modx/views"

assertType = require "assertType"
Null = require "Null"

Layer = require "./Layer"

type = Component "LayeredView"

type.defineStatics {Layer}

type.defineValues ->

  _index: -1

  _layers: []

  _elements: []

type.defineListeners ->

  if isType @props.layer, AnimatedValue
    @props.layer.didSet (layer, oldLayer) =>

      assertType layer, LayeredView.propTypes.layer
      return if layer is oldLayer

      if oldLayer
        oldLayer.hide()

      if layer is null
        @_index = -1
        return

      if layer.index is null
        layer._index = -1 + @_layers.push layer
        @_index = layer._index
        @_elements.push null
        try @forceUpdate()
      else
        @_index = layer._index
        layer.show()
      return

#
# Rendering
#

type.defineProps
  layer: Layer.Kind.or Null
  style: Style
  layerStyle: Style

type.render ->
  @_renderLayer @_index, @props.layerStyle
  return View
    style: @props.style
    children: @_elements

type.defineMethods

  _renderLayer: (index, style) ->
    if index >= 0
      @_elements[index] ?= @_layers[index].render {style}
    return

module.exports = LayeredView = type.build()
