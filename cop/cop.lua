BaseLayer = "BaseLayer"
ActiveLayers = {BaseLayer} -- the currently active Layers. First element is the first activated layer (most outer scope), last element is BaseLayer

-- activates a layer. Second parameter is optional
function activateLayer(layer, position)
	if not layer then error("Layer doesn't exist") end
	if not position then position = #ActiveLayers end
	table.insert(ActiveLayers, position, layer)
end

-- deactivates a layer and returns the position where it was in the ActiveLayers
function deactivateLayer(layer)
	if not layer then error("Layer doesn't exist") end
	for i,v in ipairs(ActiveLayers) do
		if v == layer then
			table.remove(ActiveLayers, i)
			return i
		end
	end
end

-- layer_s can be one layer or a table with multiple layers, block is a function that contains the code that should be executed with these layers
function with(layer_s, block)
	local typ = type(layer_s)
	if typ == "string" then
		activateLayer(layer_s)
		block()
		deactivateLayer(layer_s)
	elseif typ == "nil" then
		error("Layer doesn't exist")
	else -- layer_s is a table
		for i=1, #layer_s do
			activateLayer(layer_s[i])
		end

		block()

		for i=1, #layer_s do
			deactivateLayer(layer_s[i])
		end
	end
end

-- layer_s can be one layer or a table with multiple layers
function without(layer_s, block)
		local typ = type(layer_s)
		if typ == "string" then
			local layerIndex = deactivateLayer(layer_s)
			block()
			if layerIndex then
				activateLayer(layer_s, layerIndex)
			end
		elseif typ==nil then
			error("Layer doesn't exist")
		else
			local layerIndices = {}
			for i=1, #layer_s do
				local index = deactivateLayer(layer_s[i])
				if index then
					table.insert(layerIndices, deactivateLayer(layer_s[i]))
				else
					table.insert(layerIndices, "nil") -- table.insert() doesn't work when trying to insert nil....
				end
			end

			block()

			for i=1, #layer_s do
				if layerIndices[i] ~= "nil" then
					activateLayer(layer_s[i], layerIndices[i])
				end
			end
		end


end

function proceed(...)
	-- select appropriate function
	local currentFunc = debug.getinfo(2, "f").func
	local _, object = debug.getlocal(2, 1) -- self (first argument) of function calling proceed
										   -- possible problem: static methods which don't have a "self" as first argument

	local objectLayers = object.__layers
	local activeLayer = nil
	local activeFuncName = nil
	for layerName, layer in pairs(objectLayers) do
		for funcName, func in pairs(layer) do
			if func == currentFunc then
				activeLayer = layerName
				activeFuncName = funcName
				break
			end
		end
	end

	-- lookup next layer in Stack that has this function
	local currentLayerFound = false
	for i, v in ipairs(ActiveLayers) do
		if not currentLayerFound then
			if v == activeLayer then
				currentLayerFound = true
			end
		else
			if objectLayers[v] and objectLayers[v][activeFuncName] then
				return objectLayers[v][activeFuncName](object, ...)
			end
		end
	end

end

