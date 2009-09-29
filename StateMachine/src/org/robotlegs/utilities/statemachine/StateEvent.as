package org.robotlegs.utilities.statemachine
{
	import flash.events.Event;

	public class StateEvent extends Event
	{
		public static const CHANGED:String = "changed";
		public static const ACTION:String = "action";
		public static const CANCEL:String = "cancel";
		
		public var action:String;
		public var stateTarget:String;
	    public var data:Object;
		
		public function StateEvent(type:String, action:String = null, data:Object = null)
		{
			this.action = action;
			this.stateTarget = stateTarget;
			this.data = data;
			super(type, false, false);
		}
		
		override public function clone() : Event
		{
			return new StateEvent(type, action, data);
		}
	}
}