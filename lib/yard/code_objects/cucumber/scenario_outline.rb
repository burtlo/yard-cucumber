

module YARD::CodeObjects::Cucumber

  class ScenarioOutline < NamespaceObject

    attr_accessor :value, :comments, :keyword, :description, :steps, :tags, :feature
    attr_accessor :scenarios, :examples

    def initialize(namespace,name)
      super(namespace,name.to_s.strip)
      @comments = @description = @value = @feature = nil
      @steps = []
      @tags = []
      @scenarios = []
      @examples = []
    end

    def background?
      false
    end

    def outline?
      true
    end
    
    def examples?
      @examples.find {|example| example.rows }
    end
    
    
    class Examples
      
      attr_accessor :name, :line, :keyword, :comments, :rows
      
      # The first row of the rows contains the headers for the table
      def headers
        rows.first
      end
      
      # The data of the table starts at the second row. When there is no data then
      # return a empty string.
      def data
        rows ? rows[1..-1] : ""
      end
      
      def values_for_row(row)
        hash = {}

        headers.each_with_index do |header,index|
          hash[header] = data[row][index]
        end

        hash
      end
      
      def to_hash
        hash = {}

        rows.each_with_index do |header,index|
          hash[header] = rows.collect {|row| row[index] }
        end

        hash
      end
      
      def initialize(parameters = {})
        parameters.each {|key,value| send("#{key.to_sym}=",value) if respond_to? "#{key.to_sym}=" }
      end
      
    end
    
  end

end
