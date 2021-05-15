class MediaResponse
  class Base
    include JSON::Serializable
  end

  class Root < Base
    property payload : Payload
  end

  class Payload < Base
    property value : Value
  end

  class Value < Base
    property href : String
    property iframeSrc : String
  end
end
