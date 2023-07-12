locals {
  config = {
    internalname_a = {
      prefix        = "/foo/"
      stream_source = "rtmp://example.com/live/whatever" # any ffmpeg compatible source
    }
    internalname_b = {
      prefix        = "/bar/"
      stream_source = "rtmp://example.com/live/fizzbuzz"
    }
  }
}

