class Contactsd::CLI < Thor
  class_option 'cache-timeout', default: 5, type: :numeric,
               desc: "in seconds", aliases: :t
  class_option 'contacts-app', default: '/Applications/Contacts.app',
               desc: "Location of the contacts application", aliases: :a
  class_option 'pidfile', default: '/tmp/contactsd.pid',
               desc: "Location of pidfile (must be writable)", aliases: :f
  default_task :serve

  desc 'serve', 'Start serving the RESTful API'
  option :listen, default: 'localhost', desc: "of the RESTful API",
         aliases: :l
  option :port, default: 5000, type: :numeric, desc: "of the RESTful API",
         aliases: :p
  def serve
    pidfile!
    Contactsd::API.tap do |api|
      api.set :bind, options[:listen]
      api.set :port, options[:port]
      api.set :db, database
      api.run!
    end
  end

  desc 'stop', 'Stops the running process if any'
  def stop
    Process.kill(:TERM, File.read(options[:pidfile]).to_i) rescue nil
  end

  desc 'list', 'Lists all available contacts on the cli'
  def list
    database.list.each do |entry|
      puts "%20s %s" % [entry[:id], entry[:name]]
    end
  end

  desc 'vcard UID', 'Get vcard for given uid'
  def vcard(uid)
    puts database.find_vcard_by_uid(uid)
  rescue Contactsd::NotFound => ex
    STDERR.puts ex.message
  end

  desc 'json UID', 'Get json for given uid'
  def json(uid)
    puts JSON.pretty_generate(database.find_by_uid(uid))
  rescue Contactsd::NotFound => ex
    STDERR.puts ex.message
  end
private

  def pidfile!
    pidfile = options[:pidfile]
    PidFile.new(piddir: File.dirname(pidfile),
                pidfile: File.basename(pidfile))
  end

  def database
    @databae ||= Contactsd::Database.new(options['contacts-app'],
                                         options['cache-timeout'])
  end
end