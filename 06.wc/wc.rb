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
LINE_COUNT_ONLY = opts['l']

def count_and_output_args(text, filename: nil)
  line_count = count_lines(text)
  word_count = count_words(text)
  byte_count = count_bytes(text)
  if LINE_COUNT_ONLY
    print_values(line_count, filename: filename)
  else
    print_values(line_count, word_count, byte_count, filename: filename)
  end
  [line_count, word_count, byte_count]
end

filenames = ARGV

if filenames.empty?
  input = $stdin.read
  count_and_output_args(input)
end

total_line_count = 0
total_word_count = 0
total_byte_count = 0
filenames.each do |filename|
  text = File.read(filename)
  line_count, word_count, byte_count = count_and_output_args(text, filename: filename)

  total_line_count += line_count
  total_word_count += word_count
  total_byte_count += byte_count
end

if filenames.size >= 2
  if LINE_COUNT_ONLY
    print_values(total_line_count, filename: 'total')
  else
    print_values(total_line_count, total_word_count, total_byte_count, filename: 'total')
  end
end
