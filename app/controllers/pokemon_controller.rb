require 'json'

class PokemonController < ApplicationController
  def show
    pokemon_response = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{ params[:id] }")
    pokemon_data = JSON.parse(pokemon_response.body)
    puts pokemon_data["name"]

    render json: {
      id: pokemon_data["id"],
      name: pokemon_data["name"],
      types: pokemon_data["types"].map { |single_type|
        single_type["type"]["name"]
      }
    }
  end
end
