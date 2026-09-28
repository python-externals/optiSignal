local optiSignal = {}
local internal = {}

function optiSignal:Bind(event, func)
	local equiv = internal[event]

	if not equiv then
		local new = Instance.new("BindableEvent")

		local con = event:Connect(function(...)
			new:Fire(...)
		end)

		internal[event] = {
			{},
			new.Event,
			con,
			new
		}

		equiv = internal[event]
	end

	local con = equiv[2]:Connect(func)
	table.insert(equiv[1], con)
end

function optiSignal:Unbind(event)
	local equiv = internal[event]

	if not equiv then
		return
	end

	for _, v in pairs(equiv[1]) do
		v:Disconnect()
	end

	equiv[3]:Disconnect()
	equiv[4]:Destroy()
	internal[event] = nil
end

return optiSignal
