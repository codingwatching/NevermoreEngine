---
-- @module MouseShiftLockService
-- See: https://devforum.roblox.com/t/custom-center-locked-mouse-camera-control-toggle/205323

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Nevermore"))

local Players = game:GetService("Players")

local Promise = require("Promise")

local MouseShiftLockService = {}

function MouseShiftLockService:Init()
	self._enabled = Instance.new("BoolValue")
	self._enabled.Value = true

	self._promiseReady = Promise.spawn(function(resolve, reject)
		local playerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
		local playerModuleScript = playerScripts:WaitForChild("PlayerModule")
		local cameraModuleScript = playerModuleScript:WaitForChild("CameraModule")

		local mouseLockControllerScript = cameraModuleScript:WaitForChild("MouseLockController")
		self._cursorImage = mouseLockControllerScript:WaitForChild("CursorImage")
		self._boundKeys = mouseLockControllerScript:WaitForChild("BoundKeys")
		self._lastBoundKeyValues = self._boundKeys.Value

		local ok, err = pcall(function()
			self._playerModule = require(playerModuleScript)
		end)

		if not ok then
			return reject(err)
		end

		resolve()
	end)

	self._promiseReady:Then(function()
		self._enabled.Changed:Connect(function()
			self:_update()
		end)

		if not self._enabled.Value then
			self:_update()
		end
	end)

end

function MouseShiftLockService:EnableShiftLock()
	self._enabled.Value = true
end

function MouseShiftLockService:DisableShiftLock()
	self._enabled.Value = false
end

function MouseShiftLockService:_update()
	assert(self._promiseReady:IsFulfilled())

	if self._enabled.Value then
		self:_updateEnable()
	else
		self:_updateDisable()
	end
end

function MouseShiftLockService:_updateEnable()
	local cameras = self._playerModule:GetCameras()
	local cameraController = cameras.activeCameraController

	self._boundKeys.Value = self._lastBoundKeyValues
	if self._wasMouseLockEnabled then
		-- Fix icon again
		local mouse = Players.LocalPlayer:GetMouse()
		mouse.Icon = self._cursorImage.Value

		cameraController:SetIsMouseLocked(self._wasMouseLockEnabled)
	end
end

function MouseShiftLockService:_updateDisable()
	local cameras = self._playerModule:GetCameras()
	local cameraController = cameras.activeCameraController


	if #self._boundKeys.Value > 0 then
		self._lastBoundKeyValues = self._boundKeys.Value
	end

	self._wasMouseLockEnabled = cameraController:GetIsMouseLocked()
	self._boundKeys.Value = ""

	cameraController:SetIsMouseLocked(false)

	if self._wasMouseLockEnabled then
		-- Reset icon because the camera module doesn't do this properly
		local mouse = Players.LocalPlayer:GetMouse()
		mouse.Icon = ""
	end
end

return MouseShiftLockService