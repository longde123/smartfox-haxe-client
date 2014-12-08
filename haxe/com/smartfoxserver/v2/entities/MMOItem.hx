package com.smartfoxserver.v2.entities;

import com.smartfoxserver.v2.entities.data.ISFSArray<Dynamic>;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.variables.IMMOItemVariable;
import com.smartfoxserver.v2.entities.variables.MMOItemVariable;

/**
 * An<em>MMOItem</em>represents an active non-player entity inside an MMORoom.
 * 
 *<p>MMOItems can be used to represent bonuses, triggers, bullets, etc, or any other non-player entity that will be handled using the MMORoom's rules of visibility.
 * This means that whenever one or more MMOItems fall within the Area of Interest of a user, their presence will be notified to that user by means of the
 *<em>SFSEvent.PROXIMITY_LIST_UPDATE</em>event.</p>
 *<p>MMOItems are identified by a unique ID and can have one or more MMOItem Variables associated to store custom data.</p>
 * 
 *<p><b>NOTE:</b>MMOItems can be created in a server side Extension only;client side creation is not allowed.</p>
 * 
 * @see	com.smartfoxserver.v2.entities.MMORoom MMORoom
 * @see com.smartfoxserver.v2.entities.variables.MMOItemVariable MMOItemVariable
 */
class MMOItem implements IMMOItem
{
	private var _id:Int;
	private var _variables:Dynamic;
	private var _aoiEntryPoint:Vec3D;
	
	/** @private */
	public static function fromSFSArray(encodedItem:ISFSArray):IMMOItem
	{
		// Create the MMO Item with the server side ID(Index=0 of the SFSArray)
		var item:IMMOItem=new MMOItem(encodedItem.getElementAt(0));
		
		// Decode ItemVariables(Index=1 of the SFSArray)
		var encodedVars:ISFSArray<Dynamic>=encodedItem.getSFSArray(1);
		
		for(var i:Int=0;i<encodedVars.size();i++)
		{
			item.setVariable(MMOItemVariable.fromSFSArray(encodedVars.getSFSArray(i)));
		}
		
		return item;
	}
	
	/**
	 * Creates a new<em>MMOItem</em>instance.
	 * 
	 *<p><b>NOTE</b>:developers never istantiate a<em>MMOItem</em>manually:this is done by the SmartFoxServer 2X API Internally.</p>
	 *  
	 * @param 	id	The item id.
	 */
	public function new(id:Int)
	{
		this._id=id;
		this._variables={};
	}
	
	/** @inheritDoc */
	public var id(get_id, set_id):Int;
 	private function get_id():Int
	{
		return _id;
	}
	
	/** @inheritDoc */
	public function getVariables():Array
	{
		// Return a copy of the Internal data structure as array
		var variables:Array<Dynamic>=[];
			
		for(var uv:IMMOItemVariable in _variables);
		variables.push(uv);
		
		return variables;
	}
	
	/** @inheritDoc */
	public function getVariable(name:String):IMMOItemVariable
	{
		return _variables[name];
	}
	
	/** @inheritDoc */
	public function setVariable(itemVariable:IMMOItemVariable):Void
	{
		if(itemVariable !=null)
		{
			// If varType==NULL delete var
			if(itemVariable.isNull())
				delete _variables[itemVariable.name];
			else
				_variables[itemVariable.name]=itemVariable;
		}
	}
	
	/** @inheritDoc */
	public function setVariables(itemVariables:Array):Void
	{
		for(var itemVar:IMMOItemVariable in itemVariables)
		{
			setVariable(itemVar);
		}
	}
	
	/** @inheritDoc */
	public function containsVariable(name:String):Bool
	{
		return _variables[name] !=null
	}
	
	/** @inheritDoc */
	public var aoiEntryPoint(get_aoiEntryPoint, set_aoiEntryPoint):Vec3D;
 	private function get_aoiEntryPoint():Vec3D
	{
		return _aoiEntryPoint;
	}
	
	/** @private */
	private function set_aoiEntryPoint(loc:Vec3D):Void
	{
		_aoiEntryPoint=loc;
	}
	
	/**
	 * Returns a string that contains the item id.
	 * 
	 * @return	The string representation of the<em>MMOItem</em>object.
	 */
	public function toString():String
	{
		return "[Item:" + _id + "]";
	}
}