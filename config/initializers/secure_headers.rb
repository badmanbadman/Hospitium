::SecureHeaders::Configuration.configure do |config|
  config.hsts = {:max_age => "631138519", :include_subdomain => false}
  config.x_frame_options = 'DENY'
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = {:value => 1, :mode => false}
  config.csp = {
    :default_src => "self",
    :report_uri  => '//localhost:3000/content_security_policy/forward_report',
    :img_src     => "*",
    :script_src  => ['*.googleapis.com', 
                     '*.olark.com', 
                     '*.google-analytics.com', 
                     '*.gstatic.com', 
                     'localhost:3000', 
                     'd1pm9e0xzdmxcb.cloudfront.net', 
                     'd4uktpxr9m70.cloudfront.net', 
                     'inline'],
    :style_src   => ['*.googleapis.com', 
                     '*.olark.com', 
                     'localhost:3000', 
                     'd1pm9e0xzdmxcb.cloudfront.net', 
                     'd4uktpxr9m70.cloudfront.net', 
                     'inline'],
    :font_src    => ['*.googleusercontent.com'],
    :connect_src => ['*.olark.com', 
                     'juggernaut-hospitium2.herokuapp.com', 
                     'localhost:3000',
                     'hospitium.co'],
    :frame_src   => ['*.olark.com', 
                     '*.youtube.com'],
    :media_src   => ['*.olark.com']
  }
end