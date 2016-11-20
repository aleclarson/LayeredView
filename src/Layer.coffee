
{AnimatedValue} = require "Animated"
{Style} = require "react-validators"
{View} = require "modx/views"
{Type} = require "modx"

type = Type "Layer"

type.defineOptions
  render: Function

type.defineValues (options) ->

  _render: options.render

  _index: null

type.defineAnimatedValues

  opacity: 1

type.defineGetters

  index: -> @_index

type.addMixin Hideable,

  isHiding: no

  show: ->
    @opacity.set 1

  hide: ->
    @opacity.set 0

#
# Rendering
#

type.defineProps
  style: Style

type.shouldUpdate ->
  return no

type.render ->

  style = flattenStyle @props.style
  style ?= {}
  style.opacity = @opacity

  return @_element = View
    style: style
    children: @_render()

module.exports = type.build()
