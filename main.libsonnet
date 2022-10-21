local d = import 'doc-util/main.libsonnet';

{
  '#':: d.pkg(
    name='main',
    url='github.com/Cicatrice/net-libsonnet/main.libsonnet',
    help=|||
      this library provides transformation and rendering function for network.
    |||,
  ),

  ip: (import './ip.libsonnet'),
}
