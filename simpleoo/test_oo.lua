-- test programm for oop
package.path = "./?.lua"
require "oo"
oo.openpackage()

ObjectInstance = Object:new()
print("Created " .. tostring(ObjectInstance) .. " instance")


-- SubClassA
SubClassA = Object:subClass()

function SubClassA:method()
	return "A method"
end

-- Define members here
function SubClassA:__init(value)
	self.param = value ~= nil and value or 100.0
end

SubClassAInstance = SubClassA:new(150.0)
print("Created " .. tostring(SubClassAInstance) .. " instance")

assert(SubClassAInstance:method() == "A method", "error: member method wasn't called correctly")

-- SubClassB
SubClassB = class(SubClassA)
-- Define members here
function SubClassB:__init()
	SubClassA.__init(self, 888.0) -- call constructor of A
	self.param2 = 200.0
end

SubClassBInstance = SubClassB:new()
print("Created " .. tostring(SubClassBInstance) .. " instance")

-- test single inheritance
assert(SubClassA:issubclass(Object), "error: not subclass")
assert(ObjectInstance:isinstance(Object), "error: not instance of")
--assert(SubClassAInstance:isinstance(SubClassA), "error: not instance of")

assert(SubClassAInstance.param == 150.0, "error: param not equal")

assert(SubClassBInstance:method() == "A method", "error: member method wasn't called correctly")

function SubClassA:method2()
	return "A new method"
end

assert(SubClassBInstance:method2() == "A new method", "error: member method wasn't called correctly")
