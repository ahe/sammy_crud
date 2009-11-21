class SammyCrudGenerator < Rails::Generator::NamedBase
  
  attr_reader :model_name
  attr_reader :view_type
  attr_reader :supported_views  

  def initialize(runtime_args, runtime_options = {})
    super
    @model_name = name
    @supported_views = ['erb', 'haml']
    @view_type = 'erb'
    @view_type = runtime_args[1] if runtime_args[1]
  end
  
  def manifest
    record do |m|
      if supported_views.include?(view_type)
        m.route_resources(plural)
        m.directory("app/views/#{plural}")
        m.template('controller.rb', "app/controllers/#{plural}_controller.rb")
        gen_views(m, view_type)
      else
        puts "* ERROR : #{view_type} is not a supported templating system! (Should be : #{supported_views.join(' or ')})"
      end
    end
  end
  
  def gen_views(m, type)
    m.template("#{type}/index.html.#{type}", "app/views/#{plural}/index.html.#{type}")
    m.template("#{type}/_show.html.#{type}", "app/views/#{plural}/_show.html.#{type}")
    m.template("#{type}/_model.html.#{type}", "app/views/#{plural}/_#{model_name}.html.#{type}")
    m.template("#{type}/_form.html.#{type}", "app/views/#{plural}/_form.html.#{type}")
    m.template("#{type}/_new.html.#{type}", "app/views/#{plural}/_new.html.#{type}")
    m.template("#{type}/_edit.html.#{type}", "app/views/#{plural}/_edit.html.#{type}")
    m.template("#{type}/_errors.html.#{type}", "app/views/#{plural}/_errors.html.#{type}")
  end
  
  def plural
    model_name.pluralize
  end
  
  def camel
    model_name.camelcase
  end
  
  def klass
    @klass ||= Kernel.const_get("#{camel}")
  end
  
  def columns
    @columns ||= extract_columns
  end
  
  def extract_columns
    @columns = []
    if klass.respond_to?(:columns)
      klass.columns.each do |column|
        @columns << [column.name, column.type.to_s]
      end
    else # mongomapper
      klass.keys.each do |key, value|
        @columns << [key, value.type.to_s]
      end
    end
    @columns
  end
  
  def field_type(type)
    if type.downcase == 'boolean'
      "check_box"
    elsif type.downcase == 'date'
      "date_select"
    elsif type.downcase == 'datetime' || type.downcase == 'time'
      "datetime_select"
    else
      "text_field"
    end
  end

end