
{AnimatedValue} = require "Animated"
{Style} = require "react-validators"
{View} = require "modx/views"
{Type} = require "modx"

emptyFunction = require "emptyFunction"

type = Type "Layer"

type.defineOptions
  render: Function

type.defineValues (options) ->

  __renderLayer: options.render if @__renderLayer is emptyFunction

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

type.defineHooks

  __renderLayer: emptyFunction

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
    children: @__renderLayer()

module.exports = type.build()
