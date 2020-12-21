# feathers-openfl
Unofficial port of Feathers UI Framework. Currently based on Feathers 2.2.0.

[HTML5 version of ComponentExplorer](https://match08.github.io/feathers-openfl/examples/ComponentsExplorer/bin/html5/bin/)

Install
-------

    haxelib install openfl
    haxelib install starling 1.8.15
    haxelib git https://github.com/match08/feathers-openfl

Dependencies:

  [starling-openfl and its dependent libraries](https://github.com/openfl/starling-openfl)

Current Limitations
-------------------

* Currently only works on HTML5 and Node.js.
* Current does not work correctly on original version of OpenFL and lime.
* Only Next version of OpenFL is supported.
* ScrollText doesn't work correctly.
* TextInput doesn't work correctly.
* Numeric Stepper is still buggy on HTML5.
* TextBlockTextRenderer is not supported.
* On HTML5, Texts are rendered with TextFieldTextRenderer.
  * Texts on html5 may look diffrent from that of native targets.
* On native targets, Texts are rendered with BitmapFontTextRenderer.
  * Outline fonts are rendered with FreeType renderer implemented top of BitmapFont.
* If you move the mouse cursor outside of the window, touch processor still think that cursor is inside.
