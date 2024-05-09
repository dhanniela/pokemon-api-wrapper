class PokemonController < ApplicationController
    before_action :client
    
    def show
        render json: fetch_pokemon_data
    rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
    end
    
    private
    
    def client
        @client ||= PokeApi::V2::Client.new
    end
    
    def fetch_pokemon_data
        id_or_name = params[:id_or_name]
        client.get_pokemon(id_or_name)
    end
end