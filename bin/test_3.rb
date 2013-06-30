# encoding=us-ascii

# this is a test program for an exception that is thrown in JRuby
# see http://markmail.org/message/e2ote7rkwht2quel?q=list:org.codehaus.jruby.user

#row = "A" * 300 # does NOT fail with this value of `row`
row = "A" * 301
count = 5_000_000

csv_string = row * count
encoded_string = csv_string.encode("utf-8")
