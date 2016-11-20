
{Component} = require "modx"
{View} = require "modx/views"

assertType = require "assertType"

Layer = require "./Layer"

type = Component "LayeredView"

type.defineValues ->

  _index: -1

  _layers: []

  _elements: []

type.defineGetters

  index: -> @_index

type.definePrototype

  layer:
    get: -> @_layers[@_index]
    set: (layer, oldLayer) ->
      assertType layer, Layer
      oldLayer.hide() if oldLayer
      if layer.index is null
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
    @_elements[index] ?= @_layers[index].render {style}

module.exports = type.build()
