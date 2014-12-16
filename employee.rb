class Employee
  attr_accessor :name, :title, :salary, :boss
  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
  end

  def bonus(multiplier)
    bonus = @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees
  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees

  end

  def bonus(multiplier)
    sum_salary = 0
    @employees.each do |employee|
      sum_salary += employee.salary
        unless employee.employees.nil?
          employee.employees.each do |sub_employee|
          sum_salary += sub_employee.salary
        end
      end
    end
    sum_salary * multiplier
  end
end

ned = Manager.new("Ned", "founder", 1000000, nil, [])
darren = Manager.new("Darren", "TA Manager", 78000, ned, [])
shawna = Employee.new("Shawna", "TA", 12000, darren)
david = Employee.new("David", "TA", 10000, darren)
ned.employees<<darren
darren.employees<<shawna<<david

puts ned.bonus(5)
