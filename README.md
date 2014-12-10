# bychar

A simple IO wrapper for libraries that tend to read the IO in the following way:

* Only forward
* By a single character
* Without skipping

This is how most of recursive-descent parsers and stateful parsers would work. However,
reading a simple IO object byte by byte in Ruby is very slow. Orders slower in fact.
Therefore, this gem creates a simple wrapper that you can get like this:

    wrapper = Bychar.wrap(io)
    while c = wrapper.read_one_char
      # Do your thang
    end

The wrapper will cache some bytes from the passed IO object which will make parsing
faster when you advance your parser char by char.

## Performance

I told you reading char by char is not the best strategy. On Ruby 1.9:

    Bare IO using read(1):                                 3.400000   1.900000   5.300000 (  5.300798)
    Bychar using StringIO:                                 1.790000   0.010000   1.800000 (  1.795277)
    Bychar using a String buffer:                          1.760000   0.000000   1.760000 (  1.760440)
    Platform-picked Bychar.wrap(io) Bychar::ReaderStrbuf:  1.770000   0.010000   1.780000 (  1.776339)

while on Ruby 1.8 it is kinda sad:

    Bare IO using read(1):                               2.380000   0.000000   2.380000 (  2.393260)
    Bychar using StringIO:                               2.270000   0.010000   2.280000 (  2.275631)
    Bychar using a String buffer:                        2.920000   0.000000   2.920000 (  2.924574)
    Platform-picked Bychar.wrap(io) Bychar::ReaderBare:  2.380000   0.010000   2.390000 (  2.384414)

And on JRuby it's different still:

    Bare IO using read(1):                                1.610000   0.040000   1.650000 (  1.180000)
    Bychar using StringIO:                                0.730000   0.020000   0.750000 (  0.603000)
    Bychar using a String buffer:                         1.040000   0.040000   1.080000 (  0.790000)
    Platform-picked Bychar.wrap(io) Bychar::ReaderIOBuf:  0.560000   0.030000   0.590000 (  0.546000)

As you can see, Bychar will do some work to pick an implementation that makes sense for your Ruby platform.

## Contributing to bychar
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Julik Tarkhanov. See LICENSE.txt for
further details.

