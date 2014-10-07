-- main package for object oriented programming (multiple inheritance)
oo = {}

BaseLayer = "BaseLayer"
ActiveLayers = {BaseLayer}

function oo.openpackage()
	for n,v in pairs(oo) do
		if _G[n] ~= nil then
			error("name clash: " .. n .. " is already defined")
		end
		_G[n] = v
		--print ("imported " .. tostring(v) .. " into local namespace")
	end
end

function oo.search(k, plist)
	for i=1, table.getn(plist) do
		local v = plist[i][k]	-- 'i'-th superclass
		if v then return v end
	end
end


-- creates constructor for a class with superclasses (optional)
function class(...)
	local self = {}

	self.__index = 	function(t, k) -- t is the instance, k is the requested member
						local v = rawget(t, "__members")[k]
						if v then -- is instance variable, so return it
							return v
						else  -- look whether it's a static member
							return getmetatable(t)[k] -- the metatable of an instance is the class
						end
					end

	self.__newindex = 	function(t, k, v)
							rawget(t, "__members")[k] = v
						end

	self.__class = self
	self.__super = arg ~= nil and arg or {}

	self.__layers = {}
	self.__layers.BaseLayer = {}

	-- builds instance and calls (default) constructor(s)
	function self:new (...)
		local instance = setmetatable({}, self)
		rawset(instance, "__members", {}) -- currently obsolete, but can be used to extend COP to instance variable level

		-- call 'real' constructor of class with parameters (...)
		if self.__init then
			self.__init(instance.__members, ...)
		end

		return instance

	end


	local mt = {}

	-- overwrite getter in order to find static members of super classes
	-- __index is only called if class has not member k
	mt.__index 		=	function (t, k)
							-- search this class before searching superclasses, including check for layers
							for i, layer in ipairs(ActiveLayers) do
								local member = nil
								if t.__layers[layer] then
									member = t.__layers[layer][k]
								end

								if member then return member end
							end -- for

							return oo.search(k, arg) -- arg = superclasses
						end

	-- overwrite setter in order to write value in static member of one of the super classes (if present)
	-- __newindex is only called if class has not member k
	mt.__newindex =		function (t, k, v)
							local iUnder = string.find(k, "_")
							if iUnder and iUnder > 1 and string.len(k) > iUnder then -- treat as Layer_function
								-- register layer globally
								local layer = string.sub(k, 1, iUnder - 1)
								local funcName = string.sub(k, iUnder + 1)
								_G[layer] = layer

								-- put function in special subtable in __layers
								t.__layers[layer] = t.__layers[layer] and t.__layers[layer] or {}
								t.__layers[layer][funcName] = v

								return
							end

							t.__layers.BaseLayer[k] = v
						end

	-- return class name if __tostring is not already defined
	if mt.__tostring == nil then
		self.__tostring = function (c)
			if rawget(self, "__name") == nil then
				for n, v in pairs(getfenv()) do
					if v == self then
						rawset(self, "__name", n)
						break
					end
				end
			end
			return rawget(self, "__name")
		end
	end

	return setmetatable(self, mt) -- setmetatable returns self
end


-- top level class
oo.Object = class()

function oo.Object:__init()
  -- nothing to do
end

function oo.Object:subClass()
	return class(self)
end

function oo.Object:superclasses()
	return self.__super
end

function oo.Object:issubclass(superclass)
	if self == superclass then
		return true
	end
	for i=1, table.getn(self.__super) do
		if self.__super[i]:issubclass(superclass) then return true end
	end
	return false
end

function oo.Object:isinstance(class)
	return self.__class:issubclass(class)
end
