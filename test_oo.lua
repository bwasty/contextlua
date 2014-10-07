-- test programm for oop
package.path = "./?.lua"
require "oo.oo"
oo.openpackage()

ObjectInstance = Object:new()
print("Created " .. tostring(ObjectInstance) .. " instance")

-- SubClassA
SubClassA = Object:subClass()

-- Define "static" method by calling defineStatic
function SubClassA:staticMethod()
	return "Static function"
end

-- Define static members
SubClassA.staticMember = "Static member"

-- Define members here
function SubClassA:__init(value)
	self.param = value ~= nil and value or 100.0
end

-- Define member function
function SubClassA:foo(number)
	return self.param .. "\t" .. number
end

SubClassAInstance = SubClassA:new(150.0)
print("Created " .. tostring(SubClassAInstance) .. " instance")

assert(SubClassAInstance:foo(42) == "150	42", "error: member method wasn't called correctly")
SubClassAInstance.mymember = "someText"
assert(SubClassAInstance.mymember == "someText", "error: failed to retrieve newly added member (index() or newindex() has failed)")

-- SubClassB
SubClassB = class(SubClassA)
-- Define members here
function SubClassB:__init()
	SubClassA.__init(self, 888.0) -- call constructor of A
	self.param2 = 200.0
end

SubClassBInstance = SubClassB:new()
print("Created " .. tostring(SubClassBInstance) .. " instance")

-- SubClassC
SubClassC = class(SubClassA)
-- Define members here
function SubClassC:__init()
	self.param3 = 300.0
end

SubClassCInstance = SubClassC:new()
print("Created " .. tostring(SubClassCInstance) .. " instance")


-- SubClassD
SubClassD = class(SubClassB, SubClassC)
-- Define members here
function SubClassD:__init(value, value2, value3)
	SubClassB.__init(self) -- call constructor of B
	SubClassC.__init(self) -- call constructor of C
	SubClassA.__init(self, value) -- call constructor of A
	self.param4 = value2
	self.param5 = value3
end

function SubClassD:memberFunction(value)
	return value + 1
end

-- overwrite static members
function SubClassD:staticMethod()
	return "Static function 2"
end
SubClassD.staticMember = "Static member 2"

SubClassDInstance = SubClassD:new(999.0, 400.0, "Euro")
print("Created " .. tostring(SubClassDInstance) .. " instance")

--assert(SubClassAInstance.staticMethod == nil, "error: static member set in instance")

-- test single inheritance
assert(SubClassA:issubclass(Object), "error: not subclass")
assert(ObjectInstance:isinstance(Object), "error: not instance of")
--assert(SubClassAInstance:isinstance(SubClassA), "error: not instance of")

assert(SubClassAInstance.param == 150.0, "error: param not equal")

assert(tostring(SubClassDInstance) == "SubClassD", "error: name not equal")

-- test multiple inheritance
assert(SubClassB:issubclass(SubClassA), "error: is not subclass")
assert(SubClassC:issubclass(SubClassA), "error: is not subclass")
assert(SubClassD:issubclass(SubClassA), "error: is not subclass")
assert(SubClassD:issubclass(SubClassB), "error: is not subclass")
assert(SubClassD:issubclass(SubClassC), "error: is not subclass")

assert(not SubClassB.issubclass(SubClassC), "error: is subclass")
assert(not SubClassC.issubclass(SubClassB), "error: is subclass")

assert(SubClassDInstance.param == 999.0, "error: param not equal") -- defined in A,B,C!
assert(SubClassDInstance.param2 == 200.0, "error: param not equal") -- defined only in B
assert(SubClassDInstance.param3 == 300.0, "error: param not equal") -- defined only in C
assert(SubClassDInstance.param4 == 400.0, "error: param not equal") -- defined only in D
assert(SubClassDInstance.param5 == "Euro", "error: param not equal") -- defined only in D

-- test static members
assert(SubClassA.staticMethod() == "Static function", "error: static member return value not equal")
assert(SubClassA.staticMember == "Static member", "error: static member not equal")

assert(SubClassC.staticMethod() == "Static function", "error: static member return value not equal") -- inheritance test of static members
assert(SubClassC.staticMember == "Static member", "error: static member not equal")

assert(SubClassD.staticMethod() == "Static function 2", "error: static member return value not equal") -- inheritance test of static members
assert(SubClassD.staticMember == "Static member 2", "error: static member not equal")

-- test static members inheritance
SubClassA.staticMember = "Static member changed"
assert(SubClassA.staticMember == "Static member changed", "error: static member not equal")
assert(SubClassC.staticMember == "Static member changed", "error: static member not equal") -- C derives staticMember from A
assert(SubClassCInstance.staticMember == "Static member changed", "error: static member not equal") -- can access static members also via instances (but members are not copied!)

SubClassB.staticMember = "Static member changed one more time" -- now B changes staticMember! (B defines now staticMember)
assert(SubClassA.staticMember == "Static member changed", "error: static member not equal")
assert(SubClassB.staticMember == "Static member changed one more time", "error: static member not equal")
assert(SubClassD.staticMember == "Static member 2", "error: static member not equal") -- unchanged in D, because D has overwritten staticMember itself!

SubClassD.staticMemberNew = "Static member new"
assert(SubClassD.staticMemberNew == "Static member new", "error: static member not equal")

-- assert that an instance is actually a proxy table (contains only "__members"
for k in pairs(SubClassAInstance) do assert(k == "__members", "error: instance proxy table has more keys than '__members': "..k) end

assert(SubClassDInstance:memberFunction(5) == 6, "error: return value of member function not equal")

