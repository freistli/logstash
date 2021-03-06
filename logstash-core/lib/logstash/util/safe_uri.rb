# encoding: utf-8
require "logstash/namespace"
require "logstash/util"

# This class exists to quietly wrap a password string so that, when printed or
# logged, you don't accidentally print the password itself.
class LogStash::Util::SafeURI
  PASS_PLACEHOLDER = "xxxxxx".freeze
  
  extend Forwardable
  
  def_delegators :@uri, :coerce, :query=, :route_from, :port=, :default_port, :select, :normalize!, :absolute?, :registry=, :path, :password, :hostname, :merge, :normalize, :host, :component_ary, :userinfo=, :query, :set_opaque, :+, :merge!, :-, :password=, :parser, :port, :set_host, :set_path, :opaque=, :scheme, :fragment=, :set_query, :set_fragment, :userinfo, :hostname=, :set_port, :path=, :registry, :opaque, :route_to, :set_password, :hierarchical?, :set_user, :set_registry, :set_userinfo, :fragment, :component, :user=, :set_scheme, :absolute, :host=, :relative?, :scheme=, :user
  
  attr_reader :uri
  
  public
  def initialize(arg)    
    @uri = case arg
           when String
             URI.parse(arg)
           when URI
             arg
           else
             raise ArgumentError, "Expected a string or URI, got a #{arg.class} creating a URL"
           end
  end

  def to_s
    sanitized.to_s
  end

  def inspect
    sanitized.to_s
  end

  def sanitized
    return uri unless uri.password # nothing to sanitize here!
    
    safe = uri.clone
    safe.password = PASS_PLACEHOLDER
    safe
  end
end

