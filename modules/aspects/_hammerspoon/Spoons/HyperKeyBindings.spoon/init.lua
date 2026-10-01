local obj = {}

obj.name = "HyperKeyBindings"
obj.version = "0.1"
obj.author = "Poby"
obj.license = "MIT"

obj.hyperKey = "f17"
obj.modal = nil
obj.hotkey = nil
obj.triggered = false
obj.tapAction = nil

function obj:setHyperKey(key)
	self.hyperKey = key
	return self
end

function obj:onTap(fn)
	self.tapAction = fn
	return self
end

function obj:bind(key, fn)
	if not self.modal then
		self.modal = hs.hotkey.modal.new()
	end

	self.modal:bind({}, key, function()
		self.triggered = true
		fn()
	end)

	return self
end

function obj:bindApp(key, appBundleID)
	return self:bind(key, function()
		local app = hs.application.get(appBundleID)
		local front = hs.application.frontmostApplication()

		local isFrontmost = app ~= nil and front ~= nil and app:bundleID() == front:bundleID()

		if isFrontmost then
			hs.eventtap.keyStroke({ "cmd" }, "h", 0)
			app:hide()
		elseif not hs.application.launchOrFocusByBundleID(appBundleID) then
			hs.alert.show("Unable to open application:\n" .. appBundleID)
		end
	end)
end

function obj:bindApps(apps)
	for key, appBundleID in pairs(apps) do
		self:bindApp(key, appBundleID)
	end

	return self
end

function obj:start()
	if self.hotkey then
		return self
	end

	if not self.modal then
		self.modal = hs.hotkey.modal.new()
	end

	self.hotkey = hs.hotkey.bind({}, self.hyperKey, function()
		self.triggered = false
		self.modal:enter()
	end, function()
		self.modal:exit()

		if not self.triggered and self.tapAction then
			if self.tapAction then
				self.tapAction()
			else
				hs.eventtap.keyStroke({}, "escape", 0)
			end
		end
	end)

	return self
end

function obj:stop()
	if self.hotkey then
		self.hotkey:disable()
		self.hotkey = nil
	end

	if self.modal then
		self.modal:exit()
	end

	return self
end

return obj
