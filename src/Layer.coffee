
{AnimatedValue} = require "Animated"
{Style} = require "react-validators"
{View} = require "modx/views"
{Type} = require "modx"

emptyFunction = require "emptyFunction"

revealedStyle = {position: "relative", opacity: 1}
concealedStyle = {position: "absolute", opacity: 0}

type = Type "Layer"

type.defineArgs
  render: Function

type.defineValues (render) ->

  _index: null

  _style: revealedStyle

  _view: null

  __renderLayer: if @__renderLayer is emptyFunction then render

type.defineGetters

  index: -> @_index

type.addMixin Hideable,

  isHiding: no

  show: ->
    @_style = revealedStyle
    @_view?.setNativeProps {style: revealedStyle}

  hide: ->
    @_style = concealedStyle
    @_view?.setNativeProps {style: concealedStyle}

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
  @_element = View
    ref: (view) => @_view = view
    style: [@props.style, @_style]
    children: @__renderLayer()

module.exports = type.build()
