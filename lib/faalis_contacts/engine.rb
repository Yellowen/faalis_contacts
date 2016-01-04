if File.exists?([File.expand_path("../../../", __FILE__),
                 ".development"].join("/"))
  $LOAD_PATH <<  File.expand_path('../../../../Faalis/lib', __FILE__)
end

require 'faalis'

module FaalisContacts
  class Engine < ::Rails::Engine
    engine_name 'faalis_contacts'

  end
end
