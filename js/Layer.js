var AnimatedValue, Style, View, concealedStyle, emptyFunction, modx, revealedStyle, type;

AnimatedValue = require("Animated").AnimatedValue;

Style = require("react-validators").Style;

emptyFunction = require("emptyFunction");

View = require("modx/lib/View");

modx = require("modx");

revealedStyle = {
  position: "relative",
  opacity: 1
};

concealedStyle = {
  position: "absolute",
  opacity: 0
};

type = modx.Type("Layer");

type.defineArgs({
  render: Function.or(Object)
});

type.defineValues(function(render) {
  return {
    _root: null,
    _index: null,
    _style: revealedStyle,
    __renderLayer: this.__renderLayer === emptyFunction ? render : void 0
  };
});

type.defineGetters({
  index: function() {
    return this._index;
  }
});

type.addMixin(Hideable, {
  isHiding: false,
  show: function() {
    var ref;
    this._style = revealedStyle;
    return (ref = this._root) != null ? ref.setNativeProps({
      style: revealedStyle
    }) : void 0;
  },
  hide: function() {
    var ref;
    this._style = concealedStyle;
    return (ref = this._root) != null ? ref.setNativeProps({
      style: concealedStyle
    }) : void 0;
  }
});

type.defineHooks({
  __renderLayer: emptyFunction
});

type.defineProps({
  style: Style
});

type.shouldUpdate(function() {
  return false;
});

type.render(function() {
  return this._element = View({
    ref: (function(_this) {
      return function(view) {
        return _this._root = view;
      };
    })(this),
    style: [this.props.style, this._style],
    children: this.__renderLayer()
  });
});

module.exports = type.build();

//# sourceMappingURL=map/Layer.map
