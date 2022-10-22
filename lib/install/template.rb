# Install Tinypacker
copy_file "#{__dir__}/config/tinypacker.yml", "config/tinypacker.yml"

if File.exists?(".gitignore")
  append_to_file ".gitignore" do
    "\n/public/packs\n"
  end
end

say "Tinypacker successfully installed", :green
