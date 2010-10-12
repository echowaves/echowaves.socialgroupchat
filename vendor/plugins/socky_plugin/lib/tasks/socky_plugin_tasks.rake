require 'fileutils'

SOCKY_SCRIPTS = ['/socky.js', '/socky']
SOURCE_PREFIX = File.join(File.dirname(__FILE__), '..', '..', 'assets')
DEST_PREFIX = Rails.root.join('public', 'javascripts').to_s

namespace :socky do
  desc 'Install the Socky scripts and create configuration file'
  task :install => [:create_scripts, :create_config]

  desc 'Update the Socky scripts '
  task :update => [:create_scripts]

  desc 'Remove the Socky scripts'
  task :uninstall => [:remove_scripts]

  task :create_config do
    source = SOURCE_PREFIX + '/socky_hosts.yml'
    dest = Rails.root.join('config', 'socky_hosts.yml').to_s
    if File.exists?(dest)
      puts "Removing #{dest}."
      FileUtils.rm_rf dest
    end
    begin
      puts "Copying to #{dest}."
      FileUtils.cp_r source, dest
      puts "Successfully updated #{dest}."
    rescue
      puts "ERROR: Problem creating config. Please manually copy " + source + " to " + dest
    end
  end


  task :create_scripts do
    SOCKY_SCRIPTS.each do |file_suffix|
      source = SOURCE_PREFIX + file_suffix
      dest = DEST_PREFIX + file_suffix
      if File.exists?(dest)
        puts "Removing #{dest}."
        FileUtils.rm_rf dest
      end
      begin
        puts "Copying to #{dest}."
        FileUtils.cp_r source, dest
        puts "Successfully updated #{dest}."
      rescue
        puts "ERROR: Problem updating scripts. Please manually copy " + source + " to " + dest
      end
    end
  end

  task :remove_scripts do
    SOCKY_SCRIPTS.each do |dest_suffix|
      dest = DEST_PREFIX + dest_suffix
      if File.exists?(dest)
         begin
          puts "Removing #{dest}..."
          FileUtils.rm_rf dest
          puts "Successfully removed #{dest}"
          rescue
          puts "ERROR: Problem removing #{dest}. Please remove manually."
         end
      else
        puts "ERROR: #{dest} not found."
      end
    end
    puts "Successfully removed Socky."
  end

end