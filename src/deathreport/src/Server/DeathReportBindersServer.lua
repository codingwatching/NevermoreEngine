--[=[
	@class DeathReportBindersServer
]=]

local require = require(script.Parent.loader).load(script)

local Binder = require("Binder")
local BinderProvider = require("BinderProvider")
local PlayerHumanoidBinder = require("PlayerHumanoidBinder")

return BinderProvider.new(script.Name, function(self, serviceBag)
	-- Tracking
	self:Add(PlayerHumanoidBinder.new("DeathTrackedHumanoid", require("DeathTrackedHumanoid"), serviceBag))

	-- Stats
	self:Add(Binder.new("TeamKillTracker", require("TeamKillTracker"), serviceBag))
	self:Add(Binder.new("PlayerKillTracker", require("PlayerKillTracker"), serviceBag))
	self:Add(Binder.new("PlayerDeathTracker", require("PlayerDeathTracker"), serviceBag))
end)
