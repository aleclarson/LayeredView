
assertType = require "assertType"
View = require "modx/lib/View"
Null = require "Null"
modx = require "modx"

Layer = require "./Layer"

type = modx.Component "LayeredView"

type.defineStatics {Layer}

type.defineValues ->

  _index: -1

  _layers: []

  _elements: []

type.defineListeners ->
  if @props.layer instanceof AnimatedValue
    @props.layer.didSet (layer, oldLayer) =>
      assertType layer, LayeredView.propTypes.layer
      @_onLayerChange layer, oldLayer

#
# Prototype
#

type.defineGetters

  layer: ->
    if layer = @props.layer
      if layer instanceof AnimatedValue
      then layer.get()
      else layer
    else null

type.defineMethods

  _onLayerChange: (layer, oldLayer) ->

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
  style: Style
  layer: Layer.Kind.or Null
  layerStyle: Style

type.render ->
  @_renderLayer @_index, @props.layerStyle
  return View
    style: @props.style
    children: @_elements

type.willMount ->
  @_onLayerChange @layer, null

type.defineMethods

  _renderLayer: (index, style) ->
    if index >= 0
      @_elements[index] ?= @_layers[index].render {style}
    return

module.exports = LayeredView = type.build()
