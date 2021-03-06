class AppGenerator < VraptorScaffold::Base

  argument :project_path
  class_option :template_engine, :default => "jsp", :aliases => "-t"
  class_option :package, :default => "app", :aliases => "-p"

  def self.source_root
    File.join(File.dirname(__FILE__), "templates")
  end

  def initialize(args, opts=[])
    super([args], opts)
    self.destination_root=(project_path)
    @project_name = project_path.split("/").last
  end

  def create_root_folder
    empty_directory "."
  end

  def create_pom
    template("pom.erb", "pom.xml")
  end

  def create_main_java
    empty_directory Configuration::MAIN_SRC
    directory("src", File.join(Configuration::MAIN_SRC, options[:package].gsub(".", File::Separator)))
  end

  def create_main_resources
    directory("resources", Configuration::MAIN_RESOURCES)
  end

  def create_webapp
    directory("webapp", Configuration::WEB_APP)
    empty_directory Configuration::WEB_INF
  end

  def configure_template_engine
    template("vraptor-scaffold.erb", Configuration::FILENAME)
    template_engine.configure
  end
  
  def template_engine
    templates = {"jsp" => JspTemplateEngine, "ftl" => FreemarkerTemplateEngine}
    templates[options[:template_engine]].new(project_path)
  end

  def create_test
    empty_directory Configuration::TEST_SRC
    directory("src-test", File.join(Configuration::TEST_SRC, options[:package].gsub(".", File::Separator)))
    directory("resources-test", Configuration::TEST_RESOURCES)
  end
end
