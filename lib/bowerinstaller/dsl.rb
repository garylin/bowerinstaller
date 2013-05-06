require 'json'
module Bowerinstaller
  class Dsl
    def initialize
      @default_options = {}
      eval_file(Rails.root.join('bower.rb'))
    end

    def group name, options={}
      @context = {:packages => []}
      yield
      (@groups ||= []) << @default_options.merge({ :name => name, :packages => @context[:packages]})
    end

    def eval_file(file)
        contents = File.open(file,"r").read
        instance_eval(contents, file.to_s, 1)
    end

    def package name, version=nil, &dsl
      @context[:sources] = [];
      if dsl
        dsl.call()
      else
        @context[:sources] = nil # use default install method
      end
      (@context[:packages] || []) << {:name => name.to_s, :version => version, :sources => @context[:sources]}
    end

    def do_not_install
      @context[:sources]  = []
    end

    def source src
      (@context[:sources] ||= []) << src
    end

    def groups
      @groups
    end

    def to_bower_json
      dependencies = {};

      groups.each do|grp|
        grp[:packages].each do |pkg|
          dependencies[pkg[:name]] = pkg[:version] || 'latest'
        end
      end
      return JSON.pretty_generate( {:dependencies => dependencies} )
    end
  end
end