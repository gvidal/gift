# encoding: utf-8
module ActiveRecordExtensions
  module TokenInput
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:search_methods , :tokens, :type => :string)
#      base.send(:include,InstanceMethods)
#      base.send(:after_initialize, :set_reader_writer_tokens)
#      require 'ruby-debug';debugger;1
#      base.include(InstanceMethods)
#      Dir[Rails.root.join('app/models/*.rb').to_s].each do |filename|
#        require filename #Connection not stablished...
#        klass = File.basename(filename).sub(/.rb$/, '').classify.safe_constantize
#        next unless klass.nil? || klass.ancestors.include?(ActiveRecord::Base)
#        klass.reflect_on_all_associations.each do |association|
#          klass.send(:define_method, "#{association.name.to_s}_tokens") do
#            read_attribute(__method__)
#          end
#          klass.send(:define_method, "#{association.name.to_s}_tokens=") do |value|
#            write_attribute(__method__, self.class.ids_from_tokens(value))
#          end
#        end
#      end
    end
    
#    module InstanceMethods
#      def set_reader_writer_tokens
#        self.class.reflect_on_all_associations.each do |association|
#          self.class.send(:define_method, "#{association.name.to_s}_tokens") do
#            read_attribute(__method__)
#          end
#          self.class.send(:define_method, "#{association.name.to_s}_tokens=") do |value|
#            write_attribute(__method__, self.class.ids_from_tokens(value))
#          end
#        end
#      end
#    end

    
    
    
#    Dir[Rails.root.join('app/models/*.rb').to_s].each do |filename|
#  require filename #Connection not stablished...
#   klass = 
#File.basename(filename).sub(/.rb$/,'').classify.safe_constantize
#   next if klass.blank? || klass.ancestors.blank? || !klass.ancestors.include?(ActiveRecord::Base)
#   klass.reflect_on_all_associations.each do |association|
#    puts "#{association.name.to_s}_tokens"
#     klass.send(:define_method, "#{association.name.to_s}_tokens") do
#       read_attribute(__method__)
#     end
#     if association.macro == :one || association.macro == :belongs_to
#         klass.send(:define_method, "#{association.name.to_s}_tokens=") do |value|
#            # TODO: Set attributes to association or associations
#            write_attribute(__method__.to_s[0..-9].to_sym, self.class.ids_from_tokens(value))
#            write_attribute(__method__, value)
#         end
#     else
#        klass.send(:define_method, "#{association.name.to_s}_tokens=") do |value|
#            # TODO: Set attributes to association or associations
#            write_attribute(__method__.to_s[0..-9].to_sym, self.class.ids_from_tokens(value))
#            write_attribute(__method__, value)
#         end
#     end
#     
#   end
#end
    module ClassMethods
      def ids_from_tokens(tokens)
        tokens.split(',')
      end
      def text_columns()
        self.columns.inject([]) do |result, element|
          result << element.name if element.type == :string || element.type == :text
          result
        end
      end
      def tokens(query, options = {})
        raise StandardError, "query is not a string" unless query.is_a?(String) || query.blank?
        options[:limit] ||= TOKEN_INPUT_LIMIT
        options[:restrictive_search] ||= false
        options[:break_in_words] ||= true
        conditions = self.text_columns.map do |column|
          "#{self.quoted_table_name}.#{column.to_s} REGEXP ?"
        end
        condition_array = []
        condition_array << (options[:restrictive_search] ?  conditions.join(" AND ") : conditions.join(" OR "))
        conditions.length.times do
          if options[:break_in_words]
            condition_array << query.split(" ").map{|string| ActiveRecord::Base.accent_insensitive_regexp(string)}.join("|")
          else
            condition_array << ActiveRecord::Base.accent_insensitive_regexp(query)
          end
        end
        where(condition_array).limit(options[:limit])
      end
      def accent_insensitive_regexp(text)
        text_aux = text.dup
        regexps = ["(a|á|à|â|ã|A|Á|À|Â|Ã)", "(e|é|è|ê|E|É|È|Ê)", "(i|í|ì|I|Í|Ì)", "(o|ó|ò|ô|õ|O|Ó|Ò|Ô|Õ)", "(u|ú|ù|U|Ú|Ù)", "(c|ç|C|Ç)", "(ñ|Ñ)"]
        regexps.each { |exp| text_aux.gsub! Regexp.new(exp), exp }
        text_aux
      end
    end
  end
end