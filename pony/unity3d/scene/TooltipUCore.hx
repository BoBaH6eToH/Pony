package pony.unity3d.scene;

import pony.DeltaTime;
import pony.unity3d.scene.MouseHelper;
import unityengine.BoxCollider;
import unityengine.Color;
import unityengine.MonoBehaviour;
import pony.unity3d.Tooltip;
import unityengine.Texture;
import unityengine.Transform;

using hugs.HUGSWrapper;

/**
 * TooltipUCore
 * @author AxGord <axgord@gmail.com>
 * @author BoBaH6eToH
 */

class TooltipUCore extends MonoBehaviour {

	public var text:String = 'tooltip';
	public var bigText:String = '';
	public var colorMod:Color;
	public var texture:Texture;
	
	private var savedColors:Array<Color>;
	
	private var subs:Bool;
	private var subObjects:Array<Transform>;
	private var ovr:MouseHelper;
	
	private function Start():Void {
		if (colorMod == null || (colorMod.r == 0 && colorMod.g == 0 && colorMod.b == 0)) {
			if (Tooltip.defaultColorMod.value != null)
				colorMod = Tooltip.defaultColorMod.value;
			else
				Tooltip.defaultColorMod.add(onDCL);
		} else
			Tooltip.defaultColorMod.value = colorMod;
		if (Tooltip.texture == null) Tooltip.texture = texture;
		
		var it:NativeArrayIterator<Transform> = cast gameObject.getComponentsInChildrenOfType(Transform);
		subObjects = [for (e in it) if (e != transform && e.renderer != null) e];
		subs = subObjects.length > 0;
		
		if (!subs) {
			subObjects = [transform];
		}
		
		
		
		ovr = getOrAddTypedComponent(MouseHelper);
		ovr.over.add(over);
		ovr.out.add(out);
		ovr.middleUp.add(pressOut);
		ovr.middleDown.add(press);
		
		saveColors();
	}
	
	public function saveColors():Void {
		savedColors = [];
		for (e in subObjects) savedColors.push(e.renderer.material.color);
	}
	
	private function onDCL(cl:Color):Void {
		colorMod = cl;
	}
	
	private function over():Void {
		try {
			if (MouseHelper.middleMousePressed)
				Tooltip.showText(text, bigText, this, gameObject.layer);
			else
				Tooltip.showText(text, "", this, gameObject.layer);
			lightUp();
		} catch (_:Dynamic) {}
	}
	
	public function out():Void {
		try {
			Tooltip.hideText(this);
			lightDown();
		} catch (_:Dynamic) {}
	}
	
	private function pressOut():Void
	{		
		Tooltip.showText(text, "", this, gameObject.layer);
	}
	
	private function press():Void
	{
		Tooltip.showText(text, bigText, this, gameObject.layer);
	}
	
	public function lightUp():Void {
		for (e in subObjects) {
			try {
				var sColor = e.renderer.material.color;
				e.renderer.material.color = new Color(sColor.r + colorMod.r, sColor.g + colorMod.g, sColor.b + colorMod.b);
			} catch (_:Dynamic) {}
		}
	}
	
	public function lightDown():Void {
		var i:Int = 0;
		for (e in subObjects) {
			try {
				e.renderer.material.color = savedColors[i++];
			} catch (_:Dynamic) {}
		}
	}
	
}