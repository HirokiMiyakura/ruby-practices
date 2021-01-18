# frozen_string_literal: true

# !/usr/bin/env ruby
require 'optparse'

def count_lines(file)
  file.count("\n")
end

def count_words(file)
  file.split(/\s+/).size
end

def count_bytes(file)
  file.bytesize
end

def format_value(value)
  value.to_s.rjust(7)
end

def print_values(*args)
  puts args.join(' ')
end

opts = ARGV.getopts('l')
line_count_only = opts['l']
filenames = ARGV

if filenames.empty?
  input = $stdin.read
  line_count = count_lines(input)
  word_count = count_words(input)
  byte_count = count_bytes(input)
  if line_count_only
    puts format_value(line_count)
  else
    print_values(format_value(line_count), format_value(word_count), format_value(byte_count))
  end
end

total_line_count = 0
total_word_count = 0
total_byte_count = 0
filenames.each do |filename|
  text = File.read(filename)
  line_count = count_lines(text)
  word_count = count_words(text)
  byte_count = count_bytes(text)
  if line_count_only
    print_values(format_value(line_count), filename)
  else
    print_values(format_value(line_count), format_value(word_count), format_value(byte_count), filename)
  end

  total_line_count += line_count
  total_word_count += word_count
  total_byte_count += byte_count
end

if filenames.size >= 2
  if line_count_only
    print_values(format_value(total_line_count), 'total')
  else
    print_values(format_value(total_line_count), format_value(total_word_count), format_value(total_byte_count), 'total')
  end
end
