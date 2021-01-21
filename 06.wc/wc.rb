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

def print_values(*values, filename: nil)
  format_values = values.map { |v| format_value(v) }
  puts [*format_values, filename].compact.join(' ')
end

opts = ARGV.getopts('l')
line_count_only = opts['l']

def count_and_output_values_from_text(text, filename: nil, line_count_only: false)
  line_count = count_lines(text)
  word_count = count_words(text)
  byte_count = count_bytes(text)
  if line_count_only
    print_values(line_count, filename: filename)
  else
    print_values(line_count, word_count, byte_count, filename: filename)
  end
  [line_count, word_count, byte_count]
end

filenames = ARGV

if filenames.empty?
  input = $stdin.read
  count_and_output_values_from_text(input, filename: nil, line_count_only: line_count_only)
end

total_line_count = 0
total_word_count = 0
total_byte_count = 0
filenames.each do |filename|
  text = File.read(filename)
  line_count, word_count, byte_count = count_and_output_values_from_text(text, filename: filename, line_count_only:
      line_count_only)

  total_line_count += line_count
  total_word_count += word_count
  total_byte_count += byte_count
end

if filenames.size >= 2
  if line_count_only
    print_values(total_line_count, filename: 'total')
  else
    print_values(total_line_count, total_word_count, total_byte_count, filename: 'total')
  end
end
