﻿import gfx.controls.ListItemRenderer;
import gfx.utils.Constraints;

/**
 * The default itemRenderer for the List component.  The {@link IListItemRenderer} interface defines the required API for itemRenderers.
 */
 

class com.scaleform.ComplexListItemRenderer extends ListItemRenderer {
	
	public var textField1:TextField;
	public var textField2:TextField;
	
	public function ComplexListItemRenderer() { super(); }
	
	public function setData(data:Object):Void {
		this.data = data;
		textField1.text = data.id.toString();
		textField2.text = data.name;
	}	

	public function setSize(width:Number, height:Number):Void {
		var w:Number = (_autoSize) ? calculateWidth() : width;
		super.setSize(w, height);
	}	
	
	private function configUI():Void {		
		super.configUI();

		constraints.addElement(textField1, Constraints.ALL);
		constraints.addElement(textField2, Constraints.ALL);
		
		updateAfterStateChange();
	}	
	
	private function updateAfterStateChange():Void {
		// Redraw should only happen AFTER the initialization.
		if (!initialized) { return; }
		validateNow();// Ensure that the width/height is up to date.
		
		textField1.text = data.id.toString();
		textField2.text = data.name;
		
		if (constraints != null) { 
			constraints.update(width, height);
		}
		dispatchEvent({type:"stateChange", state:state});
	}	
	
	private function calculateWidth():Number {
		var metrics1:Object = constraints.getElement(textField1).metrics;
		var metrics2:Object = constraints.getElement(textField2).metrics;
		var w:Number = textField1.textWidth + textField2.textWidth + metrics1.left + metrics1.right + metrics2.left + metrics2.right + 5;
		return w;
	}	
	
}