package com.smartfoxserver.v2.entities.invitation
{
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	
	/**
	 * The <em>Invitation</em> interface defines all the methods and properties that an object representing an invitation entity exposes.
	 * <p>In the SmartFoxServer 2X client API this interface is implemented by the <em>SFSInvitation</em> class. Read the class description for additional informations.</p>
	 * 
	 * @see 	SFSInvitation
	 */
	public interface Invitation
	{
		/** 
		 * Indicates the id of this invitation.
		 * It is generated by the server when the invitation is sent.
		 * 
		 * <p><b>NOTE</b>: setting the <em>id</em> property manually has no effect on the server and can disrupt the API functioning.</p>
		 */
		function get id():int
		
		/** @private */
		function set id(value:int):void
		
		/** 
		 * Returns the <em>User</em> object corresponding to the user who sent the invitation. 
		 */
		function get inviter():User
		
		/** 
		 * Returns the <em>User</em> object corresponding to the user who received the invitation. 
		 */
		function get invitee():User
		
		/** 
		 * Returns the number of seconds available to the invitee to reply to the invitation, after which the invitation expires.
		 */
		function get secondsForAnswer():int
		
		/** 
		 * Returns an instance of <em>SFSObject</em> containing a custom set of parameters.
		 * It usually stores invitation details, like a message to the invitee and any other relevant data. 
		 */
		function get params():ISFSObject
	}
}