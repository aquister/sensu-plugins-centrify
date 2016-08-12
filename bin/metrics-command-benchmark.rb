#!/usr/bin/env ruby
#
# Get the number of seconds it takes to perform a command
#
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/metric/cli'
require 'socket'
require 'benchmark'

class CommandBenchmarkMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.cmd"

  option :cmd,
         short: '-c CMD',
         long:  '--cmd CMD',
         description: 'The command to benchmark',
         required: true

  def run
    cmd = "#{config[:cmd]} 1>/dev/null"
    time = Benchmark.measure { system(cmd) }
    output "#{config[:scheme]}.seconds", time.real
    ok
  end
end
