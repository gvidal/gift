class OptionValueVariants < ActiveRecord::Base
  belongs_to  :option_value
  belongs_to  :variant
end
