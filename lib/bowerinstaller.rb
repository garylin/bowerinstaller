require "bowerinstaller/version"
require 'json'

module Bowerinstaller
  extend FileUtils

  require 'bowerinstaller/railtie' if defined?(Rails)
  require "bowerinstaller/dsl"

  def self.packages_order_by_dependencies
    bower_map = JSON.parse(`bower list --map`)
    dep_info = {}
    bower_map.each do |pkg_name, pkg_info|
      deps = pkg_info['dependencies']
      dep_info[pkg_name] = deps ? deps.map { |k, v| k } : []
    end
    dep_order = []

    while !dep_info.empty?
      dep_order += dep_info.map do |pkg_name, deps|
        dep_info[pkg_name] = deps -= dep_order;
        deps.empty? ? pkg_name : nil
      end.compact
      dep_order.each { |pkg_name| dep_info.delete(pkg_name) }
    end
    dep_order
  end

  def self.sourc_type(filename)
    File.extname(filename).gsub(/^\./, '');
  end

  def self.write_file(name, content)
    File.open(Rails.root.join(name), 'w') { |file| file.write(content) }
  end

  def self.install(bower_config)
    write_file('bower.json', bower_config.to_bower_json)

    # get dependency
    sh 'bower install'

    # perform installation
    default_source_list = JSON.parse(`bower list --paths`)
    install_log = {}
    bower_config.groups.each do|grp|
      grp[:packages].each do |pkg|
        srcs = pkg[:sources] || [default_source_list[pkg[:name].to_s]].flatten || []
        srcs.each do |src|
          src_path = Rails.root.join('components', pkg[:name].to_s)
          s = pkg[:sources] ? src_path.join(src) : Rails.root.join(src)
          s_relative_path = s.sub(/^#{src_path}\//, '')
          t = Rails.root.join(grp[:name].to_s, 'assets', 'components', pkg[:name].to_s, s_relative_path)
          puts "Copy #{pkg[:name].to_s}/#{s_relative_path}"
          FileUtils.mkdir_p t.dirname.to_s
          FileUtils.cp s, t
          (install_log[pkg[:name]] ||= []) << "#{pkg[:name].to_s}/#{s_relative_path}"
        end
      end
    end

    reference_files = {};
    packages_order_by_dependencies.each do |pkg_name|
      (install_log[pkg_name] || []).each do |source|
        (reference_files[sourc_type(source)] ||= []) << source
      end
    end

    reference_files.each do |source_type, sources|
      if (source_type.to_s == 'js')
        path = 'javascripts'
        content = sources.map {|s| "//= require #{s}"}.join("\n");
      elsif (source_type.to_s == 'css')
        path = 'stylesheets'
        content = "/*\n" + sources.map {|s| " *= require #{s}"}.join("\n") + "\n */";
      end

      write_file(Rails.root.join('app','assets', path, "components.#{source_type}"), content) if path
    end
    rm_rf 'bower.json'

  end

  def self.uninstall(bower_config)
    ['vendor', 'lib'].each do |grp|
      rm_rf Rails.root.join('grp[:name].to_s', 'assets', 'components').to_s
    end
    rm_rf Rails.root.join("components")
    rm_rf Rails.root.join('app','assets', "javascripts", "components.js")
    rm_rf Rails.root.join('app','assets', "stylesheets", "components.css")
  end
end
