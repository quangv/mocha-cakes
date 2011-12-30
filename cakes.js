(function() {
  var colors, depict, func, name, _ref;
  var __slice = Array.prototype.slice;

  colors = require('colors');

  exports.Feature = function() {
    var callback, feature, message, part, story, _i, _j, _len;
    feature = arguments[0], story = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
    message = ("Feature: " + feature + " \n\n").green.underline;
    for (_j = 0, _len = story.length; _j < _len; _j++) {
      part = story[_j];
      message += '\t' + part + '\n';
    }
    describe(message, callback);
  };

  depict = function(label, args) {
    if (args.length === 1) {
      args[1] = args[0];
      label = '';
    }
    return describe(label.replace('%s', args[0]), args[1]);
  };

  exports.Background = function(action, callback) {
    return depict(action.magenta, arguments);
  };

  exports.Scenario = function() {
    return depict("\n    Scenario: %s".green, arguments);
  };

  exports.Given = function() {
    return depict("Given:".yellow + " %s", arguments);
  };

  exports.When = function() {
    return depict(" When:".yellow + " %s", arguments);
  };

  exports.And = function() {
    return depict("  and".grey + "  %s", arguments);
  };

  exports.Then = function() {
    return depict(" Then:".yellow + " %s", arguments);
  };

  exports.But = function() {
    return depict("  But".yellow + "  %s", arguments);
  };

  exports.Spec = function() {
    return depict('%s'.blue, arguments);
  };

  _ref = module.exports;
  for (name in _ref) {
    func = _ref[name];
    global[name] = func;
  }

}).call(this);
