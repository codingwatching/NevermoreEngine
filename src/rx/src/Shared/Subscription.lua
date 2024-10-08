--[=[
	Subscriptions are used in the callback for an [Observable](/api/Observable). Standard usage
	is as follows.

	```lua
	-- Constucts an observable which will emit a, b, c via a subscription
	Observable.new(function(sub)
		sub:Fire("a")
		sub:Fire("b")
		sub:Fire("c")
		sub:Complete() -- ends stream
	end)
	```
	@class Subscription
]=]

local require = require(script.Parent.loader).load(script)

local MaidTaskUtils = require("MaidTaskUtils")

local ENABLE_STACK_TRACING = false

local Subscription = {}
Subscription.ClassName = "Subscription"
Subscription.__index = Subscription

local SubscriptionStateTypes = {
	PENDING = "pending";
	FAILED = "failed";
	COMPLETE = "complete";
	CANCELLED = "cancelled";
}

--[=[
	Constructs a new Subscription

	@param fireCallback function?
	@param failCallback function?
	@param completeCallback function?
	@param observableSource string?
	@return Subscription
]=]
function Subscription.new(fireCallback, failCallback, completeCallback, observableSource)
	assert(type(fireCallback) == "function" or fireCallback == nil, "Bad fireCallback")
	assert(type(failCallback) == "function" or failCallback == nil, "Bad failCallback")
	assert(type(completeCallback) == "function" or completeCallback == nil, "Bad completeCallback")

	return setmetatable({
		_state = SubscriptionStateTypes.PENDING;
		_source = if ENABLE_STACK_TRACING then debug.traceback() else nil;
		_observableSource = observableSource;
		_fireCallback = fireCallback;
		_failCallback = failCallback;
		_completeCallback = completeCallback;
	}, Subscription)
end

--[=[
	Fires the subscription

	@param ... any
]=]
function Subscription:Fire(...)
	if self._state == SubscriptionStateTypes.PENDING then
		if self._fireCallback then
			self._fireCallback(...)
		end
	elseif self._state == SubscriptionStateTypes.CANCELLED then
		warn("[Subscription.Fire] - We are cancelled, but events are still being pushed")

		if ENABLE_STACK_TRACING then
			print(debug.traceback())
			print(self._source)
			print(self._observableSource)
		end
	end
end

--[=[
	Fails the subscription, preventing anything else from emitting.
]=]
function Subscription:Fail()
	if self._state ~= SubscriptionStateTypes.PENDING then
		return
	end

	self._state = SubscriptionStateTypes.FAILED

	if self._failCallback then
		self._failCallback()
	end

	self:_doCleanup()
end


--[=[
	Returns a tuple of fire, fail and complete functions which
	can be chained into the the next subscription.

	```lua
	return function(source)
		return Observable.new(function(sub)
			sub:Fire("hi")

			return source:Subscribe(sub:GetFireFailComplete())
		end)
	end
	```

	@return function
	@return function
	@return function
]=]
function Subscription:GetFireFailComplete()
	return function(...)
		self:Fire(...)
	end, function(...)
		self:Fail(...)
	end, function(...)
		self:Complete(...)
	end
end

--[=[
	Returns a tuple of fail and complete functions which
	can be chained into the the next subscription.

	```lua
	return function(source)
		return Observable.new(function(sub)
			return source:Subscribe(function(result)
				sub:Fire(tostring(result))
			end, sub:GetFailComplete()) -- Reuse is easy here!
		end)
	end
	```

	@return function
	@return function
]=]
function Subscription:GetFailComplete()
	return function(...)
		self:Fail(...)
	end, function(...)
		self:Complete(...)
	end
end

--[=[
	Completes the subscription, preventing anything else from being
	emitted.
]=]
function Subscription:Complete()
	if self._state ~= SubscriptionStateTypes.PENDING then
		return
	end

	self._state = SubscriptionStateTypes.COMPLETE
	if self._completeCallback then
		self._completeCallback()
	end

	self:_doCleanup()
end

--[=[
	Returns whether the subscription is pending.
	@return boolean
]=]
function Subscription:IsPending()
	return self._state == SubscriptionStateTypes.PENDING
end

function Subscription:_assignCleanup(task)
	assert(self._cleanupTask == nil, "Already have _cleanupTask")

	if MaidTaskUtils.isValidTask(task) then
		if self._state ~= SubscriptionStateTypes.PENDING then
			MaidTaskUtils.doTask(task)
			return
		end

		self._cleanupTask = task
	elseif task ~= nil then
		error("Bad cleanup task")
	end
end

function Subscription:_doCleanup()
	local task = self._cleanupTask
	if not task then
		return
	end

	self._cleanupTask = nil

	-- The validity can change
	if MaidTaskUtils.isValidTask(task) then
		MaidTaskUtils.doTask(task)
	end
end

--[=[
	Cleans up the subscription

	:::tip
	This will be invoked by the Observable automatically, and should not
	be called within the usage of a subscription.
	:::
]=]
function Subscription:Destroy()
	if self._state == SubscriptionStateTypes.PENDING then
		self._state = SubscriptionStateTypes.CANCELLED
	end

	self:_doCleanup()
end

--[=[
	Alias for [Subscription.Destroy].
]=]
function Subscription:Disconnect()
	self:Destroy()
end

return Subscription