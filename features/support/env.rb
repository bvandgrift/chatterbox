require 'tempfile'

class ChatterboxWorld
  
  def root
    @root ||= Pathname(__FILE__).join(*%w[.. .. ..]).expand_path
  end
  
  def working_dir
    @working_dir ||= root.join(*%w[tmp cuke_generated]).expand_path
    @working_dir.mkpath
    @working_dir
  end
  
  def chatterbox_lib
    root.join("lib")
  end
  
  def create_file(file_name, contents)
    file_path = File.join(working_dir, file_name)
    File.open(file_path, "w") { |f| f << contents }
  end
  
  def stderr_file
    return @stderr_file if @stderr_file
    @stderr_file =  Tempfile.new('chatterbox_stderr')
    @stderr_file.close
    @stderr_file
  end
  
  def last_stderr
    @stderr
  end
  
  def last_exit_code
    @exit_code
  end
  
  def ruby(args)
    Dir.chdir(working_dir) do
      cmd = %[ruby -I#{chatterbox_lib} -rrubygems #{args} 2> #{stderr_file.path}]
      @stdout = `#{cmd}`
    end
    @stderr = IO.read(stderr_file.path)
    @exit_code = $?.to_i
  end
end

World do
  ChatterboxWorld.new
end
