local obj = {}

obj.name = "EscapeInputEnglish"
obj.version = "0.1"
obj.author = "Poby"
obj.license = "MIT"

obj.inputSource = "com.apple.keylayout.ABC"
obj.escapeHotkey = nil

function obj:setInputSource(sourceId)
	self.inputSource = sourceId
	return self
end

function obj:escape()
	local currentSource = hs.keycodes.currentSourceID()

	if currentSource ~= self.inputSource then
		hs.keycodes.currentSourceID(self.inputSource)
	end

	if self.escapeHotkey then
		self.escapeHotkey:disable()
	end

	hs.eventtap.keyStroke({}, "escape", 0)

	if self.escapeHotkey then
		self.escapeHotkey:enable()
	end

	return self
end

function obj:start()
	if self.escapeHotkey then
		return self
	end

	self.escapeHotkey = hs.hotkey.new({}, "escape", function()
		self:escape()
	end)

	self.escapeHotkey:enable()
	return self
end

function obj:stop()
	if self.escapeHotkey then
		self.escapeHotkey:disable()
		self.escapeHotkey = nil
	end

	return self
end

return obj
