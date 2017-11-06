require 'json'

class PokemonController < ApplicationController
  def show
    pokemon_response = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{ params[:id] }")
    pokemon_data = JSON.parse(pokemon_response.body)
    puts pokemon_data["name"]
    render json: { "message": "ok" }
  end
end
