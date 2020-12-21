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

		data = '{"name":null,"assets":"aoy4:sizei7193y4:typey4:TEXTy9:classNamey44:__ASSET__assets_images_metalworks_mobile_xmly2:idy39:assets%2Fimages%2Fmetalworks_mobile.xmlgoR0i75568R1y5:IMAGER3y44:__ASSET__assets_images_metalworks_mobile_pngR5y39:assets%2Fimages%2Fmetalworks_mobile.pnggoR0i149508R1y4:FONTR3y47:__ASSET__assets_fonts_sourcesanspro_regular_ttfR5y42:assets%2Ffonts%2FSourceSansPro-Regular.ttfgoR0i149352R1R10R3y48:__ASSET__assets_fonts_sourcesanspro_semibold_ttfR5y43:assets%2Ffonts%2FSourceSansPro-Semibold.ttfgoR0i1315R1R7R3y32:__ASSET__assets_images_skull_pngR5y27:assets%2Fimages%2Fskull.pnggoR0i1240R1R7R3y38:__ASSET__assets_images_skull_white_pngR5y33:assets%2Fimages%2Fskull-white.pnggh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_metalworks_mobile_xml extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_metalworks_mobile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_regular_ttf extends flash.text.Font { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_semibold_ttf extends flash.text.Font { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_skull_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_skull_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends flash.utils.ByteArray { }


#elseif (desktop || cpp)

@:keep @:file("../../themes/MetalWorksMobileTheme/assets/images/metalworks_mobile.xml") @:noCompletion #if display private #end class __ASSET__assets_images_metalworks_mobile_xml extends haxe.io.Bytes {}
@:keep @:image("../../themes/MetalWorksMobileTheme/assets/images/metalworks_mobile.png") @:noCompletion #if display private #end class __ASSET__assets_images_metalworks_mobile_png extends lime.graphics.Image {}
@:keep @:font("../../themes/MetalWorksMobileTheme/assets/fonts/SourceSansPro-Regular.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_regular_ttf extends lime.text.Font {}
@:keep @:font("../../themes/MetalWorksMobileTheme/assets/fonts/SourceSansPro-Semibold.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_semibold_ttf extends lime.text.Font {}
@:keep @:image("assets/images/skull.png") @:noCompletion #if display private #end class __ASSET__assets_images_skull_png extends lime.graphics.Image {}
@:keep @:image("assets/images/skull-white.png") @:noCompletion #if display private #end class __ASSET__assets_images_skull_white_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_fonts_sourcesanspro_regular_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_regular_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/SourceSansPro-Regular.ttf"; #else ascender = null; descender = null; height = null; numGlyphs = null; underlinePosition = null; underlineThickness = null; unitsPerEM = null; #end name = "Source Sans Pro"; super (); }}
@:keep @:expose('__ASSET__assets_fonts_sourcesanspro_semibold_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_sourcesanspro_semibold_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/SourceSansPro-Semibold.ttf"; #else ascender = null; descender = null; height = null; numGlyphs = null; underlinePosition = null; underlineThickness = null; unitsPerEM = null; #end name = "Source Sans Pro Semibold"; super (); }}


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
