require 'yaml'
 
module Gigante
  class Config
    CONFIG_YAMLS = [ # IN ORDER OF RELEVANCE
      'gigante.yml',
      '~/.gigante/settings.yml',
      '/etc/gigante/settings.yml'
    ].reverse
    
    attr_accessor :soptions
    
    def initialize
      CONFIG_YAMLS.find_all{|f| File.file? f}.each do |yaml|
        load_from_yaml yaml
      end
    end
    
    def configure(config_file)
      load_from_yaml config_file
    end
 
    private
      def load_from_yaml(file)
        @options = YAML.load(File.read(file))
      end
  end
end