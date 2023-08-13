require 'otr-activerecord'
require 'rake'

OTR::ActiveRecord.configure_from_file! "db/config.yml"
ActiveRecord::Base.establish_connection(:development)
DB = ActiveRecord::Base.connection

begin
    DB.exec_query('SELECT * FROM alunos;')
    puts "Schema already in place, skipping load."
    
rescue ActiveRecord::StatementInvalid => e
    puts "Error querying the database: #{e.message}"
    puts "Loading Academico database schema"
    system 'rake db:schema:load'
    puts "Schema sucessfully loaded!"
end
