class Lamb
  extend Searchable
end

RSpec.describe Searchable do
  specify { expect(Searchable::VERSION).not_to be_nil }

  describe '.is_email?' do
    let(:valid_emails  ) { [
      'a1!#$%&\'*+-/=?^_`{|}~@example.com',
      'first.last@somewhere.else.xx',
      'xxx_yyy@zzz.yyy',
      'xxx_yyy@zz-z.yyy',
      'xxx_yyy@1zzz.yyy',
      'foo@xn--maana-pta.com',  # Punnycode for mañana.com
      'foo@xn--bcher-kva.com'   # Punnycode for bücher.com
    ] }
    let(:invalid_emails) { [
      'first..last@somewhere.else.xx',
      '.first.last@somewhere.else.xx',
      'first.last.@somewhere.else.xx',
      'first.last.@bücher.com',
      'mañana@somewhere.else.xx',
      'xxx_yyy@zzz.yyy.',
      'xxx_yyy@zzz-.yyy',
      'xxx_yyy@zzz'
    ] }
    it 'returns true for valid emails' do
      expect(valid_emails.map { |email| Lamb.is_email? email }.all?).to be true
    end
    it 'returns false for invalid emails' do
      expect(invalid_emails.map { |email| Lamb.is_email? email }.any?).to be false
    end
  end
  describe '.is_guid?' do
    let(:valid_guids  ) { (0...5).map { SecureRandom.uuid }}
    let(:invalid_guids) { [
      'e0f57b07-772f-4a41-bccf-aa0e834e2d777',
      'bf50054-9a26-40f5-b0b1-a2e1149ad615',
      '17fd88a624fd417c9589b55d712f83b2',
      'g951b34a-4a00-4d85-b9d7-fb85035ea966'
    ] }
    it 'returns true for valid guids' do
      expect(valid_guids.map { |guid| Lamb.is_guid? guid }.all?).to be true
    end
    it 'returns false for invalid guids' do
      expect(invalid_guids.map { |guid| Lamb.is_guid? guid }.any?).to be false
    end
  end
  describe '.is_hostname?' do
    let(:valid_hostnames  ) { [
      'example.com',
      'somewhere.else.xx',
      'zzz.museum',
      'zz-z.yyy',
      '1zzz.yyy',
      'xn--maana-pta.com',  # Punnycode for mañana.com
      'xn--bcher-kva.com'   # Punnycode for bücher.com
    ] }
    let(:invalid_hostnames) { [
      'foo',
      'bücher.com',
      'zzz.yyy.',
      'zzz-.yyy'
    ] }
    it 'returns true for valid hostnames' do
      expect(valid_hostnames.map { |hostname| Lamb.is_hostname? hostname }.all?).to be true
    end
    it 'returns false for invalid hostnames' do
      expect(invalid_hostnames.map { |hostname| Lamb.is_hostname? hostname }.any?).to be false
    end
  end
  describe '.is_ipaddr?' do
    let(:valid_ips  ) { [
      '192.168.1.1',
      '255.255.255.255',
      '1.1.1.1',
      '200.100.50.25'
    ]}
    let(:invalid_ips) { [
      '256.1.1.1',
      '1.1.1.',
      '1.1.1',
      '1.1.1.1.1',
      '100.256.90.7',
      '1111.10.10.10',
      '1234',
      '192.1.2.2.'
    ] }
    it 'returns true for valid IPs' do
      expect(valid_ips.map { |ip| Lamb.is_ipaddr? ip }.all?).to be true
    end
    it 'returns false for invalid IPs' do
      expect(invalid_ips.map { |ip| Lamb.is_ipaddr? ip }.any?).to be false
    end
  end
  describe '.is_ipv6?' do
    let(:valid_ipv6s) { [
      '2001:0000:1234:0000:0000:C1C0:ABCD:0876',
      'ff02::1',
      '1:2:3:4:5::8',
      '1::5:1.2.3.4',
      'fe80:0:0:0:204:61ff:fe9d:f156',
    ]}
    let(:invalid_ipv6s) { [
      '192.168.1.1',
      '3ffe:0b00:0000:0001:0000:0000:000a',
      ':1111:2222:3333::5555',
      '1::2::3',
    ] }
    it 'returns true for valid IPv6s' do
      expect(valid_ipv6s.map { |ip| Lamb.is_ipv6? ip }.all?).to be true
    end
    it 'returns false for invalid IPs' do
      expect(invalid_ipv6s.map { |ip| Lamb.is_ipv6? ip }.any?).to be false
    end
  end
  describe '.compress_ipv6' do
    it 'compress ipv6 correctly' do
      ipv6 = '3ffe:0b00:0000:0000:0001:0000:0000:000a'

      expect(Lamb.compress_ipv6(ipv6)).to eql('3ffe:b00::1:0:0:a')
    end
  end
  describe '.is_md5?' do
    let(:valid_md5s  ) { (0...5).map { Digest::MD5.new.hexdigest(Random.new.bytes 100) } }
    let(:invalid_md5s) { [
      'g90353988b09c457cd3235403d8c609d',
      '790353988b09c457cd3235403d8c609d1',
      '790353988b09c457cd3235403d8c609'
    ] }
    it 'returns true for valid md5s' do
      expect(valid_md5s.map { |md5| Lamb.is_md5? md5 }.all?).to be true
    end
    it 'returns false for invalid sha256s' do
      expect(invalid_md5s.map { |md5| Lamb.is_md5? md5 }.any?).to be false
    end
  end
  describe '.is_sha1?' do
    let(:valid_sha1s  ) { (0...5).map { Digest::SHA1.new.hexdigest(Random.new.bytes 100) } }
    let(:invalid_sha1s) { [
      'gbeec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33',
      '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a331',
      '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a3'
    ] }
    it 'returns true for valid sha1s' do
      expect(valid_sha1s.map { |sha1| Lamb.is_sha1? sha1 }.all?).to be true
    end
    it 'returns false for invalid sha256s' do
      expect(invalid_sha1s.map { |sha1| Lamb.is_sha1? sha1 }.any?).to be false
    end
  end
  describe '.is_sha256?' do
    let(:valid_sha256s  ) { (0...5).map { Digest::SHA2.new(256).hexdigest(Random.new.bytes 100) } }
    let(:invalid_sha256s) { [
      'g311f1b58387e84e73e85d39df92960d3fba54e6e7e3fd5dc27346c587d33455',
      '77143ed94c9323e313e3f44071e86e6b92e453abf254e87f5ab490967365dddce',
      '173e6a184f955986784a40056c5118c955a6e7676266655a5d21c94aa3b71e3'
    ] }
    it 'returns true for valid sha256s' do
      expect(valid_sha256s.map { |sha256| Lamb.is_sha256? sha256 }.all?).to be true
    end
    it 'returns false for invalid sha256s' do
      expect(invalid_sha256s.map { |sha256| Lamb.is_sha256? sha256 }.any?).to be false
    end
  end
  describe '.is_url?' do
    let(:valid_urls  ) { [
      'http://foo.com',
      'http://www.foo.com',
      'http://www.foo.com/',
      'http://www.foo.com/bar',
      'http://www.foo.com/bar/bah.html',
      'http://www.foo.com:80/bar/bah.html',
      'http://www.foo.com:1234/bar/bah.html',
      'https://www.foo.com:1234/bar/bah.html',
      'https://www.foo.com:1234/bar/bah.htmlhmm',
      'https://www.foo.com:1234/bar/bah.htmlhmm?',
      'https://www.foo.com:1234/bar/bah.htmlhmm?foo=bar',
      'https://www.foo.com:1234/bar/bah.html#hmm?foo=bar&bah=%20',
    ] }
    let(:invalid_urls) { [
      'xxx://www.foo.com',
      '://www.foo.com',
      '//www.foo.com',
      'www.foo.com',
      'http://www .foo.com',
      'foo'
    ] }
    it 'returns true for valid urls' do
      expect(valid_urls.map { |url| Lamb.is_url? url }.all?).to be true
    end
    it 'returns false for invalid urls' do
      expect(invalid_urls.map { |url| Lamb.is_url? url }.any?).to be false
    end
  end
  describe '.is_url_partial?' do
    let(:valid_urls  ) { [
      'www.foo.com/',
      'foo.com/bar',
      'www.foo.com/bar/bah.html',
      'www.foo.com:1234',
      'foo.com:1234/bar/bah.html',
      'www.foo.com:1234/bar/bah.htmlhmm?',
      'www.foo.com:1234/bar/bah.htmlhmm?foo=bar',
      'foo.com:1234/bar/bah.html#hmm?foo=bar&bah=%20',
    ] }
    let(:invalid_urls) { [
      'com',
      '://www.foo.com/',
      '//www.foo.com:433',
      'www.foo.com?foo=bar',
      'www .foo.com:80',
      'foo.com:',
      'http://'
    ] }
    it 'returns true for valid partial urls' do
      expect(valid_urls.map { |url| Lamb.is_url_partial? url }.all?).to be true
    end
    it 'returns false for invalid partial urls' do
      expect(invalid_urls.map { |url| Lamb.is_url_partial? url }.any?).to be false
    end
  end
  describe '.escape_sql_wildcards' do
    it 'escapes SQL LIKE wildcards' do
      expect(Lamb.escape_sql_wildcards('\\ % _')).to eq '\\\\ \% \_'
    end
  end

  describe '.is_macaddr?' do
    let(:valid_macs) { [
      '00:01:02:03:04:05',
      'AA:BC:0C:91:DE:FF',
      'AA-BB-CC-DD-EE-FF'
    ]}

    let(:invalid_macs) {[
      '00::0A::0B::0C::0D::0E',
      '00*0B*0C*0D*11*22',
      'FG:01:00:BC:DF:ZZ',
      '999:100:AAA:BBB:CCC:DDD'
    ]}

    it 'returns true for valid macs' do
      expect(valid_macs.map { |mac| Lamb.is_mac_addr? mac }.all?).to be true
    end

    it 'returns false for valid macs' do
      expect(invalid_macs.map { |mac| Lamb.is_mac_addr? mac }.any?).to be false
    end
  end

  describe '.is_user_name?' do
    let(:valid_user_names) {[
      'user',
      'user@MACHINE',
      'a@system',
      'u@system',
      'user name',
      'user name 123@DOMAIN']}
    let(:invalid_user_names) {[
      '127.0.0.1',
      '255.0.0.0',
      Digest::SHA2.new(256).hexdigest(Random.new.bytes 100)]}

    it 'returns true for valid user names' do
      expect(valid_user_names.map { |user_name| Lamb.is_user_name? user_name }.all?).to be true
    end

    it 'returns false for valid user names' do
      expect(invalid_user_names.map { |user_name| Lamb.is_user_name? user_name }.any?).to be false
    end
  end
end
