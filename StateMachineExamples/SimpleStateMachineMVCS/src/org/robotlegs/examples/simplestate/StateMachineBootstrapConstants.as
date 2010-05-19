package org.robotlegs.examples.simplestate
{
	public class StateMachineBootstrapConstants
	{
		public static const STARTING:String="state/starting";
		public static const START:String="event/start";
		public static const STARTED:String="action/completed/start";
		public static const START_FAILED:String="action/start/failed";

		public static const CHECKING_STORED_CREDENTIALS:String="state/checkingStoredCredentials";
		public static const CHECK_STORED_CREDENTIALS:String="event/checkStoredCredentials";
		public static const STORED_CREDENTIALS_EXIST:String="action/storedCredentialsExist";
		public static const STORED_CREDENTIALS_DO_NOT_EXIST:String="action/storedCredentialsDoNotExist";
		public static const CHECK_CREDENTIALS_FAILED:String="action/checkStoredCredentialsFailed";

		public static const LOGGING_IN:String="state/loggingIn";
		public static const LOGIN:String="event/login";
		public static const LOGIN_SUCCESSFUL:String="action/loginSuccessful";
		public static const LOGIN_FAILED:String="action/loginSuccessful";

		public static const RETRY_LOGGING_IN:String="state/retryLoggingIn";
		public static const RETRY_LOGIN:String="event/retryLogin";

		public static const DISPLAYING_APPLICATION:String="state/displayingApplication";
		public static const DISPLAY_APPLICATION:String="event/displayApplication";

		public static const FAILING:String="state/failing";
		public static const FAIL:String="event/fail";

		/**
		 * XML configures the State Machine. This could be loaded from an external
		 * file as well.
		 */
		public static const FSM:XML=<fsm initial={STARTING}>

				<!-- THE INITIAL STATE -->
				<state name={STARTING}>

					<transition action={STARTED} 
						target={CHECKING_STORED_CREDENTIALS}/>

					<transition action={START_FAILED} 
						target={FAILING}/>
				</state>

				<!-- CHECK TO SEE IF THERE ARE STORED CREDENTIALS -->
				<state name={CHECKING_STORED_CREDENTIALS} changed={CHECK_STORED_CREDENTIALS}>

					<transition action={STORED_CREDENTIALS_EXIST} 
						target={DISPLAYING_APPLICATION}/>

					<transition action={STORED_CREDENTIALS_DO_NOT_EXIST} 
						target={LOGGING_IN}/>

					<transition action={CHECK_CREDENTIALS_FAILED} 
						target={FAILING}/>

				</state>

				<!-- THERE WERE NO STORED CREDENTIALS SO WE NEED TO LOGIN -->
				<state name={LOGGING_IN} changed={LOGIN}>

					<transition action={LOGIN_SUCCESSFUL} 
						target={DISPLAYING_APPLICATION}/>

					<transition action={LOGIN_FAILED} 
						target={RETRY_LOGGING_IN}/>

				</state>
				
				<!-- THE LOGIN FAILED SO WE WANT TO RETRY -->
				<state name={RETRY_LOGGING_IN} changed={RETRY_LOGIN}>

					<transition action={LOGIN_SUCCESSFUL} 
						target={DISPLAYING_APPLICATION}/>

					<transition action={LOGIN_FAILED} 
						target={RETRY_LOGGING_IN}/>

					<transition action={CHECK_CREDENTIALS_FAILED} 
						target={FAILING}/>

				</state>

				<!-- WOOT! THE USER CAN DO STUFF NOW -->
				<state name={DISPLAYING_APPLICATION} changed={DISPLAY_APPLICATION}/>
		
				<!-- HOPEFULLY WE DON'T GET HERE! -->
				<state name={FAILING} changed={FAIL}/>
			</fsm>;
	}
}