Pry::Commands.block_command "write", "Prints a string to a file" do |content, filename, opener|
  path = "#{Dir.pwd}/#{filename}"
  result = target.eval(content)
  File.write(path, result)

  if opener.nil?
    output.puts(path)
  else
   system("#{opener} #{path}")
  end
end
