package com.smartfoxserver.v2.entities;

import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.managers.IUserManager;
import com.smartfoxserver.v2.entities.variables.UserVariable;

/**
 * The<em>User</em>interface defines all the methods and properties that an object representing a SmartFoxServer User entity exposes.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>SFSUser</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	SFSUser
 */
interface User
{
	/**
	 * Indicates the id of this user.
	 * It is unique and it is generated by the server when the user is created.
	 */
	function get id():Int
	
	/**
	 * Indicates the name of this user.
	 * Two users in the same Zone can't have the same name.
	 */
	function get name():String
	
	/**
	 * Returns the id of this user as a player in a Game Room.
	 * 
	 *<p>This property differs from<em>id</em>property and it used to indicate which player number is assigned to a user inside a Game Room.
	 * For example, in a Game Room for 5 players the first client joining it will have<em>playerId</em>equal to<code>1</code>, the second will have it equal to<code>2</code>and so forth. 
	 * When a user leaves the Room the player slot is freed up and the next user joining the Room will take it.</p>
	 * 
	 *<p>The<em>playerId</em>property applies to Game Rooms only;in standard Rooms it is always<code>0</code>.
	 * Also, in Game Rooms a<em>playerId</em>value lower than<code>0</code>indicates that the user is a spectator.</p>
	 * 
	 *<p>If the user is inside multiple Game Rooms at the same time, a different<em>playerId</em>value will be assigned to him in each Room.
	 * In this case this property returns the value corresponding to the last joined Room;in order to obtain the<em>playerId</em>value in a specific Room, use the<em>getPlayerId()</em>method.</p>
	 * 
	 * @see		#getPlayerId()
	 */ 
	function get playerId():Int
	
	/**
	 * Indicates whether this user is a player(<em>playerId</em>greater than<code>0</code>)in the last joined Room or not.
	 * Non-Game Rooms always return<code>false</code>.
	 * 
	 *<p>If the user is inside multiple Game Rooms at the same time, use the<em>isPlayerInRoom()</em>method.</p>
	 * 
	 * @see 	#playerId
	 * @see		#isPlayerInRoom()
	 * @see 	#isSpectator
	 */
	function get isPlayer():Bool
	
	/**
	 * Indicates whether this user is a spectator(<em>playerId</em>lower than<code>0</code>)in the last joined Room or not.
	 * Non-Game Rooms always return<code>false</code>.
	 * 
	 *<p>If the user is inside multiple Game Rooms at the same time, use the<em>isSpectatorInRoom()</em>method.</p>
	 * 
	 * @see 	#playerId
	 * @see		#isSpectatorInRoom()
	 * @see 	#isPlayer
	 */
	function get isSpectator():Bool
	
	/** 
	 * Returns the<em>playerId</em>value of this user in the passed Room.
	 * See the<em>playerId</em>property description for more informations.
	 * 
	 * @param	room	The<em>Room</em>object representing the Room to retrieve the player id from.
	 * 
	 * @return	The<em>playerId</em>of this user in the passed Room.
	 * 
	 * @see #playerId
	 */
	function getPlayerId(room:Room):Int
	
	/** @private */
	function setPlayerId(id:Int, room:Room):Void
	
	/** @private */
	function removePlayerId(room:Room):Void
	
	/** 
	 * Returns the id which identifies the privilege level of this user.
	 * 
	 *<p><b>NOTE</b>:setting the<em>privilegeId</em>property manually has no effect on the server and can disrupt the API functioning.
	 * Privileges are assigned to the user by the server when the user logs in.</p>
	 * 
	 * @see 	com.smartfoxserver.v2.entities.UserPrivileges UserPrivileges
	 */
	function get privilegeId():Int
	
	/** @private */
	function set privilegeId(value:Int):Void
	
	/**
	 * Returns a reference to the User Manager which manages this user.
	 * 
	 *<p><b>NOTE</b>:setting the<em>userManager</em>property manually has no effect on the server and can disrupt the API functioning.</p>
	 */
	function get userManager():IUserManager
	
	/** @private */
	function set userManager(value:IUserManager):Void

	//--------------------------------------------------
	
	/**
	 * Indicates whether this user logged in as a guest or not.
	 * Guest users have the<em>privilegeId</em>property set to<em>UserPrivileges.GUEST</em>.
	 * 
	 * @return	<code>true</code>if this user is a guest.
	 * 
	 * @see		#isStandardUser()
	 * @see		#isModerator()
	 * @see		#isAdmin()
	 * @see		#privilegeId
	 * @see 	com.smartfoxserver.v2.entities.UserPrivileges#GUEST UserPrivileges.GUEST
	 */
	function isGuest():Bool
	
	/**
	 * Indicates whether this user logged in as a standard user or not.
	 * Standard users have the<em>privilegeId</em>property set to<em>UserPrivileges.STANDARD</em>.
	 * 
	 * @return	<code>true</code>if this user is a standard user.
	 * 
	 * @see		#isGuest()
	 * @see		#isModerator()
	 * @see		#isAdmin()
	 * @see		#privilegeId
	 * @see 	com.smartfoxserver.v2.entities.UserPrivileges#STANDARD UserPrivileges.STANDARD
	 */
	function isStandardUser():Bool
	
	/**
	 * Indicates whether this user logged in as a moderator or not.
	 * Moderator users have the<em>privilegeId</em>property set to<em>UserPrivileges.MODERATOR</em>.
	 * 
	 * @return	<code>true</code>if this user is a moderator.
	 * 
	 * @see		#isGuest()
	 * @see		#isStandardUser()
	 * @see		#isAdmin()
	 * @see		#privilegeId
	 * @see 	com.smartfoxserver.v2.entities.UserPrivileges#MODERATOR UserPrivileges.MODERATOR
	 */
	function isModerator():Bool
	
	/**
	 * Indicates whether this user logged in as an administrator or not.
	 * Administrator users have the<em>privilegeId</em>property set to<em>UserPrivileges.ADMINISTRATOR</em>.
	 * 
	 * @return	<code>true</code>if this user is an administrator.
	 * 
	 * @see		#isGuest()
	 * @see		#isStandardUser()
	 * @see		#isModerator()
	 * @see		#privilegeId
	 * @see 	com.smartfoxserver.v2.entities.UserPrivileges#ADMINISTRATOR UserPrivileges.ADMINISTRATOR
	 */
	function isAdmin():Bool
	
	//--------------------------------------------------
	
	/**
	 * Indicates whether this user is a player(<em>playerId</em>greater than<code>0</code>)in the passed Room or not.
	 * Non-Game Rooms always return<code>false</code>.
	 * 
	 *<p>If a user can join one Game Room at a time only, use the<em>isPlayer</em>property.</p>
	 * 
	 * @param	room	The<em>Room</em>object representing the Room where to check if this user is a player.
	 * 
	 * @return	<code>true</code>if this user is a player in the passed Room.
	 * 
	 * @see 	#playerId
	 * @see		#isPlayer
	 * @see		#isSpectatorInRoom()
	 */
	function isPlayerInRoom(room:Room):Bool
	
	/**
	 * Indicates whether this user is a spectator(<em>playerId</em>lower than<code>0</code>)in the passed Room or not.
	 * Non-Game Rooms always return<code>false</code>.
	 * 
	 *<p>If a user can join one Game Room at a time only, use the<em>isSpectator</em>property.</p>
	 * 
	 * @param	room	The<em>Room</em>object representing the Room where to check if this user is a spectator.
	 * 
	 * @return	<code>true</code>if this user is a spectator in the passed Room.
	 * 
	 * @see 	#playerId
	 * @see		#isSpectator
	 * @see		#isPlayerInRoom()
	 */
	function isSpectatorInRoom(room:Room):Bool
	
	/**
	 * Indicates whether this user joined the passed Room or not.
	 * 
	 * @param	room	The<em>Room</em>object representing the Room where to check the user presence.
	 * 
	 * @return	<code>true</code>if this user is inside the passed Room.
	 */
	function isJoinedInRoom(room:Room):Bool
	
	/**
	 * Indicates if this<em>User</em>object represents the current client.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#mySelf SmartFox.mySelf
	 */
	function get isItMe():Bool
	
	/**
	 * Retrieves all the User Variables of this user.
	 * 
	 * @return	The list of<em>UserVariable</em>objects associated with the user.
	 * 
	 * @see		com.smartfoxserver.v2.entities.variables.UserVariable UserVariable
	 * @see		#getVariable()
	 */ 
	function getVariables():Array
	
	/**
	 * Retrieves a User Variable from its name.
	 * 
	 * @param	name	The name of the User Variable to be retrieved.
	 * 
	 * @return	The<em>UserVariable</em>object representing the User Variable, or<code>null</code>if no User Variable with the passed name is associated with this user.
	 * 
	 * @see		#getVariables()
	 * @see 	com.smartfoxserver.v2.requests.SetUserVariablesRequest SetUserVariablesRequest
	 */ 
	function getVariable(name:String):UserVariable
	
	/** @private */
	function setVariable(userVariable:UserVariable):Void
	
	/** @private */
	function setVariables(userVariables:Array):Void
	
	/**
	 * Indicates whether this user has the specified User Variable set or not.
	 * 
	 * @param	name	The name of the User Variable whose existance must be checked.
	 * 
	 * @return	<code>true</code>if a User Variable with the passed name is set for this user.
	 */
	function containsVariable(name:String):Bool
	
	/** 
	 * Defines a generic utility object that can be used to store custom user data.
	 * The values added to this object are for client-side use only and are never transmitted to the server or to the other clients.
	 */
	function get properties():Dynamic
	
	/** @private */
	function set properties(value:Dynamic):Void
		
	/**
	 * Returns the entry point of this user in the current user's AoI.
	 * 
	 *<p>The returned coordinates are those that the user had when his presence in the current user's Area of Interest was last notified by a<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event.
	 * This field is populated only if the user joined a Room of type MMORoom and this is configured to receive such data from the server.</p>
	 * 
	 * @see com.smartfoxserver.v2.requests.mmo.MMORoomSettings#sendAOIEntryPoint sendAOIEntryPoint
	 * @see	com.smartfoxserver.v2.SmartFox#event:proximityListUpdate proximityListUpdate event 
	 */
	function get aoiEntryPoint():Vec3D
	
	/** @private */
	function set aoiEntryPoint(loc:Vec3D):Void
}