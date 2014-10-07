-- main package for object oriented programming (single inheritance)
oo = {}

function oo.openpackage()
	for n,v in pairs(oo) do
		if _G[n] ~= nil then
			error("name clash: " .. n .. " is already defined")
		end
		_G[n] = v
		--print ("imported " .. tostring(v) .. " into local namespace")
	end
end


function class (superClass)
	--local self = superClass and superClass:new() or {}
	local self = {}

	self.__class = self
	self.__super = superClass

	self.__index = 	function(t, k) -- t is the instance, k is the requested member
						return self[k] -- the metatable of an instance is the class
					end

	-- define a new constructor for this new class
	function self:new (...)
		local instance = setmetatable({}, self)

		if self. __init then
			self. __init(instance , ...)
		end

		return instance
	end

	local mt = {}

	-- __index is only called if class has not member k
	mt.__index 	= self.__super

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

function oo.Object:issubclass(superclass)
	if self == superclass then
		return true
	end
	if self.__super then
		if self.__super:issubclass(superclass) then return true end
	end
	return false
end

function oo.Object:isinstance(class)
	return self.__class:issubclass(class)
end
