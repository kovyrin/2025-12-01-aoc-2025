# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'rake'

DAY_RANGE = (1..12).freeze
TEMPLATE_DIR = File.join(__dir__, 'day_template')
PART_FILES = %w[part1.rb part2.rb].freeze

def fetch_day_from_env
  raw = ENV['DAY']
  return nil if raw.nil? || raw.strip.empty?

  Integer(raw, exception: false)
end

def default_day_from_calendar
  today = Date.today
  return today.day if today.month == 12 && DAY_RANGE.cover?(today.day)

  raise 'Default day only works Dec 1-12; set DAY=01..12 to override'
end

def resolved_day
  day_number = fetch_day_from_env || default_day_from_calendar
  unless DAY_RANGE.cover?(day_number)
    raise ArgumentError, 'DAY must be between 01 and 12'
  end

  format('%02d', day_number)
end

def ensure_template_present!
  return if File.directory?(TEMPLATE_DIR)

  raise "Template directory not found at #{TEMPLATE_DIR}"
end

desc 'Scaffold a new Advent of Code day (use DAY=01..12 to override)'
task :day do
  day = resolved_day
  day_dir = File.join(__dir__, "day#{day}")

  if File.directory?(day_dir)
    puts "day#{day} already exists; nothing to do"
    next
  end

  ensure_template_present!
  FileUtils.mkdir_p(day_dir)
  FileUtils.cp_r("#{TEMPLATE_DIR}/.", day_dir)

  PART_FILES.each do |filename|
    path = File.join(day_dir, filename)
    FileUtils.chmod(0o755, path) if File.exist?(path)
  end

  puts "Created day#{day} scaffold in #{day_dir}"
end
