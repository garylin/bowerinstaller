# Bowerinstaller

rake task to install bower packages to rails.  This project is inspired by 
bower, bower-installer, and bower-rails.  The rake task uses bower to
manage the package dependencies and download the required bower packages.  
Then it follows the mechanism similar to bower-installer to install js/css 
to the proper location.  Once that is done, it will then generate a 
component.js and component.css file to require all the installed js/css file.  
component.js/css can then be included by application.js/css.

## Requirement

* [node](http://nodejs.org) ([on github](https://github.com/joyent/node))
* [bower](https://github.com/twitter/bow) installed with npm

## Install
Add this line to your application's Gemfile:

    gem 'bowerinstaller'

## bower.rb
Instead of using bower.json, bowerinstaller uses a DSL approach, similar to 
Gemfile.  bower.rb must be created in your Rails application's root directory.
Here is an example:

``` ruby
group :vendor do  # install package under vendor folder
  package :jquery, "1.8" do # require jquery, version 1.8
    do_not_install  # tell bowerinstall only download jquery for dependency check, we use do_not_install to tell bower that we will include jquery ourselves
  end
  package :handlebars, "1.0.0-rc.3" do
    source 'handlebars.js' # we want to install handlebars.js only.
  end
  package :datatables, "1.9.4" # we do not explicitly say what source to install.  This will install the files as specified in package's package.json's main attribute
end
```
The other support group is :lib.

## Available command

    rake bower:install    # install bower packages
    rake bower:unindstall # uninstall bower packages

## Note
After you run bower:install, the required js/css will be installed under
/vendor/assets/components folder.  It will also generate 
/app/assets/javascripts/components.js and /app/assets/stylesheets/components.js.
You can explicitly require these two files in your application.js and application.css.
This will ensure any vendor packages you add in the future will be automatically
included into your app.
