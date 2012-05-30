module ActiveRecordExtensions
  module TimeParser
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      # add your static(class) methods here
      def datepicker_attributes(*args)
        options = args.extract_options!
        args.delete_at(-1) if args[-1].is_a?(Hash)
        args.each do |arg|
          column_type = self.columns_hash[arg.to_s].type
          raise StandardError, "Wrong column declaration, specify a column with date or datetime type" if column_type != :date && column_type != :datetime
          define_method "#{arg.to_s}=" do |date|
            aux_date = nil
            I18n.t('time.datepicker_formats').values.each do |format|
              aux_date = DateTime.strptime(date, format) rescue nil
              break unless aux_date.nil?
            end
            write_attribute(arg.to_sym,aux_date || date)
          end
        end
      end
   end
  end
end
