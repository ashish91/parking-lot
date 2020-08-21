def require_folder(dir)
  Dir[File.join(Dir.pwd, dir, '**/*.rb')].sort.each do |file|
    require file
  end
end

require_folder 'errors'
require_folder 'models'
require_folder 'services'
