--!strict
--[=[
	Provides access to settings on the client. See [SettingDefinition] which should
	register settings on the server. See [SettingsService] for server component.

	@client
	@class SettingsServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")

local Brio = require("Brio")
local CancelToken = require("CancelToken")
local Maid = require("Maid")
local Observable = require("Observable")
local PlayerSettingsClient = require("PlayerSettingsClient")
local Promise = require("Promise")
local ServiceBag = require("ServiceBag")
local SettingsCmdrUtils = require("SettingsCmdrUtils")

local SettingsServiceClient = {}

export type SettingsServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
		_maid: Maid.Maid,
		_settingsDataService: any,
	},
	{} :: typeof({ __index = SettingsServiceClient })
))

--[=[
	Initializes the setting service. Should be done via ServiceBag.

	@param serviceBag ServiceBag
]=]
function SettingsServiceClient.Init(self: SettingsServiceClient, serviceBag: ServiceBag.ServiceBag)
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	-- External
	self._serviceBag:GetService(require("CmdrServiceClient"))

	-- Internal
	self._settingsDataService = self._serviceBag:GetService(require("SettingsDataService"))

	-- Binders
	self._serviceBag:GetService(require("PlayerSettingsClient"))
end

function SettingsServiceClient.Start(self: SettingsServiceClient)
	self:_setupCmdr()
end

--[=[
	Gets the local player settings
	@return PlayerSettingsClient | nil
]=]
function SettingsServiceClient.GetLocalPlayerSettings(
	self: SettingsServiceClient
): PlayerSettingsClient.PlayerSettingsClient?
	return self:GetPlayerSettings(Players.LocalPlayer)
end

--[=[
	Observes the local player settings in a brio

	@return Observable<Brio<PlayerSettingsClient>>
]=]
function SettingsServiceClient.ObserveLocalPlayerSettingsBrio(self: SettingsServiceClient): Observable.Observable<
	Brio.Brio<PlayerSettingsClient.PlayerSettingsClient>
>
	return self:ObservePlayerSettingsBrio(Players.LocalPlayer)
end

--[=[
	Observes the local player settings

	@return Observable<PlayerSettingsClient | nil>
]=]
function SettingsServiceClient.ObserveLocalPlayerSettings(self: SettingsServiceClient): Observable.Observable<
	PlayerSettingsClient.PlayerSettingsClient
>
	return self:ObservePlayerSettings(Players.LocalPlayer)
end

--[=[
	Promises the local player settings

	@param cancelToken CancellationToken
	@return Promise<PlayerSettingsClient>
]=]
function SettingsServiceClient.PromiseLocalPlayerSettings(
	self: SettingsServiceClient,
	cancelToken: CancelToken.CancelToken
): Promise.Promise<PlayerSettingsClient.PlayerSettingsClient>
	return self:PromisePlayerSettings(Players.LocalPlayer, cancelToken)
end

--[=[
	Observes the player settings

	@param player Player
	@return Observable<PlayerSettingsClient | nil>
]=]
function SettingsServiceClient.ObservePlayerSettings(
	self: SettingsServiceClient,
	player: Player
): Observable.Observable<PlayerSettingsClient.PlayerSettingsClient>
	assert(typeof(player) == "Instance" and player:IsA("Player"), "Bad player")

	return self._settingsDataService:ObservePlayerSettings(player)
end

--[=[
	Observes the player settings in a brio

	@param player Player
	@return Observable<Brio<PlayerSettingsClient>>
]=]
function SettingsServiceClient.ObservePlayerSettingsBrio(
	self: SettingsServiceClient,
	player: Player
): Observable.Observable<
	Brio.Brio<PlayerSettingsClient.PlayerSettingsClient>
>
	assert(typeof(player) == "Instance" and player:IsA("Player"), "Bad player")

	return self._settingsDataService:ObservePlayerSettingsBrio(player)
end

--[=[
	Gets a player's settings

	@param player Player
	@return PlayerSettingsClient | nil
]=]
function SettingsServiceClient.GetPlayerSettings(
	self: SettingsServiceClient,
	player: Player
): PlayerSettingsClient.PlayerSettingsClient?
	assert(typeof(player) == "Instance" and player:IsA("Player"), "Bad player")

	return self._settingsDataService:GetPlayerSettings(player)
end

--[=[
	Promises the player's settings

	@param player Player
	@param cancelToken CancellationToken
	@return Promise<PlayerSettingsClient>
]=]
function SettingsServiceClient.PromisePlayerSettings(
	self: SettingsServiceClient,
	player: Player,
	cancelToken: CancelToken.CancelToken
): Promise.Promise<PlayerSettingsClient.PlayerSettingsClient>
	assert(typeof(player) == "Instance" and player:IsA("Player"), "Bad player")

	return self._settingsDataService:PromisePlayerSettings(player, cancelToken)
end

function SettingsServiceClient._setupCmdr(self: SettingsServiceClient)
	local cmdrServiceClient = self._serviceBag:GetService(require("CmdrServiceClient"))

	self._maid:GivePromise(cmdrServiceClient:PromiseCmdr()):Then(function(cmdr)
		SettingsCmdrUtils.registerSettingDefinition(cmdr, self._serviceBag)
	end)
end

function SettingsServiceClient.Destroy(self: SettingsServiceClient)
	self._maid:DoCleaning()
end

return SettingsServiceClient
