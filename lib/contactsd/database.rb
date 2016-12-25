class Contactsd::Database
  include Appscript
  include OSAX

  ATTRIBUTES = {
    adr:        {
                  name: :address,
                  map: [:post_office_box,
                        :extended_address,
                        :street_address,
                        :locality,
                        :region,
                        :postal_code,
                        :country_name].freeze
                }.freeze,
    bday:       {
                  name: :birthday,
                  single: true
                }.freeze,
    categories: {},
    email:      {},
    fburl:      {
                  name: :free_busy_url
                }.freeze,
    fn:         {
                  name: :fullname,
                  single: true
                }.freeze,
    gender:     {},
    geo:        {},
    lang:       {},
    n:          {
                   name: :name,
                   map: [:family_names,
                         :given_names,
                         :additional_names,
                         :honorific_prefixes,
                         :honorific_suffixes].freeze
                }.freeze,
    nickname:   {},
    note:       {},
    org:        {},
    role:       {},
    tel:        {},
    title:      {},
    url:        {},
    uid:        { single: true }.freeze,
  }.freeze

  def initialize(name, timeout)
    @app = app(name)
    @mutex = Mutex.new
    @timeout = timeout # in seconds
    @uidtable = {}
    update_people_vcards!
  end

  def vcards
    update_people_vcards!
    @vcards
  end

  def list
    update_people_vcards!
    vcards.map do |vcard|
      {
        uid: vcard_uid(vcard),
        name: vcard_fullname(vcard)
      }
    end
  end

  def find_vcard_by_uid(uid)
    update_people_vcards!
    vcard = @uidtable[uid]
    if vcard == nil
      raise Contactsd::NotFound, "Error: vcard with UID #{uid} not found!"
    end
    vcard
  end

  def find_by_uid(uid)
    vcard = find_vcard_by_uid(uid)
    hash = {}
    ATTRIBUTES.each do |vcard_name, options|
      new_name = options[:name] || vcard_name

      if (val = vcard.send(vcard_name))
        values = val.map do |attribute|
          value = attribute.values.map { |i| encode(i) }
          if map = options[:map]
            j = {}
            map.each do |key|
              k = value.shift
              j[key] = k unless k.empty?
            end
            value = j
          end

          if attribute.params.empty?
            value
          else
            { value: value }.merge(attribute.params)
          end
        end
        hash[new_name] = options[:single] ? values.join : values
      end
    end
    hash
  end

private

  def vcard_uid(vcard)
    vcard.uid.first.value rescue nil
  end

  def vcard_fullname(vcard)
    encode(vcard.fullname.first.value) rescue nil
  end

  def encode(val)
    val.to_s.force_encoding(Encoding::UTF_8)
  end

  def update_people_vcards!
    if cache_timed_out?
      @mutex.synchronize do
        if cache_timed_out? # avoid double trigger
          @uidtable = {}
          @vcards = @app.people.get.map do |person|
            vcard = VCardigan.parse(person.vcard.get)
            @uidtable[vcard_uid(vcard)] = vcard
            vcard
          end
          @update_at = Time.now
        end
      end
    end
  end

  def cache_timed_out?
    return true unless @updated_at # always true if there was no update yet
    (Time.now - @updated_at) > @timeout
  end
end
