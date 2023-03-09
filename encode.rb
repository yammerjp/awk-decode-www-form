require "uri"

puts URI.encode_www_form_component(File.read("/dev/stdin"))
