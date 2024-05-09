class PokeApi::V2::Client
    API_ENDPOINT = 'https://pokeapi.co/api/v2'.freeze

    ERROR_CODES = {
        404 => 'Pokémon not found',
    }.freeze

    def get_pokemon(id_or_name)
        request(
            http_method: :get,
            endpoint: "pokemon/#{id_or_name}/"
        )
    end

    private

    def client
        @_client ||= Faraday.new(API_ENDPOINT) do |client|
            client.request :url_encoded
            client.adapter Faraday.default_adapter
        end
    end

    def request(http_method:, endpoint:, params: {})
        response = client.public_send(http_method, endpoint, params)
        handle_response(response)
    end

    def handle_response(response)
        if response.success?
            Oj.load(response.body)
        else
            raise ERROR_CODES[response.status] || "Request failed with status #{response.status}"
        end
    end
end
