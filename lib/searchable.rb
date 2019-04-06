require "searchable/version"

module Searchable
  class Error < StandardError; end

  def email?(value)
    value =~ /\A                        # The local-part of addr-spec is specific in section 3.4.1 of RFC 5322.
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

  def guid?(value)
    value =~ /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
  end

  def hostname?(value)
    value =~ /\A
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

  def ipv4?(value)
    value =~ /\A((?:(?:25[0-5]|2[0-4]\d|1?\d\d?)(?:\.(?!\z)|\z)){4})\z/
  end

  def ipv6?(value)
    IPAddr.new(value).ipv6?
  rescue
    false
  end

  def compress_ipv6(value)
    IPAddr.new(value).to_s
  rescue
    value
  end

  def valid_ip?(address)
    IpList::IPV4_RE.match(address)
  end

  def md5?(value)
    value =~ /\A\h{32}\z/
  end

  def sha1?(value)
    value =~ /\A\h{40}\z/
  end

  def sha256?(value)
    value =~ /\A\h{64}\z/
  end

  def url?(value)
    ['http', 'https'].include?(URI.parse(value).scheme) rescue false
  end

  def partial_url?(value)
    value =~ /\A            # URL with no scheme.
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
      \z/ix and !value.empty? and url? "http://#{value}"
  end

  def escape_sql_wildcards(value)
    value.gsub(/[\\%_]/) { |x| '\\' + x }
  end

  def mac_address?(value)
    value =~ /\A([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]){2}\z/
  end

  def digit?(value)
    value.to_s =~ /^\d+$/
  end
end
