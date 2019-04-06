class Lamb
  extend Varkon
end

RSpec.describe Varkon do
  specify { expect(Varkon::VERSION).not_to be_nil }

  describe '.email?' do
    [
      'a1!#$%&\'*+-/=?^_`{|}~@example.com',
      'first.last@somewhere.else.xx',
      'xxx_yyy@zzz.yyy',
      'xxx_yyy@zz-z.yyy',
      'xxx_yyy@1zzz.yyy',
      'foo@xn--maana-pta.com',  # Punnycode for mañana.com
      'foo@xn--bcher-kva.com'   # Punnycode for bücher.com
    ].each do |x|
      specify { expect(Lamb.email?(x)).to be_truthy }
    end

    [
      'first..last@somewhere.else.xx',
      '.first.last@somewhere.else.xx',
      'first.last.@somewhere.else.xx',
      'first.last.@bücher.com',
      'mañana@somewhere.else.xx',
      'xxx_yyy@zzz.yyy.',
      'xxx_yyy@zzz-.yyy',
      'xxx_yyy@zzz'
    ].each do |x|
      specify { expect(Lamb.email?(x)).to be_falsey }
    end
  end

  describe '.guid?' do
    (0...5).map { SecureRandom.uuid }.each do |x|
      specify { expect(Lamb.guid?(x)).to be_truthy }
    end

    [
      'e0f57b07-772f-4a41-bccf-aa0e834e2d777',
      'bf50054-9a26-40f5-b0b1-a2e1149ad615',
      '17fd88a624fd417c9589b55d712f83b2',
      'g951b34a-4a00-4d85-b9d7-fb85035ea966'
    ].each do |x|
      specify { expect(Lamb.guid?(x)).to be_falsey }
    end
  end

  describe '.hostname?' do
    [
      'example.com',
      'somewhere.else.xx',
      'zzz.museum',
      'zz-z.yyy',
      '1zzz.yyy',
      'xn--maana-pta.com',  # Punnycode for mañana.com
      'xn--bcher-kva.com'   # Punnycode for bücher.com
    ].each do |x|
      specify { expect(Lamb.hostname?(x)).to be_truthy }
    end

    [
      'foo',
      'bücher.com',
      'zzz.yyy.',
      'zzz-.yyy'
    ].each do |x|
      specify { expect(Lamb.hostname?(x)).to be_falsey }
    end
  end

  describe '.ipv4?' do
    [
      '192.168.1.1',
      '255.255.255.255',
      '1.1.1.1',
      '200.100.50.25'
    ].each do |x|
      specify { expect(Lamb.ipv4?(x)).to be_truthy }
    end

    [
      '256.1.1.1',
      '1.1.1.',
      '1.1.1',
      '1.1.1.1.1',
      '100.256.90.7',
      '1111.10.10.10',
      '1234',
      '192.1.2.2.'
    ].each do |x|
      specify { expect(Lamb.ipv4?(x)).to be_falsey }
    end
  end

  describe '.ipv6?' do
    [
      '2001:0000:1234:0000:0000:C1C0:ABCD:0876',
      'ff02::1',
      '1:2:3:4:5::8',
      '1::5:1.2.3.4',
      'fe80:0:0:0:204:61ff:fe9d:f156',
    ].each do |x|
      specify { expect(Lamb.ipv6?(x)).to be_truthy }
    end

    [
      '192.168.1.1',
      '3ffe:0b00:0000:0001:0000:0000:000a',
      ':1111:2222:3333::5555',
      '1::2::3',
    ].each do |x|
      specify { expect(Lamb.ipv6?(x)).to be_falsey }
    end
  end

  describe '.compress_ipv6' do
    let(:ipv6) { '3ffe:0b00:0000:0000:0001:0000:0000:000a' }

    specify { expect(Lamb.compress_ipv6(ipv6)).to eql('3ffe:b00::1:0:0:a') }
  end

  describe '.md5?' do
    (0...5).map { Digest::MD5.new.hexdigest(Random.new.bytes 100) }.each do |x|
      specify { expect(Lamb.md5?(x)).to be_truthy }
    end

    [
      'g90353988b09c457cd3235403d8c609d',
      '790353988b09c457cd3235403d8c609d1',
      '790353988b09c457cd3235403d8c609'
    ].each do |x|
      specify { expect(Lamb.md5?(x)).to be_falsey }
    end
  end

  describe '.sha1?' do
    (0...5).map { Digest::SHA1.new.hexdigest(Random.new.bytes 100) }.each do |x|
      specify { expect(Lamb.sha1?(x)).to be_truthy }
    end

    [
      'gbeec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33',
      '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a331',
      '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a3'
    ].each do |x|
      specify { expect(Lamb.sha1?(x)).to be_falsey }
    end
  end

  describe '.sha256?' do
    (0...5).map { Digest::SHA2.new(256).hexdigest(Random.new.bytes 100) }.each do |x|
      specify { expect(Lamb.sha256?(x)).to be_truthy }
    end

    [
      'g311f1b58387e84e73e85d39df92960d3fba54e6e7e3fd5dc27346c587d33455',
      '77143ed94c9323e313e3f44071e86e6b92e453abf254e87f5ab490967365dddce',
      '173e6a184f955986784a40056c5118c955a6e7676266655a5d21c94aa3b71e3'
    ].each do |x|
      specify { expect(Lamb.sha256?(x)).to be_falsey }
    end
  end

  describe '.url?' do
    [
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
    ] .each do |x|
      specify { expect(Lamb.url?(x)).to be_truthy }
    end

    [
      'xxx://www.foo.com',
      '://www.foo.com',
      '//www.foo.com',
      'www.foo.com',
      'http://www .foo.com',
      'foo'
    ].each do |x|
      specify { expect(Lamb.url?(x)).to be_falsey }
    end
  end

  describe '.partial_url?' do
    [
      'www.foo.com/',
      'foo.com/bar',
      'www.foo.com/bar/bah.html',
      'www.foo.com:1234',
      'foo.com:1234/bar/bah.html',
      'www.foo.com:1234/bar/bah.htmlhmm?',
      'www.foo.com:1234/bar/bah.htmlhmm?foo=bar',
      'foo.com:1234/bar/bah.html#hmm?foo=bar&bah=%20',
    ].each do |x|
      specify { expect(Lamb.partial_url?(x)).to be_truthy }
    end

    [
      'com',
      '://www.foo.com/',
      '//www.foo.com:433',
      'www.foo.com?foo=bar',
      'www .foo.com:80',
      'foo.com:',
      'http://'
    ].each do |x|
      specify { expect(Lamb.partial_url?(x)).to be_falsey }
    end
  end

  describe '.escape_sql_wildcards' do
    specify { expect(Lamb.escape_sql_wildcards('\\ % _')).to eq('\\\\ \% \_') }
  end

  describe '.mac_address?' do
    [
      '00:01:02:03:04:05',
      'AA:BC:0C:91:DE:FF',
      'AA-BB-CC-DD-EE-FF'
    ].each do |x|
      specify { expect(Lamb.mac_address?(x)).to be_truthy }
    end

    [
      '00::0A::0B::0C::0D::0E',
      '00*0B*0C*0D*11*22',
      'FG:01:00:BC:DF:ZZ',
      '999:100:AAA:BBB:CCC:DDD'
    ].each do |x|
      specify { expect(Lamb.mac_address?(x)).to be_falsey }
    end
  end
end
