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
  print args.join(' ')
end

opts = ARGV.getopts('l')
line_count_only = opts['l']
filenames = ARGV

if filenames == []
  input = $stdin.read
  line_count = format_value(count_lines(input))
  word_count = format_value(count_words(input))
  byte_count = format_value(count_bytes(input))
  if line_count_only
    print line_count
  else
    print_values(line_count, word_count, byte_count)
  end
  print "\n"
end

total_line_count = 0
total_word_count = 0
total_byte_count = 0
filenames.each do |filename|
  text = File.read(filename)
  line_count = format_value(count_lines(text))
  if line_count_only
    print_values(line_count, filename)
  else
    word_count = format_value(count_words(text))
    byte_count = format_value(count_bytes(text))
    print_values(line_count, word_count, byte_count, filename)
  end
  print "\n"

  total_line_count += line_count.to_i
  total_word_count += word_count.to_i
  total_byte_count += byte_count.to_i
end

if filenames.size >= 2
  total_line_count = format_value(total_line_count)
  total_word_count = format_value(total_word_count)
  total_byte_count = format_value(total_byte_count)
  if line_count_only
    print_values(total_line_count, 'total')
  else
    print_values(total_line_count, total_word_count, total_byte_count, 'total')
  end
  print "\n"
end
