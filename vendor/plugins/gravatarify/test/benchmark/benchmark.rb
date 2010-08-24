require 'gravatarify'
require 'benchmark'

include Gravatarify::Helper
  
emails = ['foo@bar.com', 'foobar_didum_asdf@asdasd.com',
          'ASDASDSA@aasd_ASDSAd.com', ' sad@asdASdssasd.ch', ' didum@asdasd.com  ']
n = 10000
Benchmark.bm(23) do |bm|
  bm.report("gravatar_url w/o args: ") { for i in 1..n do gravatar_url(emails[i % 5]) end }
  bm.report("gravatar_url w/ args:  ") { for i in 1..n do gravatar_url(emails[i % 5], :size => 30, :x => 'foo', 'other' => 'abcdef') end }
  bm.report("gravatar_tag w/o args: ") { for i in 1..n do gravatar_tag(emails[i % 5]) end }
  bm.report("gravatar_tag w/ args:  ") { for i in 1..n do gravatar_tag(emails[i % 5], :size => 30, :x => 'foo', :html => { :class => 'abcdef'}) end }  
end
puts "                         -> each measured #{n} times using for-loop"