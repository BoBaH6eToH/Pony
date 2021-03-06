package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Event;
import pony.events.Signal;
import pony.events.Listener;
import pony.Function;

class SignalTest 
{
	
	@Test
	public function shortCuts():Void
	{
		var r:String;
		var s:Signal = new Signal();
		s.add(function(name:String, end:String) r = 'ok, '+name+end);
		s.dispatch(new Event(['men', '?']));
		Assert.areEqual(r, 'ok, men?');
		s.dispatch('glass', '!');
		Assert.areEqual(r, 'ok, glass!');
		s.removeAllListeners();
	}
	
	@Test
	public function clearDispath():Void
	{
		var r:String;
		var s:Signal = new Signal();
		s.add(function() r = 'ok');
		s.dispatch();
		Assert.areEqual(r, 'ok');
		s.removeAllListeners();
	}
	
	@Test
	public function remove():Void {
		var c:Int = 0;
		var f:Void->Void = function() c++;
		var s:Signal = new Signal();
		s.add(f);
		s.dispatch();
		s.dispatch();
		s.remove(f);
		s.dispatch();
		Assert.areEqual(c, 2);
		Assert.areEqual(Listener.unusedCount(), 0);
		Assert.areEqual(Function.unusedCount, 0);
	}
	
	@Test
	public function removeAll():Void {
		var c:Int = 0;
		var f = function() c++;
		var s:Signal = new Signal();
		s.add(f);
		s.dispatch();
		s.dispatch();
		s.removeAllListeners();
		s.dispatch();
		Assert.areEqual(c, 2);
		Assert.areEqual(Listener.unusedCount(), 0);
		Assert.areEqual(Function.unusedCount, 0);
	}
}