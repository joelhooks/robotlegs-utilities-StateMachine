package org.robotlegs.utilities.statemachine.tests.cases
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.robotlegs.utilities.statemachine.FSMInjector;
	import org.robotlegs.utilities.statemachine.StateEvent;
	import org.robotlegs.utilities.statemachine.StateMachine;

	public class StateMachineTests
	{
		private var eventDispatcher:IEventDispatcher;
		private var fsmInjector:FSMInjector;
		
		[Before]
		public function runBeforeEachTest():void
		{	
			eventDispatcher = new EventDispatcher();
			fsmInjector = new FSMInjector(this.fsm);
			fsmInjector.eventDispatcher = eventDispatcher;
		}
		
		[After]
		public function runAfterEachTest():void
		{
			fsmInjector = null;
		}
		
		[Test]
		public function fsmIsInitialized():void
		{
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			fsmInjector.inject(stateMachine);
			Assert.assertEquals(true, stateMachine is StateMachine);
			Assert.assertEquals(STARTING, stateMachine.currentStateName);
		}
		
		[Test]
		public function advanceToNextState():void
		{
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			fsmInjector.inject(stateMachine);
			eventDispatcher.dispatchEvent( new StateEvent( StateEvent.ACTION, STARTED ) );
			Assert.assertEquals(CONSTRUCTING, stateMachine.currentStateName);		
		}
		
		[Test]
		public function constructionStateFailure():void
		{
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			fsmInjector.inject(stateMachine);
			eventDispatcher.dispatchEvent( new StateEvent( StateEvent.ACTION, STARTED ) );
			Assert.assertEquals(CONSTRUCTING, stateMachine.currentStateName);	
			eventDispatcher.dispatchEvent(new StateEvent( StateEvent.ACTION, CONSTRUCTION_FAILED ));
			Assert.assertEquals(FAILING, stateMachine.currentStateName);			
		}

		[Test]
		public function stateMachineComplete():void
		{
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			fsmInjector.inject(stateMachine);
			eventDispatcher.dispatchEvent( new StateEvent( StateEvent.ACTION, STARTED ) );
			Assert.assertEquals(CONSTRUCTING, stateMachine.currentStateName);	
			eventDispatcher.dispatchEvent(new StateEvent( StateEvent.ACTION, CONSTRUCTED ));
			Assert.assertEquals(NAVIGATING, stateMachine.currentStateName);			
		}
		
		[Test]
		public function cancelStateChange():void
		{
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			fsmInjector.inject(stateMachine);
			eventDispatcher.dispatchEvent( new StateEvent( StateEvent.ACTION, STARTED ) );
			Assert.assertEquals(CONSTRUCTING, stateMachine.currentStateName);
			
			//listen for CONSTRUCTION_EXIT and block transition to next state
			eventDispatcher.addEventListener( CONSTRUCTION_EXIT, function (event:StateEvent):void { eventDispatcher.dispatchEvent(new StateEvent( StateEvent.CANCEL)); } );	
			
			//attempt to complete construction
			eventDispatcher.dispatchEvent(new StateEvent( StateEvent.ACTION, CONSTRUCTED ));
			Assert.assertEquals(CONSTRUCTING, stateMachine.currentStateName);				
		}
		
		[Test]
		public function singleStateInConfigurationShouldBeAtThatStateInitially():void
		{
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			fsmInjector = new FSMInjector(fsmOneState);
			fsmInjector.inject(stateMachine);
			Assert.assertEquals("State should be starting", STARTING, stateMachine.currentStateName);
		}

		[Test]
		public function singleStateInConfigurationShouldStayInStateOnCompletionEvent():void
		{
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			fsmInjector = new FSMInjector(fsmOneState);
			fsmInjector.inject(stateMachine);

			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, STARTED));
			Assert.assertEquals("State should be starting", STARTING, stateMachine.currentStateName);
		}
		
		[Test(async)]
		public function stateTransitionPassesData():void
		{
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			var data:Object = {value:"someData"};
			fsmInjector.inject(stateMachine);
			Async.handleEvent(this, eventDispatcher, StateEvent.ACTION, handleStateChange );
			eventDispatcher.dispatchEvent( new StateEvent( StateEvent.ACTION, STARTED, data) );
		}
		
		private function handleStateChange(event:StateEvent, pass:Object):void
		{
			Assert.assertTrue( event.data.value == "someData" );
		}
		
		////////
		// State Machine Constants and Vars
		///////
		private static const STARTING:String              = "state/starting";
		private static const START:String                 = "event/start";
		private static const START_ENTERING:String        = "action/start/entering";
		private static const STARTED:String               = "action/completed/start";
		private static const START_FAILED:String          = "action/start/failed";
		
		private static const CONSTRUCTING:String          = "state/constructing";
		private static const CONSTRUCT:String             = "event/construct";
		private static const CONSTRUCT_ENTERING:String    = "action/construct/entering";
		private static const CONSTRUCTED:String           = "action/completed/construction";
		private static const CONSTRUCTION_EXIT:String     = "event/construction/exit";
		private static const CONSTRUCTION_FAILED:String   = "action/contruction/failed";

		private static const NAVIGATING:String  	      = "state/navigating";
		private static const NAVIGATE:String  			  = "event/navigate";		
		
		private static const FAILING:String  	  		  = "state/failing";
		private static const FAIL:String  	  		  	  = "event/fail";
		
		private var fsmOneState:XML =
			<fsm initial={STARTING}>
				
				<!-- THE INITIAL STATE -->
				<state name={STARTING} entering={START_ENTERING}>

				</state>
			</fsm>
		
		private var fsm:XML = 
			<fsm initial={STARTING}>
			    
			    <!-- THE INITIAL STATE -->
				<state name={STARTING}>

			       <transition action={STARTED} 
			       			   target={CONSTRUCTING}/>

			       <transition action={START_FAILED} 
			       			   target={FAILING}/>
				</state>
				
				<!-- DOING SOME WORK -->
				<state name={CONSTRUCTING} changed={CONSTRUCT} exiting={CONSTRUCTION_EXIT} entering={CONSTRUCT_ENTERING}>

			       <transition action={CONSTRUCTED} 
			       			   target={NAVIGATING}/>
			       
			       <transition action={CONSTRUCTION_FAILED} 
			       			   target={FAILING}/>

				</state>

				<!-- READY TO ACCEPT BROWSER OR USER NAVIGATION -->
				<state name={NAVIGATING} changed={NAVIGATE}/>
				
				<!-- REPORT FAILURE FROM ANY STATE -->
				<state name={FAILING} changed={FAIL}/>

			</fsm>;
	}
}