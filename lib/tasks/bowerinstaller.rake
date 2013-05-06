namespace :bower do
  desc "Run bower"

  bower_config = Bowerinstaller::Dsl.new

  task :install do
    Bowerinstaller.install(bower_config)
  end

  # task :update do
  #   gittler.install "#{Rails.root}"
  # end

  task :uninstall do
    Bowerinstaller.uninstall(bower_config)
  end

end

