# There might be a nicer way to decorate this class but with my limited knowledge could only get this handler
# to be applied after the default constant handler by inheriting from the default constant handler.
# This is required so that the value assigned from the transform is not overridden in the registry by the
# default handler
class YARD::Handlers::Ruby::ConstantTransformHandler < YARD::Handlers::Ruby::ConstantHandler
  include YARD::Handlers::Ruby::StructHandlerMethods
  handles :assign

  namespace_only

  process do
    begin
      if statement[1][0][0] == "Transform"
        name = statement[0][0][0]
        parse_block(statement[1])
        value = statement[1][1].source
        value = substitute(value)
        value = convert_captures(strip_anchors(value))
        register ConstantObject.new(namespace, name) {|o| o.source = statement; o.value = value }
      end
    rescue
      # This supresses any errors where any of the statement elements are out of bounds. 
      # In this case the or in cases where the object being assigned is not a Transform
      # the default constant handler will already have performed the relevant action
    end
  end

  private
  
  # Cucumber's Transform object overrides the to_s function and strips
  # the anchor tags ^$ and any captures so that id it is interpolated in a step definition
  # the it can appear anywhere in the step without being effected by position or captures
  def convert_captures(regexp_source)
    regexp_source
      .gsub(/(\()(?!\?[<:=!])/,'(?:')
      .gsub(/(\(\?<)(?![=!])/,'(?:<')
  end

  def strip_anchors(regexp_source)
    regexp_source.
      gsub(/(^\(\/|\/\)$)/, '').
      gsub(/(^\^|\$$)/, '')
  end

  # Support for interpolation in the Transform's Regex
  def substitute(data)
    until (nested = constants_from_value(data)).empty?
      nested.each {|n| data.gsub!(value_regex(n),find_value_for_constant(n)) }
    end
    data
  end

  def constants_from_value(data)
    escape_pattern = /#\{\s*(\w+)\s*\}/
    data.scan(escape_pattern).flatten.collect { |value| value.strip }
  end

  # Return a regex of the value
  def value_regex(value)
    /#\{\s*#{value}\s*\}/
  end

  def find_value_for_constant(name)
    constant = YARD::Registry.all(:constant).find{|c| c.name == name.to_sym }
    log.warn "ConstantTransformHandler#find_value_for_constant : Could not find the CONSTANT [#{name}] using the string value." unless constant
    constant ? strip_regex_from(constant.value) : name
  end

  # Step the regex starting / and ending / from the value
  def strip_regex_from(value)
    value.gsub(/^\/|\/$/,'')
  end

end
