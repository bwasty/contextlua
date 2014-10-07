-- basic test programm for cop
package.path = "./?.lua"
require "oo.oo"

oo.openpackage()

Person = class(Object)

-- Define members of Person
function Person:__init(name, address, Employee)
	self.name = name
	self.address = address
	self.Employee = Employee
end

function Person:getName()
	return "Name: " .. self.name
end

function Person:getAddress()
	return "Contact: " .. self.address;
end

function Person:getEmployment()
	return "Employee: " .. self.Employee:toString();
end

Person.type = "A Person"

-- static member
function Person:getType()
	return self.type
end


Employee = class(Person)

-- Define members of Employee
function Employee:__init(name, address, Employee_name, Employee_address, yearsEmployed)
	Person:__init(name, address)
	self.Employee_name = Employee_name
	self.Employee_address = Employee_address
	self.yearsEmployed = yearsEmployed and yearsEmployed or 0
end

function Employee:getEmployeeName()
	return "Name: " .. self.name
end

function Employee:getEmployeeAddress()
	return "Visitors: " .. self.address;
end

function Employee:getYearsEmployed()
	return "Years employed: " .. self.yearsEmployed
end

function Employee:raiseYearsEmployed(increment)
	self.yearsEmployed = self.yearsEmployed + increment
end


employee = Employee:new("Homer Simpson", "742 Evergreen Terrace", "Springfield Nuclear Power Plant", "Springfield")


-- standard tests
print(employee:getName())
print(employee:getType())

-- change static member
Employee.type = "An Employed Person"
print(Employee:getType())


print(employee:getYearsEmployed())
employee:raiseYearsEmployed(5)
print(employee:getYearsEmployed())
