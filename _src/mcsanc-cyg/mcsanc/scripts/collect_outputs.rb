#!/usr/bin/ruby
include Math
files=ARGV.map{|output| File.new(output,"r")}
outputs=files.map{|file| 
  out=file.readlines
#  out[out.index("OUTPUT\n")+1..-1]
}
combined=[]
combined << outputs[0][0] #process id
combined << outputs[0][1] #---------------------
outputs.each{|output| 
output.shift 
output.shift 
}
fill_line=combined[-1]
  outputs.each{|output| 
		output.delete_at(1)
  }

begin 
  line=""
  ncall=0
  sum_sig=0.0
  sum_err=0.0
  outputs.each{|output| 
    line=output.shift.split
    ncall+=line[2].to_i
    sigma=line[3].to_f
    error_sq=(line[4].to_f)**2
    sum_sig+=sigma/error_sq
    sum_err+=1.0/error_sq
  }
  combined << " %-6s | %-20s | %-20s | %-20s\n"%[line[0], ncall,sum_sig/sum_err,1.0/sqrt(sum_err)]
end while outputs[0][0]!= fill_line
#" CPU usage:\n"
	combined.insert 3,fill_line
  combined << fill_line
combined << " CPU usage:\n"
total=0
user=0
system=0
  outputs.each{|output| 
    line=output.shift
    line=output.shift
    line=output.shift.split
    total+=line[2].to_f
    user+=line[6].to_f
    system+=line[10].to_f
  }
combined << " total = #{total} ; user = #{user} ; system = #{system} ;"
combined+= outputs[0][0..outputs[0].index(" Fixed bin histogramms:\n")]
outputs.map! {|output|
  output[output.index(" Fixed bin histogramms:\n")+1..-1].delete_if{|e| e=="\n"}
}

begin
Dir.mkdir "plots"
rescue
end

begin 
    combined << outputs[0][0]
    hist=File.open("plots/#{outputs[0][0].strip}_f","w+")
    outputs.each{|output| output.shift}
  begin
    line=""
    bin=outputs[0][0].split[0] 
    sum_sig=0.0
    sum_err=0.0
    outputs.each{|output| 
      line=output.shift.split
      sigma=line[1].to_f
      error_sq=(line[2].to_f)**2
			next if error_sq==0.0
      sum_sig+=error_sq==0.0 ? 0.0 : (sigma/error_sq or 0)
      sum_err+=(1.0/error_sq or 0)
    }
    combined << "%-10s   %-10s   %-10s\n"%[bin,sum_sig/sum_err,1.0/sqrt(sum_err)]
    hist << "%-10s   %-10s   %-10s\n"%[bin,sum_sig/sum_err,1.0/sqrt(sum_err)]
  end while not outputs[0][0]=~ /\A\s[^\s]*\s*\z/ and outputs[0][0]!= " Valiable bin histogramms:\n"
  hist.close
end while outputs[0][0]!= " Valiable bin histogramms:\n"
combined << outputs[0][0]
outputs.each{|output| output.shift}

begin 
    combined << outputs[0][0]
    hist=File.open("plots/#{outputs[0][0].strip}_v","w+")
    outputs.each{|output| output.shift}
  begin
    line=""
    bin_l=outputs[0][0].split[0] 
    bin_r=outputs[0][0].split[1] 
    sum_sig=0.0
    sum_err=0.0
    outputs.each{|output| 
      line=output.shift.split
      sigma=line[2].to_f
      error_sq=(line[3].to_f)**2
			next if error_sq==0.0
      sum_sig+=error_sq==0.0 ? 0.0 : (sigma/error_sq or 0)
      sum_err+=(1.0/error_sq or 0)
    }
    combined << "%-10s   %-10s   %-10s   %-10s\n"%[bin_l,bin_r,sum_sig/sum_err,1.0/sqrt(sum_err)]
    hist << "%-10s   %-10s   %-10s   %-10s\n"%[bin_l,bin_r,sum_sig/sum_err,1.0/sqrt(sum_err)]
  end while not outputs[0][0]=~ /\A\s[^\s]*\s*\z/ and not outputs[0].empty?
  hist.close
end while not outputs[0].empty? 

puts combined
