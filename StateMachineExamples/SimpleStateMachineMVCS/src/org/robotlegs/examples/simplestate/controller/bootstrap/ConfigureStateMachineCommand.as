package org.robotlegs.examples.simplestate.controller.bootstrap
{
	import org.robotlegs.examples.simplestate.StateMachineBootstrapConstants;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.FSMInjector;
	import org.robotlegs.utilities.statemachine.StateEvent;
	import org.robotlegs.utilities.statemachine.StateMachine;
	
	public class ConfigureStateMachineCommand extends Command
	{
		override public function execute():void
		{
			var smInjector:FSMInjector = new FSMInjector( StateMachineBootstrapConstants.FSM );
			var sm:StateMachine = new StateMachine(eventDispatcher);
			
			commandMap.mapEvent( StateMachineBootstrapConstants.CHECK_STORED_CREDENTIALS, CheckExistingCredentialsCommand );
			commandMap.mapEvent( StateMachineBootstrapConstants.LOGIN, LoginCommand );
			commandMap.mapEvent( StateMachineBootstrapConstants.RETRY_LOGIN, RetryLoginCommand );
			commandMap.mapEvent( StateMachineBootstrapConstants.DISPLAY_APPLICATION );
			commandMap.mapEvent( StateMachineBootstrapConstants.FAIL, BoostrapFailCommand );
			
			smInjector.inject( sm );
			
			eventDispatcher.dispatchEvent( new StateEvent( StateEvent.ACTION, StateMachineBootstrapConstants.STARTED );
		}
	}
}