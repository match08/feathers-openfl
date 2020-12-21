package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_sourcesanspro_regular_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_sourcesanspro_semibold_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy39:assets%2Fimages%2Fmetalworks_mobile.xmly4:sizei7193y4:typey4:TEXTy2:idR1y7:preloadtgoR0y39:assets%2Fimages%2Fmetalworks_mobile.pngR2i75568R3y5:IMAGER5R7R6tgoR2i149508R3y4:FONTy9:classNamey47:__ASSET__assets_fonts_sourcesanspro_regular_ttfR5y42:assets%2Ffonts%2FSourceSansPro-Regular.ttfR6tgoR2i149352R3R9R10y48:__ASSET__assets_fonts_sourcesanspro_semibold_ttfR5y43:assets%2Ffonts%2FSourceSansPro-Semibold.ttfR6tgoR0y27:assets%2Fimages%2Fskull.pngR2i1315R3R8R5R15R6tgoR0y33:assets%2Fimages%2Fskull-white.pngR2i1240R3R8R5R16R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_metalworks_mobile_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_metalworks_mobile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_regular_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_semibold_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_skull_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_skull_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("../../themes/MetalWorksMobileTheme/assets/images/metalworks_mobile.xml") @:noCompletion #if display private #end class __ASSET__assets_images_metalworks_mobile_xml extends haxe.io.Bytes {}
@:keep @:image("../../themes/MetalWorksMobileTheme/assets/images/metalworks_mobile.png") @:noCompletion #if display private #end class __ASSET__assets_images_metalworks_mobile_png extends lime.graphics.Image {}
@:keep @:font("bin/html5/obj/webfont/SourceSansPro-Regular.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_regular_ttf extends lime.text.Font {}
@:keep @:font("bin/html5/obj/webfont/SourceSansPro-Semibold.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_semibold_ttf extends lime.text.Font {}
@:keep @:image("assets/images/skull.png") @:noCompletion #if display private #end class __ASSET__assets_images_skull_png extends lime.graphics.Image {}
@:keep @:image("assets/images/skull-white.png") @:noCompletion #if display private #end class __ASSET__assets_images_skull_white_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_fonts_sourcesanspro_regular_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_regular_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/SourceSansPro-Regular"; #else ascender = 984; descender = -273; height = 1257; numGlyphs = 1114; underlinePosition = -100; underlineThickness = 50; unitsPerEM = 1000; #end name = "Source Sans Pro"; super (); }}
@:keep @:expose('__ASSET__assets_fonts_sourcesanspro_semibold_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_semibold_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/SourceSansPro-Semibold"; #else ascender = 984; descender = -273; height = 1257; numGlyphs = 1114; underlinePosition = -100; underlineThickness = 50; unitsPerEM = 1000; #end name = "Source Sans Pro Semibold"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_fonts_sourcesanspro_regular_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_sourcesanspro_regular_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_sourcesanspro_regular_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_fonts_sourcesanspro_semibold_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_sourcesanspro_semibold_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_sourcesanspro_semibold_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_fonts_sourcesanspro_regular_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_sourcesanspro_regular_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_sourcesanspro_regular_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_fonts_sourcesanspro_semibold_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_sourcesanspro_semibold_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_sourcesanspro_semibold_ttf ()); super (); }}

#end

#end
#end

#end
