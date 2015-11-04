require "erb"
require "fileutils"
#General class for config generation using @template erb file
class Config_gen
# Initialize new config. Pass given block to +add+.
#   my_config=Config_gen.new {
#     @var1="something"
#     @var2=@var1+" or something else"
#   }
  def initialize(&blk)
    add(&blk)
  end

#Use to change or add multiple config vars.
#+add+ gets block as argument, where one can change config instance variables.
#Example:
#  config.add {
#    @var1="something"
#    @var2=@var1+" or something else"
#  }
  def add(&blk)
    instance_eval &blk if block_given?
  end

#config generation, return a string
#  config.output
  def output
    raise "Set up @template to erb file in your config Class!" if @template.nil?
    ERB.new(File.open(@template,"r").read).result(binding)
  end

# Save config to file. Filename is defined by @filename var in config.
# +save+ takes a directory as argument, default is "share" dir.
#  config.save("my/working/dir/path")
#  config.save #save to share
  def save(dir=File::dirname(__FILE__)+"/../../../share")
    raise "Set up @filename first in your config Class!" if @filename.nil?
    FileUtils.mkdir_p dir if not (File::exist?(dir) and File::directory?(dir))
    path=dir+"/"+@filename
    File.open(path,"w") { |f|
      f.write output
    }
    path
  end

# Make a deep copy of config
#  config.copy
  def copy
    Marshal.load(Marshal.dump(self))
  end
end

