package com.smartfoxserver.v2.requests
{
	/**
	 * The <em>RoomExtension</em> class contains a specific subset of the <em>RoomSettings</em> required to create a Room.
	 * It defines which server-side Extension should be attached to the Room upon creation.
	 * 
	 * <p>The client can communicate with the Room Extension by means of the <em>ExtensionRequest</em> request.</p>
	 * 
	 * @see RoomSettings#extension
	 * @see CreateRoomRequest
	 * @see	ExtensionRequest
	 */
	public class RoomExtension
	{
		private var _id:String					// <-- mandatory
		private var _className:String			// <-- mandatory
		private var _propertiesFile:String		// <-- optional
		
		/**
		 * Creates a new <em>RoomExtension</em> instance.
		 * The <em>RoomSettings.extension</em> property must be set to this instance during Room creation.
		 * 
		 * @param	id			The name of the Extension as deployed on the server; it's the name of the folder containing the Extension classes inside the main <em>[sfs2x-install-folder]/SFS2X/extensions</em> folder.
		 * @param	className	The fully qualified name of the main class of the Extension.
		 * 
		 * @see		RoomSettings#extension
		 */
		public function RoomExtension(id:String, className:String)
		{
			_id = id
			_className = className
			_propertiesFile = ""
		}
		
		/**
		 * Returns the name of the Extension to be attached to the Room.
		 * It's the name of the server-side folder containing the Extension classes inside the main <em>[sfs2x-install-folder]/SFS2X/extensions</em> folder.
		 */
		public function get id():String
		{
			return _id
		}
		
		/**
		 * Returns the fully qualified name of the main class of the Extension.
		 */
		public function get className():String
		{
			return _className
		}
		
		/**
		 * Defines the name of an optional properties file that should be loaded on the server-side during the Extension initialization.
		 * The file must be located in the server-side folder containing the Extension classes (see the <em>id</em> property).
		 * 
		 * @see		#id
		 */
		public function get propertiesFile():String
		{
			return _propertiesFile
		}
		
		/** @private */
		public function set propertiesFile(fileName:String):void
		{
			_propertiesFile = fileName
		}
	}
}