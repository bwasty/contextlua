package.path = "./?.lua"
require "oo.oo"
require "cop.cop"
oo.openpackage()

--- definitions ----
Person = class(Object)

function Person:__init(name, address, employer)
   self.name = name
   self.address = address
   self.employer = employer
end

function Person:toString()
   return "Name: " .. self.name
end

function Person:Address_toString() -- "_" separates layer name from method name
   return proceed() .. "; Contact: " .. self.address;
end

function Person:Employment_toString()
   return proceed() .. "; Employer: " .. self.employer:toString();
end

--

Employer = class(Object)

function Employer:__init(name, address)
   self.name = name
   self.address = address
end

function Employer:toString()
   return "Name: " .. self.name
end

function Employer:Address_toString()
   return proceed() .. "; Visitors: " .. self.address;
end

--- usage ---
employer = Employer:new("Springfield Nuclear Power Plant", "Springfield")
person = Person:new("Homer Simpson", "742 Evergreen Terrace", employer)

print(person:toString())

with(Address, function()    -- also possible: with("Address", ...)
   print(person:toString())
end)

with(Employment, function()
   print(person:toString())
end)

with(Address, function()
   with(Employment, function()
      print(person:toString())
   end)
end)

with({Address, Employment}, function()
   without(Employment, function()
      print(person:toString())
   end)
end)
