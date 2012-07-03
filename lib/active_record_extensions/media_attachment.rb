module ActiveRecordExtensions
  module MediaAttachment
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def media_attachment(name,kind, options = {})
        raise ArgumentError, "Not a valid kind" unless [:image].include?(kind.to_sym)
        media_type = kind.to_s.classify
        self.send(:has_many, name.to_sym,
                  conditions: {:media_type => kind.to_sym}, 
                  as: :assetable, dependent: :destroy,
                  class_name: media_type, inverse_of: :assetable)
        validations = {}
        if options[:required]
          self.send(:accepts_nested_attributes_for, name.to_sym, allow_destroy: true,:reject_if => proc { |attrs| attrs['asset'].blank? })
          validations.merge!(presence: true)
        end
        self.send(:validates, name,validations) if validations.present?
#        unless options[:disable_setup_init]
#          self.send(:after_initialize, :"setup_#{name}_asset")
#          self.send :define_method, :"setup_#{name}_asset" do
#            validation_name = self.class.validators.select{|validation| validation.attributes.include?(name.to_sym)}.first.try(:class).try(:name)
#            presence_validator  = (validation_name == "ActiveModel::Validations::PresenceValidator") 
#            if self.new_record?
#              self.send(name.to_sym).build
#            end
#          end
#        end
      end
   end
  end
end

