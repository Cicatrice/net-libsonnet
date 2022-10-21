local net = import './main.libsonnet';

local trace(v) = std.trace(v, v);

local TestIP =
  local name(case) = 'TestIP:%s failed' % case;

  local ip_b4 = net.ip.block(net.ip.parseString("192.0.2.123"),26);
  local ip_b6 = net.ip.block(net.ip.parseString("2001:db8:c1ca::dead:beef"),42);

  assert ip_b4.netstring == 
              "192.0.2.64/26" :
              name('block IPv4');
  assert ip_b6.netstring ==
              "2001:db8:c1c0:/42" :
              name('block IPv6');
  assert net.ip.toString(ip_b4.addresses.last) ==
              "192.0.2.126" :
              name('toString IPv4'); 
  assert net.ip.toString(ip_b6.addresses.first,true) == 
              "2001:db8:c1c0::1" : 
              name('toString IPv6'); 
  assert net.ip.toString(ip_b6.addresses.first,false) == 
              "2001:0db8:c1c0:0000:0000:0000:0000:0001" : 
              name('toString IPv6 uncompressed'); 
  assert net.ip.identify(net.ip.parseString("192.0.2.45")) == ['ipv4.documentation_1'] : name('identify IPv4');
  assert net.ip.identify(net.ip.parseString("2001:db8:c1ca::dead:beef")) == ['ipv6.documentation'] : name('identify IPv6');
  true;

true
&& TestIP