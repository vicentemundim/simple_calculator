class Calculator < RuGUI::BaseModel
  observable_property :numerical_keys, :initial_value => []
  observable_property :operand
  observable_property :operation
  observable_property :result

  def change_operation_to(operation)
    if has_operand?
      calculate_result
    else
      save_operand
    end

    self.numerical_keys = []
    self.operation = operation
  end

  def has_operand?
    not self.operand.blank?
  end

  def save_operand
    self.operand = Calculator.to_operand(self.numerical_keys)
  end

  def backspace
    self.numerical_keys.pop
  end

  def clear
    reset!
  end

  def calculate_result
    if self.numerical_keys.empty?
      # we don't have a second operand, so there is nothing to be calculated.
      self.result = self.operand
    elsif self.operand.blank?
      # no operand, nothing to do.
    else
      second_operand = Calculator.to_operand(self.numerical_keys)
      self.numerical_keys = []
      send("calculate_#{self.operation}_result", second_operand)
      self.operand = self.result
    end
  end

  def calculate_sum_result(second_operand)
    self.result = self.operand + second_operand
  end

  def calculate_subtraction_result(second_operand)
    self.result = self.operand - second_operand
  end

  def calculate_multiplication_result(second_operand)
    self.result = self.operand * second_operand
  end

  def calculate_division_result(second_operand)
    self.result = self.operand / second_operand
  end

  class << self
    def to_operand(numerical_keys_array)
      numerical_keys_array.join.to_f
    end
  end
end
