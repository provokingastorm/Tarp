﻿/**
 * The ButtonBar is similar to the ButtonGroup although it has a visual representation. It is also able to create Button instances on the fly based on a DataProvider. The ButtonBar is useful for creating dynamic tab-bar like UI elements.
 
	<b>Inspectable Properties</b>
 	Although the ButtonBar component has no content (represented simply as a small circle on the Stage in Flash Studio), it does contain several inspectable properties. The majority of them deal with the placement settings of the Button instances created by the ButtonBar.<ul>
	<li><i>visible</i>: Hides the ButtonBar if set to false.</li>
	<li><i>disabled</i>: Disables the ButtonBar if set to true.</li>
	<li><i>itemRenderer</i>: Linkage ID of the Button component symbol. This symbol will be instantiated as needed based on the data assigned to the ButtonBar.</li>
	<li><i>direction</i>: Button placement. Horizontal will place the Button instances side-by-side, while vertical will stack them on top of each other.</li>
    <li><i>spacing</i>: The spacing between the Button instances. Affects only the current direction (see direction property).</li>
	<li><i>autoSize</i>: Determines if child buttons will scale to fit the text that it contains and which direction to align the resized buttons. Setting the autoSize property to {@code autoSize="none"} will leave the buttons' current size unchanged.</li>
	<li><i>buttonWidth</i>: Sets a common width to all Button instances. If autoSize is set to true this property is ignored.</li>
	<li><i>enableInitCallback</i>: If set to true, _global.CLIK_loadCallback() will be fired when a component is loaded and _global.CLIK_unloadCallback will be called when the component is unloaded. These methods receive the instance name, target path, and a reference the component as parameters.  _global.CLIK_loadCallback and _global.CLIK_unloadCallback should be overriden from the game engine using GFx FunctionObjects.</li></ul>
	
	<b>States</b>
	The CLIK ButtonBar does not have any visual states because its managed Button components are used to display the group state.
	
	<b>Events</b>
		All event callbacks receive a single Object parameter that contains relevant information about the event. The following properties are common to all events. <ul>
		<li><i>type</i>: The event type.</li>
		<li><i>target</i>: The target that generated the event.</li></ul>
		
	The events generated by the ButtonBar component are listed below. The properties listed next to the event are provided in addition to the common properties.<ul>
	<li><i>show</i>: The component’s visible property has been set to true at runtime.</li>
	<li><i>hide</i>: The component’s visible property has been set to false at runtime.</li>
	<li><i>focusIn</i>: The component has received focus.</li>
	<li><i>focusOut</i>: The component has lost focus.</li>
	<li><i>change</i>: A new button from the group has been selected.</li><ul>
		<li><i>index</i>: The selected index of the ButtonBar. Number type. Values 0 to number of buttons minus 1.</li>
		<li><i>renderer</i>: The selected Button. CLIK Button type.</li>
		<li><i>item</i>: The selected item from the dataProvider. AS2 Object type.</li>
		<li><i>data</i>: The data value of the selected dataProvider item. AS2 Object type.</li></ul></li>
	<li><i>itemClick</i>: A button in the group has been clicked.</li><ul>
		<li><i>index</i>: The ButtonBar index of the Button that was clicked. Number type. Values 0 to number of buttons minus 1. </li>
		<li><i>item</i>: The selected item from the dataProvider. AS2 Object type.</li>
		<li><i>data</i>: The data value of the selected dataProvider item. AS2 Object type.</li>
		<li><i>controllerIdx</i>: The index of the mouse cursor used to generate the event (applicable only for multi-mouse-cursor environments). Number type. Values 0 to 3.</li></ul></li></ul>
 
*/

/**********************************************************************
 Copyright (c) 2009 Scaleform Corporation. All Rights Reserved.

 Portions of the integration code is from Epic Games as identified by Perforce annotations.
 Copyright © 2010 Epic Games, Inc. All rights reserved.
 
 Licensees may use this file in accordance with the valid Scaleform
 License Agreement provided with the software. This file is provided 
 AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE WARRANTY OF DESIGN, 
 MERCHANTABILITY AND FITNESS FOR ANY PURPOSE.
**********************************************************************/

import gfx.controls.Button;
import gfx.core.UIComponent;
import gfx.data.DataProvider;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

[InspectableList("disabled", "visible", "itemRenderer", "spacing", "autoSize", "buttonWidth", "direction", "enableInitCallback", "bTriggerSoundsOnEvents")]
class gfx.controls.ButtonBar extends UIComponent {
	
// Constants:

// Public Properties:

// Private Properties:
	private var _dataProvider:Object;
	private var _itemRenderer:String = "Button";
	private var _spacing:Number = 0;
	private var _direction:String = "horizontal";
	private var _selectedIndex:Number = -1;
	private var _autoSize:String = "none";
	private var _buttonWidth:Number = 0;
	private var _labelField:String = "label";
	private var _labelFunction:Function;
	private var renderers:Array;
	private var reflowing:Boolean = false;
	
// UI Elements:
	

// Initialization:
	/**
	 * The constructor is called when a ButtonBar or a sub-class of ButtonBar is instantiated on stage or by using {@code UIComponent.createInstance()} in ActionScript. This component can <b>not</b> be instantiated using {@code new} syntax. When creating new components that extend ButtonBar, ensure that a {@code super()} call is made first in the constructor.
	 */
	public function ButtonBar() { 
		super();
		renderers = [];
		focusEnabled = tabEnabled = !_disabled;
		tabChildren = false;
	}

// Public Methods:
	[Inspectable(defaultValue="false")]
	public function get disabled():Boolean { return _disabled; } 
	public function set disabled(value:Boolean):Void {
		super.disabled = value;
		focusEnabled = tabEnabled = !_disabled;
		if (!initialized) { return; }
		for (var i:Number=0; i<renderers.length; i++) {
			renderers[i].disabled = _disabled;
		}
	}

	/**
	 * The list of buttons to display. Unlike list-based components, this is just an Array.  The Array can contain Objects or Strings, and the {@code itemToLabel} method will determine the resulting text label for each button.
	 * @see #itemToLabel
	 */
	public function get dataProvider():Object { return _dataProvider; }
	public function set dataProvider(value:Object):Void {
		if (_dataProvider == value) { return; }
		if (_dataProvider != null) {
			_dataProvider.removeEventListener("change", this, "onDataChange");
		}
		_dataProvider = value;
		if (_dataProvider == null) { return; }
		
		// LM: I recommend that we move this check to the DataProvider.initialize(), and change it so it takes a second parameter (component instance).
		if ((value instanceof Array) && !value.isDataProvider) { 
			DataProvider.initialize(_dataProvider);
		} else if (_dataProvider.initialize != null) {
			_dataProvider.initialize(this);
		}
		
		_dataProvider.addEventListener("change", this, "onDataChange");  // Do a full redraw
		selectedIndex = 0;
		tabEnabled = focusEnabled = !_disabled && (_dataProvider.length > 0);
		
		reflowing = false;
		invalidate();
	}
	
	public function invalidateData():Void {
		selectedIndex = Math.min(_dataProvider.length-1, _selectedIndex);
		populateData();
		invalidate();
	}
	
	/**
	 * Set the linkage for each itemRenderer. When the linkage changes, the ButtonBar will be redrawn.
	 */
	[Inspectable(defaultValue="Button")]
	public function get itemRenderer():String { return _itemRenderer; }
	public function set itemRenderer(value:String):Void {
		_itemRenderer = value;
		// Empty button list so it redraws.
		while (renderers.length > 0) { renderers.pop().removeMovieClip(); }
		invalidate();
	}
	
	/**
	 * The spacing between each item in pixels. Spacing can be set to a negative value to overlap items.
	 */
	[Inspectable(defaultValue="0")]
	public function get spacing():Number { return _spacing; }
	public function set spacing(value:Number):Void {
		_spacing = value;
		invalidate();
	}
	
	/**
	 * The direction the buttons draw. When the direction is set to "horizontal", the buttons will draw on the same y-coordinate, with the {@code spacing} between each instance.  When the direction is set to "vertical", the buttons will draw with the same x-coordinate, with the {@code spacing} between each instance.
	 * @see #spacing
	 */
	[Inspectable(defaultValue="horizontal", type="list", enumeration="horizontal,vertical")]
	public function get direction():String { return _direction; }
	public function set direction(value:String):Void {
		_direction = value;
		invalidate();
	}
	
	/**
	 * Determines if the buttons auto-size to fit their label. This parameter will only be applied if the {@code itemRenderer} supports it.
	 */
	[Inspectable(type="String", enumeration="none,left,center,right", defaultValue="none")]
	public function get autoSize():String { return _autoSize; }
	public function set autoSize(value:String):Void {
		if (value == _autoSize) { return; }
		_autoSize = value;
		for (var i:Number=0; i<renderers.length; i++) {
			renderers[i].autoSize = _autoSize;
		}
		invalidate();
	}	
	
	/**
	 * The width of each button.  Overrides the {@code autoSize} property when set.  Set to 0 to let the component auto-size.
	 */
	[Inspectable(defaultValue="0")]
	public function get buttonWidth():Number { return _buttonWidth; }
	public function set buttonWidth(value:Number):Void {
		_buttonWidth = value;
		invalidate();
	}
	
	/**
	 * The 0-base index of the selected button. The ButtonBar can have a single selected item in its {@code dataProvider}, represented by the {@code selectedIndex}. When the {@code selectedIndex} changes, a "change" event is dispatched.
	 */
	public function get selectedIndex():Number { return _selectedIndex; }
	public function set selectedIndex(value:Number):Void {
		if (_selectedIndex == value) return;
		_selectedIndex = value;
		selectItem(_selectedIndex);
		dispatchEventAndSound({type:"change", index:_selectedIndex, renderer:renderers[_selectedIndex], item:selectedItem, data:selectedItem.data});
	}
	
	/**
	 * The item at the {@code selectedIndex} in the DataProvider.
	 */
	public function get selectedItem():Object { return _dataProvider.requestItemAt(_selectedIndex); }
	
	/**
	 * The {@code data} property of the {@code selectedItem}.
	 * @see Button#data
	 */
	public function get data():Object { return selectedItem.data; }
	
	/**
	 * The name of the field in the {@code dataProvider} model to be displayed as the label for itemRenderers.  A {@code labelFunction} will be used over a {@code labelField} if it is defined.
	 */
	public function get labelField():String { return _labelField; }
	public function set labelField(value:String):Void {
		_labelField = value;
		invalidate();
	}
	
	/**
	 * The function used to determine the label for itemRenderers. A {@code labelFunction} will override a {@code labelField} if it is defined.
	 */
	public function get labelFunction():Function { return _labelFunction; }
	public function set labelFunction(value:Function):Void {
		_labelFunction = value;
		invalidate();
	}
	
	/**
	 * Convert an item to a label string using the {@code labelField} and {@code labelFunction}. If the item is not an object, then it will be converted to a string, and returned.
	 * @param item The item to convert to a label.
	 * @returns The converted label string.
	 * @see #labelField
	 * @see #labelFunction
	 */
	public function itemToLabel(item:Object):String {
		if (item == null) { return ""; }
		if (_labelFunction != null) {
			return _labelFunction(item);
		} else if (_labelField != null && item[_labelField] != null) {
			return item[_labelField];
		}
		return item.toString();
	}
	
	public function handleInput(details:InputDetails, pathToFocus:Array):Boolean {		
		var keyPress:Boolean = (details.value == "keyDown" || details.value == "keyHold");
		
		var newIndex:Number; 
		switch (details.navEquivalent) {
			case NavigationCode.LEFT:
				if (_direction == "horizontal") {
					newIndex = _selectedIndex-1;
				}
				break;
			case NavigationCode.RIGHT:
				if (_direction == "horizontal") {
					newIndex = _selectedIndex+1;
				}
				break;
			case NavigationCode.UP:
				if (_direction == "vertical") {
					newIndex = _selectedIndex-1;
				}
				break;
			case NavigationCode.DOWN:				
				if (_direction == "vertical") {
					newIndex = _selectedIndex+1;
				}
				break;
		}
		if (newIndex != null) {
			newIndex = Math.max(0, Math.min(_dataProvider.length-1, newIndex));			
			if (newIndex != _selectedIndex) { 
				if (!keyPress) { return true; }
				selectedIndex = newIndex;
				return true;
			}
		}
		return false;
	}	
	
	/** @exclude */
	public function toString():String {
		return "[Scaleform ButtonBar " + _name + "]";
	}
	
	
// Private Methods:	
	private function draw():Void {
		if (!reflowing) {
			// Update current buttons
			var l:Number = _dataProvider.length;
			while (renderers.length > l) {
				var r:MovieClip = MovieClip(renderers.pop());
				r.group.removeButton(r);	
				r.removeMovieClip();
			}		
			while (renderers.length < l) {		
				renderers.push(createRenderer(renderers.length));
			}
		
			populateData();
			reflowing = true;
			invalidate();
			return;
		}
		if (drawLayout() && _selectedIndex != -1) {
			selectItem(_selectedIndex);
		}		
	}
	
	private function drawLayout():Boolean {
		// If the (last) renderer is not yet ready, invalidate to force a redraw.
		if (renderers.length > 0 && !renderers[renderers.length-1].initialized) {
			reflowing = true;
			invalidate();
			return false;
		}
		reflowing = false;
		
		var w:Number = 0;
		var h:Number = 0;
		for (var i:Number=0; i<renderers.length; i++) {
			var renderer:MovieClip = renderers[i];
			// Manually size the renderer
			if (!_autoSize && _buttonWidth > 0) {				
				renderer.width = _buttonWidth;
			}
			
			if (_direction == "horizontal") {
				renderer._y = 0;
				renderer._x = w;
				w += renderer.width + _spacing;
			} else {
				renderer._x = 0;
				renderer._y = h;
				h += renderer.height + _spacing;
			}
		}
		return true;
	}
	
	private function createRenderer(index:Number):MovieClip {
		var renderer:MovieClip = UIComponent.createInstance(this, itemRenderer, "clip"+index, index, {toggle:true, focusTarget:this, tabEnabled:false, autoSize:_autoSize});
		if (renderer == null) { return null; }
		renderer.addEventListener("click", this, "handleItemClick");
		renderer["index"] = index;
		
		// This assumes linkage is a Button, or has Button in its inheritance chain.
		renderer.groupName = _name+"ButtonGroup";

		return renderer;
	}
	
	private function handleItemClick(event:Object):Void {
		var renderer:MovieClip = event.target;
		var index:Number = renderer.index;
		selectedIndex = index;
		dispatchEventAndSound({type:"itemClick", data:selectedItem.data, item:selectedItem, index:index, controllerIdx:event.controllerIdx});
	}
	
	private function selectItem(index:Number):Void {
		if (renderers.length < 1) { return; }
		var renderer:MovieClip = renderers[index];		
		if (!renderer.selected) { renderer.selected = true; }
		
		var l:Number = renderers.length;
		for (var i:Number=0; i<l; i++) {
			if (i == index) { continue; }
			var depth:Number = 100 + l-i;
			renderers[i].swapDepths(depth);
			renderers[i].displayFocus = false;
		}
		renderer.swapDepths(1000); // Put the item on the top depth. Note that "i+1" breaks other things.
		renderer.displayFocus = _focused;
	}
	
	private function changeFocus():Void {
		var renderer:MovieClip = renderers[_selectedIndex];
		if (renderer == null) { return; }
		renderer.displayFocus = _focused;
	}
	
	private function onDataChange(event:Object):Void {
		invalidateData();
	}
	
	private function populateData():Void {
		for (var i:Number = 0; i < renderers.length; i++) {
			var renderer:MovieClip = renderers[i];
			renderer.label = itemToLabel(_dataProvider.requestItemAt(i));
			renderer.data = _dataProvider.requestItemAt(i);
			renderer.disabled = _disabled;
		}		
	}
}
