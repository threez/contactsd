class Contactsd::API < Sinatra::Base
  set :sessions, true
  set :environment, 'production'
  set :server, :puma
  set :nophoto, File.read(File.absolute_path('../../../photos/Person.png', __FILE__))

  get '/' do
    content_type 'application/json'
    settings.db.list.map do |entry|
      entry[:links] = {
        details: "/#{entry[:uid]}",
        photo: "/#{entry[:uid]}/photo",
        vcard: "/#{entry[:uid]}/vcard"
      }
      entry
    end.to_json
  end

  get '/:uid' do
    begin
      content_type 'application/json'
      settings.db.find_by_uid(params['uid']).to_json
    rescue Contactsd::NotFound => ex
      raise Sinatra::NotFound, ex.message
    end
  end

  get '/:uid/vcard' do
    begin
      content_type 'text/vcard'
      settings.db.find_vcard_by_uid(params['uid']).to_s
    rescue Contactsd::NotFound => ex
      raise Sinatra::NotFound, ex.message
    end
  end

  get '/:uid/photo' do
    begin
      photo = settings.db.find_vcard_by_uid(params['uid']).photo
      if photo && photo.any?
        photo = photo.first
        content_type "image/#{photo.params["type"].downcase}"
        if photo.params["encoding"] == 'b'
          return Base64.decode64(photo.value)
        else
          STDERR.puts "Error: Unknown image format error for #{photo.inspect}"
        end
      end

      # fallback
      content_type 'image/png'
      settings.nophoto
    rescue Contactsd::NotFound => ex
      content_type 'image/png'
      return settings.nophoto
    end
  end
end
