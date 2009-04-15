class MainController < RuGUI::BaseMainController
  def setup_views
    register_view :main_view
  end

  def setup_models
    register_model :calculator
  end

  on :backspace_button, 'clicked' do
    self.calculator.backspace
  end

  on :clear_button, 'clicked' do
    self.calculator.clear
  end

  on :equals_button, 'clicked' do
    self.calculator.calculate_result
  end

  on :main_window, 'delete-event' do
    quit
  end

  (0..9).each do |numerical_key|
    on "num_#{numerical_key}_button", 'clicked' do |widget|
      key = widget.name.match(/num_(\d)_button/)[1]
      self.calculator.numerical_keys << key
    end
  end

  on :decimal_separator_button, 'clicked' do
    self.calculator.numerical_keys << '.' unless self.calculator.numerical_keys.include?('.')
  end

  %w(sum subtraction multiplication division).each do |operation|
    on "#{operation}_operation_button", 'clicked' do |widget|
      operation = widget.name.match(/([a-z]*)_operation_button/)[1]
      self.calculator.change_operation_to(operation)
    end
  end

  def property_numerical_keys_changed(model, new_value, old_value)
    self.main_view.visor.text = new_value.join
  end

  def property_result_changed(model, new_value, old_value)
    self.main_view.visor.text = new_value.to_s
  end
end
