package org.robotlegs.examples.simplestate
{
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.examples.simplestate.controller.bootstrap.ConfigureStateMachineCommand;
	import org.robotlegs.mvcs.Context;
	
	public class SimpleStateContext extends Context
	{
		override public function startup():void
		{
			commandMap.mapEvent( ContextEvent.STARTUP, ConfigureStateMachineCommand, ContextEvent, true );
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}