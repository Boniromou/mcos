module MCOS
  module Authorizers
    class TGP
      class Bearer < Citrine::Warden::Authorizer::Bearer

        def default_bearer; "TGP"; end
        def default_header_field_prefix; "X-Tgp"; end
        def default_signature_algorithm; "SHA1"; end
        def default_datetime_format; "%Y-%m-%dT%H:%M:%S.%L"; end
        def default_content_checksum; false; end

        protected

        def canonical_request(verb, path, headers)
          "#{options[:secret_access_key]}#{headers[header_field_datetime]}"
        end
      end
    end
  end
end

