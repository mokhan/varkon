require "searchable/version"

module Searchable
  class Error < StandardError; end
  # Your code goes here...

  def is_email?(val)
    val =~ /\A                        # The local-part of addr-spec is specific in section 3.4.1 of RFC 5322.
      [a-z\d!#\$\%&'*+\-\/=?^_`{|}~]+ # It is composed of ASCII alphanumerics plus some puctionation characters
      (?:                             # It mau contain a period, but not as the first character, not as a the last
      \.                            # characters, and two periods must not be next to each other.
      [a-z\d!#\$\%&'*+\-\/=?^_`{|}~]+
      )*
      @
      (?:                             # Hostnames must start with an alphanumeric character, can contain
      [a-z\d]                       # alphanumeric or hyphens, must end with alphanumeric, and max
      (?:                           # label length is 63 chars. RFCs 1122, 1035, 952.
       [a-z\d\-]{0,61}
    [a-z\d]
      )?
      (?:
       \.(?!\z)|\z                 # Label must be separated by periods or must be the end of the string.
      )
      ){2,}                           # Must have at least two labels to be qualified.
    \z/ix
  end

  def is_guid?(val)
    val =~ /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
  end

  def is_hostname?(val)
    val =~ /\A
    (?:                 # Hostnames must start with an alphanumeric character, can contain
    [a-z\d]           # alphanumeric or hyphens, must end with alphanumeric, and min label
    (?:               # length is 1 and max length is 63 chars. RFCs 1122, 1035, 952.
     [a-z\d\-]{0,61}
    [a-z\d]
    )?
    (?:
     \.(?!\z)|\z     # Label must be separated by periods or must be the end of the string.
    )
    ){2,}               # Must have at least two labels to be qualified.
    \z/ix
  end

  def is_ipaddr?(val)
    val =~ /\A((?:(?:25[0-5]|2[0-4]\d|1?\d\d?)(?:\.(?!\z)|\z)){4})\z/
  end

  def is_ipv6?(val)
    IPAddr.new(val).ipv6?
  rescue
    false
  end

  def compress_ipv6(val)
    IPAddr.new(val).to_s
  rescue
    val
  end

  def valid_ip?(address)
    IpList::IPV4_RE.match(address)
  end

  def is_md5?(val)
    val =~ /\A\h{32}\z/
  end

  def is_sha1?(val)
    val =~ /\A\h{40}\z/
  end

  def is_sha256?(val)
    val =~ /\A\h{64}\z/
  end

  def is_url?(val)
    ['http', 'https'].include?(URI.parse(val).scheme) rescue false
  end

  def is_url_partial?(val)
    val =~ /\A            # URL with no scheme.
      (?:                 # Hostnames must start with an alphanumeric character, can contain
      [a-z\d]           # alphanumeric or hyphens, must end with alphanumeric, and min label
      (?:               # length is 1 and max length is 63 chars. RFCs 1122, 1035, 952.
       [a-z\d\-]{0,61}
    [a-z\d]
      )?
      (?:
       \.(?!:|\/)|(?=:|\/)  # Label must be separated by periods or must be followed by a port or path.
      )
      ){2,}               # Must have at least two labels to be qualified.
    (?:
     :\d+\/.*          # Followed by a port number and a path.
     |
     \/.*              # Or followed by a path.
       |
     :\d+              # Or followed by a port number.
    )
      \z/ix and !val.empty? and is_url? "http://#{val}"
  end

  def is_url_or_partial?(val)
    is_url? val or is_url_partial? val
  end

  def escape_sql_wildcards(val)
    val.gsub(/[\\%_]/) { |x| '\\' + x }
  end

  def is_mac_addr?(val)
    val =~ /\A([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]){2}\z/
  end

  def digit?(value)
    value.to_s =~ /^\d+$/
  end

  def is_user_name?(value)
    !is_sha256?(value) && !is_ipaddr?(value)
  end
end
