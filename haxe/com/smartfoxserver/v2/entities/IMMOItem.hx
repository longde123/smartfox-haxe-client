package com.smartfoxserver.v2.entities;

import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.variables.IMMOItemVariable;

/**
 * The<em>IMMOItem</em>interface defines all the methods and properties that an object representing a SmartFoxServer MMOItem entity exposes.
 *<p>In the SmartFoxServer 2X client API this Interface is implemented by the<em>MMOItem</em>class. Read the class description for additional informations.</p>
 * 
 * @see 	MMOItem
 */
interface IMMOItem
{
	/**
	 * Indicates the id of this item.
	 * It is unique and it is generated by the server when the item is created.
	 */
	function get id():Int;
	
	/**
	 * Retrieves all the MMOItem Variables of this item.
	 * 
	 * @return	The list of<em>MMOItemVariable</em>objects associated to this item.
	 * 
	 * @see		com.smartfoxserver.v2.entities.variables.MMOItemVariable MMOItemVariable
	 * @see		#getVariable()
	 */ 
	function getVariables():Array<Dynamic>;
	
	/**
	 * Retrieves an MMOItem Variable from its name.
	 * 
	 * @param	name	The name of the MMOItem Variable to be retrieved.
	 * 
	 * @return	The<em>MMOItemVariable</em>object, or<code>null</code>if no MMOItem Variable with the passed name is associated to this item.
	 * 
	 * @see		#getVariables()
	 */ 
	function getVariable(name:String):IMMOItemVariable;
	
	/** @private */
	function setVariable(itemVariable:IMMOItemVariable):Void;
	
	/** @private */
	function setVariables(itemVariables:Array):Void;
	
	/**
	 * Indicates whether this item has the specified MMOItem Variable set or not.
	 * 
	 * @param	name	The name of the MMOItem Variable whose existance must be checked.
	 * 
	 * @return	<code>true</code>if an MMOItem Variable with the passed name is set for this item.
	 */
	function containsVariable(name:String):Bool;
		
	/**
	 * Returns the entry point of this item in the current user's AoI.
	 * 
	 *<p>The returned coordinates are those that the item had when its presence in the current user's Area of Interest was last notified by a<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event.
	 * This field is populated only if the MMORoom in which the item exists is configured to receive such data.</p>
	 * 
	 * @see com.smartfoxserver.v2.requests.mmo.MMORoomSettings#sendAOIEntryPoint sendAOIEntryPoint
	 * @see	com.smartfoxserver.v2.SmartFox#event:proximityListUpdate proximityListUpdate event 
	 */
	function get aoiEntryPoint():Vec3D;
}