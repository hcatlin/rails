module ActionView #:nodoc:
  class PathSet < Array #:nodoc:
    def self.type_cast(obj)
      if obj.is_a?(String)
        Template::EagerPath.new(obj)
      else
        obj
      end
    end

    def initialize(*args)
      super(*args).map! { |obj| self.class.type_cast(obj) }
    end

    def <<(obj)
      super(self.class.type_cast(obj))
    end

    def concat(array)
      super(array.map! { |obj| self.class.type_cast(obj) })
    end

    def insert(index, obj)
      super(index, self.class.type_cast(obj))
    end

    def push(*objs)
      super(*objs.map { |obj| self.class.type_cast(obj) })
    end

    def unshift(*objs)
      super(*objs.map { |obj| self.class.type_cast(obj) })
    end

    def find_template(original_template_path, format = nil)
      return original_template_path if original_template_path.respond_to?(:render)
      template_path = original_template_path.sub(/^\//, '')

      each do |load_path|
        if format && (template = load_path.find_template("#{template_path}.#{format}"))
          return template
        elsif template = load_path.find_template(template_path)
          return template
        end
      end

      Template.new(original_template_path, self)
    end
  end
end
