package com.tomseysdavies.ember.base
{
	import com.tomseysdavies.ember.core.IEntity;
	import com.tomseysdavies.ember.core.IEntityManger;
	import com.tomseysdavies.ember.core.IFamily;
	
	import org.osflash.signals.Signal;
	import org.osmf.traits.IDisposable;
	
	internal class Family implements IFamily
	{
		
		private const ENTITY_ADDED:Signal = new Signal(IEntity);
		private const ENTITY_REMOVED:Signal = new Signal(IEntity);
		private var _entities:Vector.<IEntity>;
		private var _loopSignal:Signal;
		private var _currentEntity:IEntity;
		private var _compoments:Array;
		private var _canceled:Boolean
		
		public function Family(compoments:Array)
		{
			_compoments = compoments;
			_loopSignal = new Signal();
			_loopSignal.valueClasses = _compoments;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get entites():Vector.<IEntity>{
			return _entities;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set entites(value:Vector.<IEntity>):void{
			_entities = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get entityAdded():Signal{
			return ENTITY_ADDED;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get entityRemoved():Signal{
			return ENTITY_REMOVED;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get iterator():Signal{
			return _loopSignal;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():uint{
			if(_entities == null) return 0;
			return _entities.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function startIterator():void{
			_canceled = false;
			for each(var entity:IEntity in _entities){
				_currentEntity = entity;
				_loopSignal.dispatch.apply(this,extractComponents(entity));
				if(_canceled){
					break;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function stopIterator():void{
			_canceled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		private function extractComponents(entity:IEntity):Array{
			var components:Array = [];
			for each(var Compoment:Class in _compoments){
				components.push(entity.getComponent(Compoment));
			}
			return components;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getCurrentEntity():IEntity{
			return _currentEntity;
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void{
			_entities = null;
			ENTITY_ADDED.removeAll();
			ENTITY_REMOVED.removeAll();
			_loopSignal.removeAll();
		}
	}
}