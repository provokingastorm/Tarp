﻿/**
 * The ProgressBar is similar to the StatusIndicator in that it also displays the status of an event or action using its timeline. However,it is also intended to be used in conjunction with a component or event that generates progress events. By assigning a target and setting its mode appropriately, the ProgressBar component will automatically change its visual state based on the loaded values (bytesLoaded and bytesTotal) of its target.
 	
	<b>Inspectable Properties</b>
	A MovieClip that derives from the ProgressBar component will have the following inspectable properties:<ul>
	<li><i>visible</i>: Hides the component if set to false.</li>
	<li><i>disabled</i>: Disables the component if set to true.</li>
	<li><i>target</i>: The target the ProgressBar will "listen" to, to determine the bytesLoaded and bytesTotal values.</li>
	<li><i>mode</i>: Listening mode of the ProgressBar. In “manual” mode, the progress values must be set using the setProgress method. In "polled" mode, the target must expose bytesLoaded and bytesTotal properties, and in "event" mode, the target must dispatch "progress" events, containing bytesLoaded and bytesTotal properties.</li>
	<li><i>enableInitCallback</i>: If set to true, _global.CLIK_loadCallback() will be fired when a component is loaded and _global.CLIK_unloadCallback will be called when the component is unloaded. These methods receive the instance name, target path, and a reference the component as parameters.  _global.CLIK_loadCallback and _global.CLIK_unloadCallback should be overriden from the game engine using GFx FunctionObjects.</li>
	<li><i>soundMap</i>: Mapping between events and sound process. When an event is fired, the associated sound process will be fired via _global.gfxProcessSound, which should be overriden from the game engine using GFx FunctionObjects.</li></ul>
	
	<b>States</b>
	There are no states for the ProgressBar component. The component’s frames are used to display the status of an event or action. 
	
	<b>Events</b>
	All event callbacks receive a single Object parameter that contains relevant information about the event. The following properties are common to all events. <ul>
	<li><i>type</i>: The event type.</li>
	<li><i>target</i>: The target that generated the event.</li></ul>
		
	The events generated by the ProgressBar component are listed below. The properties listed next to the event are provided in addition to the common properties.<ul>
	<li><i>show</i>: The component’s visible property has been set to true at runtime.</li>
	<li><i>hide</i>: The component’s visible property has been set to false at runtime.</li>
	<li><i>progress</i>: Generated when the ProgressBar value changes.</li>
	<li><i>complete</i>: Generated when the ProgressBar value is equal to its maximum.</li></ul>

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

/*
*/
import flash.external.ExternalInterface; 
import gfx.controls.StatusIndicator;

[InspectableList("disabled", "visible", "mode", "inspectableTarget", "enableInitCallback", "soundMap", "bTriggerSoundsOnEvents")]
class gfx.controls.ProgressBar extends StatusIndicator {
	
// Constants:

// Public Properties:
	/** Mapping between events and sound process **/
	[Inspectable(type="Object", defaultValue="theme:default,progress:progress,complete:complete")]
	public var soundMap:Object = { theme:"default", progress:"progress", complete:"complete" };

// Private Properties:
	private var _mode:String = "manual";
	private var targetClip:Object;
	[Inspectable(type="String", name="target")]
	private var inspectableTarget:String;
	
	
// Initialization:
	/**
	 * The constructor is called when a ProgressBar or a sub-class of ProgressBar is instantiated on stage or by using {@code attachMovie()} in ActionScript. This component can <b>not</b> be instantiated using {@code new} syntax. When creating new components that extend ProgressBar, ensure that a {@code super()} call is made first in the constructor.
	 */
	public function ProgressBar() { super(); }

	
// Public Methods:
	/**
	 * The target the ProgressBar will "listen" to to determine the {@code bytesLoaded} and {@code bytesTotal}. In "polled" mode, the target must expose {@code bytesLoaded} and {@code bytesTotal} properties, and in "event" mode, the target must dispatch "progress" events, containing {@code bytesLoaded} and {@code bytesTotal} properties.
	 * @see #mode
	 */
	public function get target():Object { return targetClip; }
	public function set target(value:Object):Void {
		var newTarget:Object = value;
		if (typeof(value) == "string") {
			newTarget = _parent[value];
		}
		if (newTarget == targetClip) { return; }
		
		if (targetClip.removeEventListener != null) {			
			targetClip.removeEventListener("progress", this, "handleProgress");
			targetClip.removeEventListener("complete", this, "handleComplete");
		}
		
		targetClip = value;
		if (targetClip == null) { return; }
		
		setUpTarget();
	}
	
	/**
	 * Determines how the ProgressBar "listens" for progress changes.
	 	
		Supported Modes:<ol>
	 	<li>"manual": progress values are set using {@code setProgress()}</li>
	 	<li>"polled": The {@code bytestLoaded} and {@code bytesTotal} properties are checked on the {@code target} every frame.</li>
	 	<li>"event": The component listens for {@code progress} and {@code complete} events from the {@code target}</li>
	 	</ol>
	 * @see #setProgress
	 * @see #target
	 */
	[Inspectable(type="list", enumeration="manual,polled,event", defaultValue="manual")]
	public function get mode():String { return _mode; }
	public function set mode(value:String):Void {
		if (value == _mode) { return; }
		_mode = value.toLowerCase();
		setUpTarget();
	}
	
	/**
	 * The percent loaded, which is the {@code value} property, normalized to a number between 0 and 100. 
	 */
	public function get percentLoaded():Number {
		var percentage:Number = ((_value - _minimum) / (_maximum - _minimum)) * 100;
		return percentage; // Need to return a normalized 0-100 value
	}
	
	/**
	 * Set the progress of the component when it is in "manual" mode.
	 * @param loaded The amount loaded.
	 * @param total The total loaded.
	 * @see #mode
	 */
	public function setProgress(loaded:Number, total:Number):Void {
		if (_mode != "manual") { return; }
		var percent:Number = loaded / total;
		setPercent(percent);
	}
		
	/** @exclude */
	public function toString():String {
		return "[Scaleform ProgressBar " + _name + "]";
	}
	
// Private Methods:	
	private function configUI():Void {
		super.configUI();
		if (inspectableTarget != "") {
			target = inspectableTarget;
			inspectableTarget = null;
		}
	}
	/**
	 * Set the value of the component as a percentage.  When the {@code value} changes, a "progress" event is dispatched, and when the {@code value} reaches {@code maximum}, a "complete" event is dispatched.
	 */
	private function setPercent(percent:Number):Void {	
		var newValue:Number = percent * (_maximum - _minimum) + _minimum;
		if (value == newValue) { return; }
		value = newValue;
		dispatchEventAndSound({type:"progress"});
		if (value == _maximum) { dispatchEventAndSound({type:"complete"}); }
	}
	
	private function setUpTarget():Void {
		if (_disabled) { return; }
		// Clean Up Events, etc.
		delete onEnterFrame;
		if (targetClip == null) { return; }
		
		if (targetClip && targetClip.removeEventListener) {
			targetClip.removeEventListener("progress", this, "handleProgress");
			targetClip.removeEventListener("complete", this, "handleComplete");
		}
			
		switch (_mode) {
			case "manual": break;
			case "polled":
				onEnterFrame = pollTarget;
				break;
			case "event":
				if (targetClip.addEventListener != null) {
					targetClip.addEventListener("progress", this, "handleProgress");
					targetClip.addEventListener("complete", this, "handleComplete");
				}
				break;					
		}
	}
	
	private function pollTarget():Void {
		if (target == null || _mode != "polled") { return; }
		setPercent(target.bytesTotal > 0 ? targetClip.bytesLoaded / targetClip.bytesTotal : 0);
	}	
	
	private function handleProgress(event:Object):Void {
		if (_mode != "event") { return; }
		setPercent(event.bytesTotal > 0 ? event.bytesLoaded / event.bytesTotal : 0);
	}
	
	private function handleComplete():Void {
		setPercent(100);
	}

}