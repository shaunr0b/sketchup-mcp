#!/usr/bin/env ruby

require 'zip'
require 'fileutils'

# Configuration
EXTENSION_NAME = 'su_mcp'
VERSION = '1.0.1'
OUTPUT_NAME = "#{EXTENSION_NAME}_v#{VERSION}.rbz"

# Create temp directory
temp_dir = "#{EXTENSION_NAME}_temp"
FileUtils.rm_rf(temp_dir) if Dir.exist?(temp_dir)
FileUtils.mkdir_p(temp_dir)

# Copy files to temp directory
FileUtils.cp_r('su_mcp', temp_dir)
FileUtils.cp('su_mcp.rb', temp_dir)
FileUtils.cp('extension.json', temp_dir)

# Create zip file
FileUtils.rm(OUTPUT_NAME) if File.exist?(OUTPUT_NAME)

Zip::File.open(OUTPUT_NAME, create: true) do |zipfile|
  Dir["#{temp_dir}/**/**"].each do |file|
    next if File.directory?(file)
    puts "Adding: #{file}"
    zipfile.add(file.sub("#{temp_dir}/", ''), file)
  end
end

# Clean up
FileUtils.rm_rf(temp_dir)

puts "Created #{OUTPUT_NAME}" 