
/* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.unity3d;

import pony.DeltaTime;
import pony.events.LV.LV;
import pony.Rect.Rect;
import pony.WordWrap;
import unityengine.Color;
import unityengine.GameObject;
import unityengine.GUIText;
import unityengine.GUITexture;
import unityengine.Input;
import unityengine.Rect;
import unityengine.Screen;
import unityengine.Texture;
import unityengine.Vector3;

using hugs.HUGSWrapper;

/**
 * Tooltip
 * @author AxGord
 * @author BoBaH6eToH
 */

class Tooltip {
	
	public static var border:Single = 5;
	public static var textObject:GameObject;
	private static var textureObject:GameObject;
	private static var guiTextObject:GUIText;
	private static var guiTextureObject:GUITexture;
	public static var r:Rect;
	public static var lr:Rect;
	
	public static var longTextObject:GameObject;
	public static var guiLongTextObject:GUIText;
	
	public static var texture:Texture;
	public static var defaultColorMod:LV<Color> = new LV(null);
	public static var panel:Bool = false;
	
	private static var target:Dynamic;
		
	private static function init():Void {
		
		textureObject = new GameObject("GUIText Tooltip Texture");
		guiTextureObject = cast textureObject.AddComponent('GUITexture');
		guiTextureObject.texture = texture;
		
		textObject = new GameObject("GUIText Tooltip");
		textObject.transform.position = new Vector3(0.5, 0.5);
		guiTextObject = cast textObject.AddComponent('GUIText');
		guiTextObject.material.color = new Color(0, 0, 0);
		//guiTextObject.font = cast Resources.Load('ARIAL');
		guiTextObject.fontSize = 14;
		
		longTextObject = new GameObject("GUIText Tooltip");
		longTextObject.transform.position = new Vector3(0.5, 0.5);
		guiLongTextObject = cast longTextObject.AddComponent('GUIText');
		guiLongTextObject.material.color = new Color(0, 0, 0);
		guiLongTextObject.fontSize = 10;
			
			
	}
	
	public static function showText(text:String, bigText:String, obj:Dynamic, layer:Null<Int>, ?panel:Bool = false):Void {
		target = obj;
		if (textObject == null) {
			init();
		}
		Tooltip.panel = panel;
		if (layer != null) {
			textObject.layer = layer;
			textureObject.layer = layer;
			longTextObject.layer = layer;
		}
				
		guiTextObject.enabled = true;
		guiTextureObject.enabled = true;
		
		
		guiTextObject.text = WordWrap.wordWrap(text, bigText == "" ? 30 : 50);
		
		//formatGuiTextArea(guiTextObject, 100);
		
		r = guiTextObject.GetScreenRect();
		
		var w = panel ? Fixed2dCamera.SIZE : Screen.width - Fixed2dCamera.SIZE;
		var h = Screen.height;
		
		if ( bigText != "" )
		{
			guiLongTextObject.enabled = true;
			guiLongTextObject.text = WordWrap.wordWrap(bigText, 75);	
			lr = guiLongTextObject.GetScreenRect();
			r.height += lr.height;
			r.width = Math.max(r.width, lr.width);
		} else
			guiLongTextObject.enabled = false;
		guiTextureObject.pixelInset = new Rect(w / 2 - border, h / 2 - r.height - border, -w + r.width + border * 2, -h + r.height + border * 2);
			
		if (panel) {
			DeltaTime.update.add(moveTextPanel);
			moveTextPanel();
		} else {
			DeltaTime.update.add(moveText);
			moveText();			
		}
	}
	
	private static function moveTextPanel():Void {
		textObject.transform.position = new Vector3(1 - (Screen.width - Input.mousePosition.x + r.width/2) / Fixed2dCamera.SIZE, (Input.mousePosition.y+r.height + border*2)/Screen.height, 500);
		textureObject.transform.position = new Vector3(1 - (Screen.width - Input.mousePosition.x + r.width / 2) / Fixed2dCamera.SIZE, (Input.mousePosition.y + r.height + border * 2) / Screen.height, 499);
		//longTextObject.transform.position = new Vector3(1 - (Screen.width - Input.mousePosition.x + lr.width / 2) / Fixed2dCamera.SIZE, (Input.mousePosition.y + lr.height + border * 2) / Screen.height, 499);
	}
	
	private static function moveText():Void {
		textObject.transform.position = new Vector3((Input.mousePosition.x - r.width/2)/ (Screen.width - Fixed2dCamera.SIZE), (Input.mousePosition.y+r.height + border*2) / Screen.height, 500);
		textureObject.transform.position = new Vector3((Input.mousePosition.x - r.width / 2) / (Screen.width - Fixed2dCamera.SIZE), (Input.mousePosition.y + r.height + border * 2) / Screen.height, 499);
		longTextObject.transform.position = new Vector3((Input.mousePosition.x - r.width/2)/ (Screen.width - Fixed2dCamera.SIZE), (Input.mousePosition.y+r.height + border*2 - 15) / Screen.height, 500);
	}
	
	public static function hideText(obj:Dynamic):Void {
		if (target != obj) return;
		if (textObject == null) return;
		guiTextObject.enabled = false;
		guiTextureObject.enabled = false;
		guiLongTextObject.enabled = false;
		DeltaTime.update.remove(moveText);
		DeltaTime.update.remove(moveTextPanel);
	}
	/*
	private function OnGUI() {
		if (overed > 0) {
			GUILayout.BeginArea(new Rect(Input.mousePosition.x, Screen.height - Input.mousePosition.y, Screen.width, Screen.height));
			GUILayout.FlexibleSpace();
			GUILayout.Box(text);
			//GUILayout.FlexibleSpace();
			GUILayout.EndArea();
		}
	}
	*/
}