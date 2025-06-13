ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# touched on 2025-05-22T23:24:15.599934Z
# touched on 2025-06-13T21:19:19.273762Z