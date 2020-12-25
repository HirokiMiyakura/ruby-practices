# frozen_string_literal: true

# !/usr/bin/env ruby

require 'optparse'
opt = ARGV.getopts('l')
filename = ARGV

private

def count_lines(file)
  file.count("\n").to_s.rjust(7)
end

def count_words(file)
  file.split(/\s+/).size.to_s.rjust(7)
end

def count_bytes(file)
  file.bytesize.to_s.rjust(7)
end

if filename == []
  input = $stdin.read
  input_lines = count_lines(input)
  input_words = count_words(input)
  input_bytes = count_bytes(input)
  if opt['l']
    print input_lines
  else
    print [input_lines, input_words, input_bytes].join(' ')
  end
  print "\n"
end

filename.each do |file|
  lines = count_lines(File.read(file))
  if opt['l']
    print [lines, file].join(' ')
  else
    words = count_words(File.read(file))
    fsize = count_bytes(File.read(file))
    print [lines, words, fsize, file].join(' ')
  end
  print "\n"
end

total_lines = []
total_words = []
total_bytes = []
filename.each do |file|
  lines = File.read(file).count("\n")
  words = File.read(file).split(/\s+/).size
  fsize = File.stat(file).size
  next unless filename.size >= 2

  total_lines << lines
  total_words << words
  total_bytes << fsize
end

if total_lines.size >= 2 && total_words.size >= 2 && total_bytes.size >= 2
  total_lines = total_lines.sum.to_s.rjust(7)
  total_words = total_words.sum.to_s.rjust(7)
  total_bytes = total_bytes.sum.to_s.rjust(7)
  if opt['l']
    print [total_lines, 'total'].join(' ')
  else
    print [total_lines, total_words, total_bytes, 'total'].join(' ')
  end
  print "\n"
end
