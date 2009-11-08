/*
  ADAPTED FOR ROBOTLEGS FROM:
  PureMVC AS3 Utility - StateMachine
  Copyright (c) 2008 Neil Manuell, Cliff Hall
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.robotlegs.utilities.statemachine
{
	import flash.events.IEventDispatcher;
	
	public class StateMachine
	{
		public var eventDispatcher:IEventDispatcher;
		
		/**
		 *  StateMachine Constructor
		 * @param eventDispatcher an event deispatcher used to commincate with interested actors.
		 * This is typically the Robotlegs framework.
		 * 
		 */		
		public function StateMachine(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
			super();
		}
		
		public function onRegister():void
		{
			eventDispatcher.addEventListener( StateEvent.ACTION, handleStateAction );
			eventDispatcher.addEventListener( StateEvent.CANCEL, handleStateCancel );
			if ( initial ) transitionTo( initial, null );
		}
		
		protected function handleStateAction(event:StateEvent):void
		{
			var newStateTarget:String = _currentState.getTarget( event.action );
			var newState:State = states[ newStateTarget ];
			if( newState )
				transitionTo( newState, event.data );
		}
		
		protected function handleStateCancel(event:StateEvent):void
		{
			canceled = true;
		}

		/**
		 * Registers the entry and exit commands for a given state.
		 * 
		 * @param state the state to which to register the above commands
		 * @param initial boolean telling if this is the initial state of the system
		 */
		public function registerState( state:State, initial:Boolean=false ):void
		{
			if ( state == null || states[ state.name ] != null ) return;
			states[ state.name ] = state;
			if ( initial ) this.initial = state; 
		}
		
		/**
		 * Remove a state mapping. 
		 * <P>
		 * Removes the entry and exit commands for a given state 
		 * as well as the state mapping itself.</P>
		 * 
		 * @param state
		 */
		public function removeState( stateName:String ):void
		{
			var state:State = states[ stateName ];
			if ( state == null ) return;
			states[ stateName ] = null;
		}
		
		/**
		 * Transitions to the given state from the current state.
		 * <P>
		 * Sends the <code>exiting</code> StateEvent for the current state 
		 * followed by the <code>entering</code> StateEvent for the new state.
		 * Once finally transitioned to the new state, the <code>changed</code> 
		 * StateEvent for the new state is sent.</P>
		 * <P>
		 * If a data parameter is provided, it is included as the body of all
		 * three state-specific transition notes.</P>
		 * <P>
		 * Finally, when all the state-specific transition notes have been
		 * sent, a <code>StateEvent.CHANGED</code> event is sent, with the
		 * new <code>State</code> object as the <code>body</code> and the name of the 
		 * new state in the <code>type</code>.
		 * 
		 * @param nextState the next State to transition to.
		 * @param data is the optional Object that was sent in the <code>StateEvent.ACTION</code> event
		 */
		protected function transitionTo( nextState:State, data:Object=null ):void
		{
			// Going nowhere?
			if ( nextState == null ) return;
			
			// Clear the cancel flag
			canceled = false;
				
			// Exit the current State 
			if ( _currentState && _currentState.exiting ) eventDispatcher.dispatchEvent( new StateEvent( _currentState.exiting, null, data ));
			
			// Check to see whether the exiting guard has been canceled
			if ( canceled ) {
				canceled = false;
				return;
			}
			
			// Enter the next State 
			if ( nextState.entering ) eventDispatcher.dispatchEvent( new StateEvent( nextState.entering, null, data )); 
			
			
			// Check to see whether the entering guard has been canceled
			if ( canceled ) {
				canceled = false;
				return;
			}
			//
			// change the current state only when both guards have been passed
			_currentState = nextState;
			
			// Send the notification configured to be sent when this specific state becomes current 
			if ( nextState.changed ) eventDispatcher.dispatchEvent( new StateEvent( _currentState.changed, null, data ));  

			// Notify the app generally that the state changed and what the new state is 
			eventDispatcher.dispatchEvent( new StateEvent( StateEvent.CHANGED, _currentState.name));
		
		}
				
		
		private var _currentState:State;

		public function get currentStateName():String
		{
			return _currentState.name.valueOf();
		}

		
		/**
		 * Map of States objects by name.
		 */
		protected var states:Object = new Object();
		
		/**
		 * The initial state of the FSM.
		 */
		protected var initial:State;
		
		/**
		 * The transition has been canceled.
		 */
		protected var canceled:Boolean;
	}
}