module TabStructure
  class TabList
    def initialize(partial_to_render, options = {})
      @other_locals = options.delete(:more_locals) || {}
      @partial_to_render = partial_to_render
      @tabs = []
    end
    def add_tab(name, link, options={}, &block)
      tab = @tabs.select{|x| x.link == link}.first
      @tabs << tab = TabStructure::TabInfo.new(link,name, options)
      block.call(tab)
      self
    end

    def tabs
      @tabs
    end
    
    def partial
      @partial_to_render
    end
    
    def locals
      @other_locals.merge({tabs: @tabs})
    end
  end
  class TabInfo
    attr_reader :link, :name, :options
    def initialize(link,name,options = {})
      @link = link.kind_of?(Hash) ? link : {controller: link}
      @name = name
      @options = options
      @highlighteds =  Set.new
      @shows_on = Set.new
      self
    end
    
    def shows_on(link)
      @shows_on << (link.kind_of?(Hash) ? link : {controller: link})
    end
    
    def highlights_on(link)
      @highlighteds << (link.kind_of?(Hash) ? link : {controller: link})
    end
    
    def show?(params)
      has_some_of_the_key_values(@shows_on,params)
    end
    
    def is_highlighted?(params)
      has_some_of_the_key_values(@highlighteds,params)
    end
    
    private
    def has_some_of_the_key_values(array, hash2)
      has_some = false
      array.each do |hash1|
        has_some = has_some || hash1.to_a.inject(true) do |result, element|
          result && hash2[element[0]] == element[1]
        end
      end
      has_some
    end
  end
end

