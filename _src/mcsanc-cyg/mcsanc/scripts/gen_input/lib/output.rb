require "ostruct"
require "scanf"
require "rexml/document"
#require "rexml/ultralightparser"
# Parser for mcsanc output
class OpenStruct
  def ls
    marshal_dump.keys
  end
end

class MCSANC_Output < OpenStruct
    include REXML
  # initialize the MCSANC_Output object and parse the output XML file.
  # This method require the MCSANC compiled with tinyxml2 library.
  # Otherwise only born value and error will be parsed from .txt output file.
  #
  # arguments:
  # * path to output file 
  # * run_tag of the job corresponding to MCSANCinput
  #
  # parsed values are saved to @results.born.value and @results.born.erorr
  #  
  #    input=MCSANCinput.new
  #    ewparam=MCSANCewparam.new
  #    session=MCSANC_Session.new(input,ewparam)
  #    session.run_onscreen
  #    output=MCSANC_Output.new(MCSANC_Session.path,MCSANC_Session.input.run_tag)
  #    puts("Born: "+ output.result.sigma.born.value) # print parsed values
  #    puts("Precision: "+ output.result.sigma.born.erorr)
  
  def initialize(file)
    if !File.file?(file) then
      super
      initialize_txt(file)
      return
    end
    @doc=REXML::Document.new(File.open(file,"r").read)
    @ini_hash={}
    node(@doc.root,@ini_hash)
    clean(@ini_hash)
    super(@ini_hash)
  end

  private

  # build the nodes structure recursively
  def node(parent,struct)
    children=parent.elements
    children.each{|ch|
      struct[ch.name]||=[]
      child_struct=nil
      if ch.elements.empty? then
        child_struct=ch.text
      else
        child_struct={}
        node(ch,child_struct)
      end
      struct[ch.name] << child_struct
    }
  end

  # recursively simplify the structure
  def clean(hash)
    hash.each_key{ |k|
      hash[k].map!{|e|
        if e.class==Hash then
          clean(e) 
          OpenStruct.new(e)
        else
          e
        end
      }
      hash[k]=hash[k][0] if hash[k].size==1
    }
  end

  def initialize_txt(xmlfile)
    file=xmlfile.gsub(/\.xml$/,".txt")
    $stderr.puts "WARNING: can't find #{xmlfile} output, trying #{file}"
    $stderr.puts "Only born.value and born.error are available"
    self.result=OpenStruct.new
    self.config=OpenStruct.new
    self.result.sigma=OpenStruct.new
    self.result.sigma.born=OpenStruct.new
    lines=File.open(file,"r").readlines
    lines.each{ |line| 
      if line.match /\s*born\s*\|.*\|/ then 
        self.result.born.value, self.result.born.error=line.scanf("%s %s %d %f %f").pop(2).map{|d| d.to_f}
      end and break
    }
  end
end
