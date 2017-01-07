
{AnimatedValue} = require "Animated"
{Style} = require "react-validators"

emptyFunction = require "emptyFunction"
View = require "modx/lib/View"
modx = require "modx"

revealedStyle = {position: "relative", opacity: 1}
concealedStyle = {position: "absolute", opacity: 0}

type = modx.Type "Layer"

type.defineArgs
  render: Function.or Object

type.defineValues (render) ->

  _root: null

  _index: null

  _style: revealedStyle

  __renderLayer: if @__renderLayer is emptyFunction then render

type.defineGetters

  index: -> @_index

type.addMixin Hideable,

  isHiding: no

  show: ->
    @_style = revealedStyle
    @_root?.setNativeProps {style: revealedStyle}

  hide: ->
    @_style = concealedStyle
    @_root?.setNativeProps {style: concealedStyle}

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
    ref: (view) => @_root = view
    style: [@props.style, @_style]
    children: @__renderLayer()

module.exports = type.build()
