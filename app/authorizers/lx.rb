module MCOS
  module Authorizers
    class LX
      class Bearer < Citrine::Warden::Authorizer::Bearer

        def default_bearer; "LX-HS256"; end
        def default_header_field_prefix; "Lx"; end
        def default_signature_algorithm; "SHA256"; end
        def default_datetime_format; "%Y-%m-%dT%H:%M:%S.%L"; end
      end
    end
  end
end


