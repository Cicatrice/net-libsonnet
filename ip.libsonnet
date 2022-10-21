local d = import 'doc-util/main.libsonnet';

{
  '#':: d.pkg(
    name='ip',
    url='github.com/jsonnet-libs/xtd/ip.libsonnet',
    help='`ip` implements helper functions for ip addresses and networks calculation',
  ),

    /*
        IPv6 is big endian 8 numbers array ; e.g. fe80::1 is [65152,0,0,0,0,0,0,1] (Jsonnet does not support 128-bit integer)
        IPv4 is integer version of 32-bit IP ; e.g. 127.0.0.1 is 2851995649
    */

    local selflib = self,

    ipv6:: {
        reserved: {
        // https://www.iana.org/assignments/iana-ipv6-special-registry/iana-ipv6-special-registry.xhtml
        loopback: selflib.block([0,0,0,0,0,0,0,1],128),                     // ::1/128
        unspecified: selflib.block([0,0,0,0,0,0,0,0],128),                  // ::/128
        ipv4_mapped: selflib.block([0,0,0,0,0,65535,0,0],96),               // ::ffff:0:0/96
        ipv4_translate: selflib.block([100,65435,0,0,0,0,0,0],96),          // 64:ff9b::/96
        ipv4_local_translate: selflib.block([100,65435,1,0,0,0,0,0],48),    // 64:ff9b:1::/48
        discard: selflib.block([256,0,0,0,0,0,0,0],64),                     // 100::/64
        ietf_protocols: selflib.block([8193,0,0,0,0,0,0,0],23),             // 2001::/23
        teredo: selflib.block([8193,0,0,0,0,0,0,0],32),                     // 2001::/32
        port_control_anycast: selflib.block([8193,1,0,0,0,0,0,1],128),      // 2001:1::1/128
        traversal_relay_anycast: selflib.block([8193,1,0,0,0,0,0,2],128),   // 2001:1::2/128
        benchmarking: selflib.block([8193,2,0,0,0,0,0,0],48),               // 2001:2::/48
        amt: selflib.block([8193,3,0,0,0,0,0,0],32),                        // 2001:3::/32
        as112: selflib.block([8193,4,112,0,0,0,0,0],32),                    // 2001:4:112::/48
        orchidv1: selflib.block([8193,16,0,0,0,0,0,0],28),                  // 2001:10::/28
        orchidv2: selflib.block([8193,32,0,0,0,0,0,0],28),                  // 2001:20::/28
        documentation: selflib.block([8193,3512,0,0,0,0,0,0],28),           // 2001:db8::/32
        "6to4": selflib.block([8194,0,0,0,0,0,0,0],16),                     // 2002::/16
        direct_delegation: selflib.block([9760,79,32768,0,0,0,0,0],48),     // 2620:4f:8000::/48
        unique_local: selflib.block([64512,0,0,0,0,0,0,0],7),               // fc00::/7
        link_local: selflib.block([65152,0,0,0,0,0,0,0],10),                // fe80::/10
        },
    },

    ipv4:: {
        // https://www.iana.org/assignments/iana-ipv4-special-registry/iana-ipv4-special-registry.xhtml
        reserved: {
            this_network: selflib.block(0,8),                               // 0.0.0.0/8
            this_host: selflib.block(0,32),                                 // 0.0.0.0/32
            private_24bit: selflib.block(167772160,8),                      // 10.0.0.0/8
            private_20bit: selflib.block(2886729728,12),                    // 172.16.0.0/12
            private_16bit: selflib.block(3232235520,16),                    // 192.168.0.0/16
            shared_address_space: selflib.block(1681915904,16),             // 100.64.0.0/10
            loopback: selflib.block(2130706433,8),                          // 127.0.0.0/8
            link_local: selflib.block(2851995648,16),                       // 169.254.0.0/16
            private_use: selflib.block(2886729728, 12),                     // 172.16.0.0/12
            ietf_protocols: selflib.block(3221225472,24),                   // 192.0.0.0/24
            ipv4_continuity: selflib.block(3221225472,29),                  // 192.0.0.0/29
            dummy_address: selflib.block(3221225480,32),                    // 192.0.0.8/32
            port_control_anycast: selflib.block(3221225481,32),             // 192.0.0.9/32
            traversal_relay_anycast: selflib.block(3221225482,32),          // 192.0.0.10/32
            nat64_discovery: selflib.block(3221225642,32),                  // 192.0.0.170/32
            dns64_discovery: selflib.block(3221225643,32),                  // 192.0.0.171/32
            documentation_1: selflib.block(3221225984,24),                  // 192.0.2.0/24
            documentation_2: selflib.block(3325256704,24),                  // 198.51.100.0/24
            documentation_3: selflib.block(3405803776,24),                  // 203.0.113.0/24
            as112: selflib.block(3223307264,24),                            // 192.31.196.0/24
            amt: selflib.block(3224682752,24),                              // 192.52.193.0/24
            "6to4": selflib.block(3227017984,24),                           // 192.88.99.0/24
            direct_delegation: selflib.block(3232706560,24),                // 192.175.48.0/24
            benchmarking: selflib.block(3323068416,15),                     // 198.18.0.0/15
            multicast: selflib.block(4026531840, 4),                        // 240.0.0.0/4
            broadcast: selflib.block(4294967295,32),                        // 255.255.255.255/32
        }
    },

    '#identify':: d.fn(
        '`identify` return an array of matching IANA reserved block names.',
        [d.arg('ip', d.T.any)]
    ),
    identify(ip)::
        local ipv = selflib.isIPv(ip);

        local results = std.prune([ 
            if selflib.isIn(ip,selflib["ipv%i"%ipv].reserved[k])
            then k
            else null
        for k in std.objectFields(selflib["ipv%i"%ipv].reserved)]);

        std.map(function(x) "ipv%i.%s" % [ipv,x],
            if std.length(results) == 0
            then ["internet"]
            else results
            )
    ,

    '#isIn':: d.fn(
        'return `true` if `ip` is contained in `block` (e.g. `10.8.5.28` is contained in `block("10.8.4.0",23)`).',
        [
            d.arg('ip', d.T.any),
            d.arg('block', d.T.object),
        ]
    ),
    isIn(ip,block)::
        self.block(ip,block.prefix).addresses.network == block.addresses.network
    ,

    '#isIPv':: d.fn(
        'return `4` if `ip` is IPv4, and `6` if IPv6.',
        [d.arg('ip', d.T.any)]
    ),
    isIPv(ip)::
        if std.isArray(ip)
        then if std.length(ip) >= 2
            then 6
            else 4 
        else if std.isNumber(ip) 
            then 4
        else if std.length(std.findSubstr(".",ip)) == 3
            then 4
            else if std.length(std.findSubstr(":",ip)) >= 2
            then 6
            else error("cannot identify protocol of " + ip)
    ,

    '#parseString':: d.fn(
        'return a numeric version of IPv4, and an array representation of IPv6.',
        [d.arg('ip', d.T.string)]
    ),
    parseString(ip)::
        if selflib.isIPv(ip) == 4
        then
            local ip_parts = std.split(ip,".");
            [(
                std.pow(2,24) * std.parseInt(ip_parts[0])
              + std.pow(2,16) * std.parseInt(ip_parts[1])
              + std.pow(2,8)  * std.parseInt(ip_parts[2])
              +                 std.parseInt(ip_parts[3])
            )]
        else if selflib.isIPv(ip) == 6
            then 
                local ip_parts = std.split(ip,":");

                if std.length(ip_parts) > 8
                then error("invalid IPv6 with more than 8 segments: %s" % ip)
                else if std.length(ip_parts) < 8
                then 
                    local first_zero_index = std.find("",ip_parts)[0];
                    std.map(
                        function(x) std.parseHex(if x == "" then "0" else x),
                        std.mapWithIndex(
                            function(i,x) 
                                if i >= first_zero_index && i <= first_zero_index + (8-std.length(ip_parts))
                                    then "0"
                                else if i > first_zero_index + (8-std.length(ip_parts))
                                    then ip_parts[i-(8-std.length(ip_parts))] 
                                else ip_parts[x]
                            ,
                            std.range(0,7)
                        )
                    )
                else  std.map(function(x) std.parseHex(if x == "" then "0" else x),ip_parts)
        else error("unknown IP format: "+ ip)
        ,

    '#toString':: d.fn(
        'return a string version of IP. When IPv6, you can choose if you need a compressed or uncompressed representation.',
        [
            d.arg('ip', d.T.string),
            d.arg('compressIPv6', d.T.boolean,true),
        ]
    ),
    toString(ip,compressIPv6=true)::
        // identify if IPv4 or IPv6
        if selflib.isIPv(ip) == 6
        // it's IPv6
        then 
            local a = std.join(":", if compressIPv6
            // compressed IPv6
            then 
                local precompressed = [ std.format("%x",s) for s in ip ];
                local zeros_indices = std.find("0", precompressed);
                local zeros_chains = std.mapWithIndex(function(i,x) x-i, zeros_indices);
                local max_chains = std.map(function(x) std.count(zeros_chains,x), zeros_chains);
                local max_chain_size = if std.length(zeros_chains) > 0
                    then std.sort(max_chains)[std.length(zeros_chains)-1]
                    else 0;
                local first_max_chain_index = if std.member(max_chains,max_chain_size) 
                    then zeros_indices[std.find(max_chain_size,max_chains)[0]]
                    else 99;

                std.prune(std.mapWithIndex(function(i,x)
                    if i == first_max_chain_index
                    then ""
                    else if max_chain_size > 1 && std.member(std.range(first_max_chain_index+1,first_max_chain_index+max_chain_size-1),i)
                    then null
                        else x
                 ,precompressed))
            // uncompressed IPv6
            else [ std.format("%04x",s) for s in ip ]
        );
        if std.startsWith(a,":")
        then ":"+a
        else a
        // it's IPv4
        else
            local i = if std.isArray(ip) then ip[0] else ip;
            std.join(".",[
            std.toString(( i >> 24 ) & 255), 
            std.toString(( i >> 16 ) & 255), 
            std.toString(( i >>  8 ) & 255), 
            std.toString(  i         & 255), 
        ])
    ,

    '#block':: d.fn(
        'return a structure with several information related to an IP block.',
        [
            d.arg('ip', d.T.any),
            d.arg('prefix', d.T.number,true),
        ]
    ),
    block(ip,prefix)::
        if selflib.isIPv(ip) == 6
        then
        {
            local block = self,

#            size:: error("Jsonnet does not support 128-bit number and will return inconsistant value"),
#            usable_addresses:: self.size,
            prefix: prefix,

            addresses: {
                netmask: [    std.pow(2,16)-std.pow(2,std.clamp(16*(1+s)-prefix,0,16))    for s in std.range(0,7)    ],
                wildcard: [ 65535 ^ self.netmask[s]  for s in std.range(0,7)],
                network: [    ip[s] & self.netmask[s]  for s in std.range(0,7) ],
                first: selflib.addIPv6(self.network, [0,0,0,0,0,0,0,1]),
                last: selflib.addIPv6(self.broadcast, [0,0,0,0,0,0,0,-1]),
                broadcast: selflib.addIPv6(self.network, self.wildcard), 
            },

            range: "%s-%s" % [
                selflib.toString(self.addresses.first),
                selflib.toString(self.addresses.last),
            ],

            netstring: "%s/%i" % [selflib.toString(self.addresses.network),self.prefix],
        }
        else
        {
            local block = self,

            size: std.pow(2,32-prefix),
            usable_addresses: self.size-2,
            prefix: prefix,

            addresses: {
                last: self.broadcast - 1,
                first: self.network + 1,
                broadcast: self.network + block.size - 1,
                netmask: ((std.pow(2,32)-1) << (32-block.prefix) ) & (std.pow(2,32)-1),
                network: (if std.isArray(ip) then ip else [ip])[0] & self.netmask,
                wildcard: std.pow(2,32)-1-self.netmask,
            },

            range: "%s-%s" % [
                selflib.toString(self.addresses.first),
                selflib.toString(self.addresses.last),
            ],

            netstring: "%s/%i" % [selflib.toString(self.addresses.network),self.prefix],
        }
        ,

    '#addIPv6':: d.fn(
        'As IPv6 is stored into an array, this function can be used to perform rudimentary `add` operation recursivly.',
        [
            d.arg('ip', d.T.any),
            d.arg('increment', d.T.number,true),
            d.arg('init', d.T.number,[]),
            d.arg('r', d.T.number,0),
        ]
    ),
    addIPv6(ip,increment,init=[],r=0)::
        local l = std.length(init);

        local clampAdd =  function(x=0,y=0,z=0) {
                s: std.clamp(x+y+z,0,65535),
                r: std.clamp(x+y+z,65535,x+y+z)-65535,
        };

        if l == 8
        then init
        else 
            local a = clampAdd(ip[l],increment[l],r);
            selflib.addIPv6(ip, increment, init + [a.s],a.r)
      ,  

}