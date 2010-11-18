namespace :tabulator do
  PLUGIN_ROOT = File.dirname(__FILE__) + '/../..'
  ASSET_FILES = { "_tabulator.html.erb" => "app/views/shared/",
                  "tabulator.js" => "public/javascripts/",
                  "tabulator.css" => "public/stylesheets/"}
  
  desc 'Installs required assets'
  task :install do
    verbose = true
    ASSET_FILES.each do |file, path|
      file = File.join(PLUGIN_ROOT, "files", file)
      path = File.join(RAILS_ROOT, path)
      destination = File.join(path, File.basename(file))
      puts " * Copying %-50s to %s" % [file.gsub(PLUGIN_ROOT, ''), destination.gsub(RAILS_ROOT, '')]
      FileUtils.mkpath(path) unless File.directory?(path)
      FileUtils.cp [file], path
    end    
  end
  
  desc 'Removes assets for the plugin'
  task :remove do
    ASSET_FILES.each do |file, path|
      path = File.join(RAILS_ROOT, path)
      path = File.join(path, File.basename(file))
      puts ' * Removing %s' % path.gsub(RAILS_ROOT, '')
      FileUtils.rm [path]
    end
  end
end