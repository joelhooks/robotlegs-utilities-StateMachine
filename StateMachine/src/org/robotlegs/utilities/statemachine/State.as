/*
  ADAPTED FOR ROBOTLEGS FROM:
  PureMVC AS3 Utility - StateMachine
  Copyright (c) 2008 Neil Manuell, Cliff Hall
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.robotlegs.utilities.statemachine
{
	/**
	 * Defines a State.
	 */
	public class State
	{
		// The state name
		public var name:String;
		
		// The notification to dispatch when entering the state
		public var entering:String;
		
		// The notification to dispatch when exiting the state
		public var exiting:String;

		// The notification to dispatch when the state has actually changed
		public var changed:String;
		
		/**
		 * Constructor.
		 * 
		 * @param id the id of the state
		 * @param entering an optional event name to be sent when entering this state
		 * @param exiting an optional event name to be sent when exiting this state
		 * @param changed an optional event name to be sent when fully transitioned to this state
		 */
		public function State( name:String, entering:String=null, exiting:String=null, changed:String=null )
		{
			this.name = name;
			if ( entering ) this.entering = entering;
			if ( exiting ) this.exiting  = exiting;
			if ( changed ) this.changed = changed;
		}
	
		/** 
		 * Define a transition. 
		 * 
		 * @param action the name of the StateMachine.ACTION event type.
		 * @param target the name of the target state to transition to.
		 */
		public function defineTrans( action:String, target:String ):void
		{
			if ( getTarget( action ) != null ) return;	
			transitions[ action ] = target;
		}

		/** 
		 * Remove a previously defined transition.
		 */
		public function removeTrans( action:String ):void
		{
			transitions[ action ] = null;	
		}	
		
		/**
		 * Get the target state name for a given action.
		 */
		public function getTarget( action:String ):String
		{
			return transitions[ action ];
		}
		
		/**
		 *  Transition map of actions to target states
		 */ 
		protected var transitions:Object = new Object();
		
	}
}