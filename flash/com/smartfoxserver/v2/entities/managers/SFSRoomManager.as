package com.smartfoxserver.v2.entities.managers
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.kernel;
	import com.smartfoxserver.v2.util.ArrayUtil;
	
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Itr;
	
	/**
	 * The <em>SFSRoomManager</em> class is the entity in charge of managing the client-side Rooms list.
	 * It keeps track of all the Rooms available in the client-side Rooms list and of subscriptions to multiple Room Groups.
	 * It also provides various utility methods to look for Rooms by name and id, retrieve Rooms belonging to a specific Group, etc.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#roomManager SmartFox.roomManager
	 */
	public class SFSRoomManager implements IRoomManager
	{
		private var _ownerZone:String
		private var _groups:Array
		private var _roomsById:HashMap
		private var _roomsByName:HashMap
		
		/** @private */
		protected var _smartFox:SmartFox 
		
		/**
		 * Creates a new <em>SFSRoomManager</em> instance.
		 * 
		 * <p><b>NOTE</b>: developers never instantiate a <em>SFSRoomManager</em> manually: this is done by the SmartFoxServer 2X API internally.
		 * A reference to the existing instance can be retrieved using the <em>SmartFox.roomManager</em> property.</p>
		 *  
		 * @param 	sfs		An instance of the SmartFoxServer 2X client API main <em>SmartFox</em> class.
		 * 
		 * @see		com.smartfoxserver.v2.SmartFox#roomManager SmartFox.roomManager
		 */
		public function SFSRoomManager(sfs:SmartFox)
		{
			_groups = new Array()
			_roomsById = new HashMap()
			_roomsByName = new HashMap()
		}
		
		/** @private */
		public function get ownerZone():String
		{
			return _ownerZone
		}
		
		/** @private */
		public function set ownerZone(value:String):void
		{
			_ownerZone = value
		}
		
		/** @private */
		public function get smartFox():SmartFox
		{
			return _smartFox
		}
		
		/** @private */
		public function addRoom(room:Room, addGroupIfMissing:Boolean=true):void
		{
			_roomsById.set(room.id, room)
			_roomsByName.set(room.name, room)
			
			// If group is not known, add it to the susbscribed list
			if (addGroupIfMissing)
			{
				if (!containsGroup(room.groupId))
					addGroup(room.groupId)
			}
			
			/*
			* We don't add a group that was not subscribed
			* Instead we mark the Room as *NOT MANAGED* which means that it will be removed from the local
			* RoomList as soon as we leave it
			*/
			else
				room.isManaged = false	
		}
		
		/** @private */
		public function replaceRoom(room:Room, addToGroupIfMissing:Boolean=true):Room
		{
			// Take the Room object that should be replaced
			var oldRoom:Room = getRoomById(room.id)
				
			/*
			* If found, the Room is already in the RoomList and we don't want 
			* to replace the object, only update it
			*/
			if (oldRoom != null)
			{
				oldRoom.kernel::merge(room)
				return oldRoom
			}
					
			// There's no previous instance, just add it			
			else
			{
				addRoom(room, addToGroupIfMissing)
				return room
			}
		}
		
		/** @private */
		public function changeRoomName(room:Room, newName:String):void
		{
			var oldName:String = room.name
			room.name = newName
			
			// Update keys in the byName collection
			_roomsByName.set(newName, room)
			_roomsByName.clr(oldName)
		}
		
		/** @private */
		public function changeRoomPasswordState(room:Room, isPassProtected:Boolean):void
		{
			room.setPasswordProtected(isPassProtected)
		}
		
		/** @private */
		public function changeRoomCapacity(room:Room, maxUsers:int, maxSpect:int):void
		{
			room.maxUsers = maxUsers
			room.maxSpectators = maxSpect
		}
		
		/** @inheritDoc */
		public function getRoomGroups():Array
		{
			return _groups
		}
		
		/** @private */
		public function addGroup(groupId:String):void
		{
			_groups.push(groupId)
		}
		
		/** @private */
		public function removeGroup(groupId:String):void
		{
			// Remove group
			ArrayUtil.removeElement(_groups, groupId)
			
			var roomsInGroup:Array = getRoomListFromGroup(groupId)
			
			/*
			* We remove all rooms from the Group with the exception
			* of those that are joined. The joined Rooms must remain in the local Room List
			* but they are marked as unmanaged because we no longer subscribe to their Group
			*
			* The unmanaged Room(s) will be removed as soon as we leave it 
			*/
			for each (var room:Room in roomsInGroup)
			{
				if (!room.isJoined)
					removeRoom(room)
				else
					room.isManaged = false
			}
			
		}
		
		/** @inheritDoc */
		public function containsGroup(groupId:String):Boolean
		{
			return (_groups.indexOf(groupId) > -1)
		}
		
		/** @inheritDoc */
		public function containsRoom(idOrName:*):Boolean
		{
			if (typeof idOrName == "number")
				return _roomsById.hasKey(idOrName)
			else
				return _roomsByName.hasKey(idOrName)
		}
		
		/** @inheritDoc */
		public function containsRoomInGroup(idOrName:*, groupId:String):Boolean
		{
			var roomList:Array = getRoomListFromGroup(groupId)
			var found:Boolean = false			
			var searchById:Boolean = (typeof idOrName == "number")
			
			for each (var room:Room in roomList)
			{
				if (searchById)
				{
					if (room.id == idOrName)
					{
						found = true
						break
					}
				}
				else
				{
					if (room.name == idOrName)
					{
						found = true
						break
					}	
				}
			}
			
			return found
		}
		
		/** @inheritDoc */
		public function getRoomById(id:int):Room
		{
			return _roomsById.get(id) as Room
		}
		
		/** @inheritDoc */
		public function getRoomByName(name:String):Room
		{
		 	return _roomsByName.get(name) as Room
		}
		
		/** @inheritDoc */
		public function getRoomList():Array
		{
			return _roomsById.toDA().getArray()
		}
		
		/** @inheritDoc */
		public function getRoomCount():int
		{
			return _roomsById.size()
		}
		
		/** @inheritDoc */
		public function getRoomListFromGroup(groupId:String):Array
		{
			var roomList:Array = new Array()
			var it:Itr = _roomsById.iterator()
			
			while (it.hasNext()) 
			{
				var room:Room = it.next() as Room
				
				if (room.groupId == groupId)
					roomList.push(room)
			}
			
			return roomList
		}
		
		/** @private */
		public function removeRoom(room:Room):void
		{
			_removeRoom(room.id, room.name)
		}
		
		/** @private */
		public function removeRoomById(id:int):void
		{
			var room:Room = _roomsById.get(id) as Room
			
			if (room != null)
				_removeRoom(id, room.name)
		}
		
		/** @private */
		public function removeRoomByName(name:String):void
		{
			var room:Room = _roomsByName.get(name) as Room
			
			if (room != null)
				_removeRoom(room.id, name)
		}
		
		// Return rooms joined by local user
		/** @inheritDoc */
		public function getJoinedRooms():Array
		{
			var rooms:Array = []
			var it:Itr = _roomsById.iterator()
			
			while(it.hasNext())
			{
				var room:Room = it.next() as Room
				
				if (room.isJoined)
					rooms.push(room)
			}
			
			return rooms
		}
		
		/** @inheritDoc */
		public function getUserRooms(user:User):Array
		{
			var rooms:Array = []
			var it:Itr = _roomsById.iterator()
			
			// Cycle through all Rooms
			while(it.hasNext())
			{
				var room:Room = it.next() as Room
				
				if (room.containsUser(user))
					rooms.push(room)
			}
			
			return rooms
		}
		
		/** @private */
		public function removeUser(user:User):void
		{
			var it:Itr = _roomsById.iterator()
			
			// Cycle through all Rooms
			while(it.hasNext())
			{
				var room:Room = it.next() as Room
				
				if (room.containsUser(user))
					room.removeUser(user)
			}
		}
		
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private methods
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		private function _removeRoom(id:int, name:String):void
		{
			_roomsById.clr(id)
			_roomsByName.clr(name)
		}
	}
}