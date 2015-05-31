#!/usr/bin/env crystal
require("./getopt.cr)
# getopt example

str = "-a -b 123 -ce -d 7 --qwe --asd=456 -- 789" # ARGV
opts, args = GetOpt.getopt(str, "ab:cd:e", ["qwe", "asd="] of String)

p opts
p args