require 'json'

class PokemonController < ApplicationController
  def show
    pokemon_response = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{ params[:id] }")
    pokemon_data = JSON.parse(pokemon_response.body)
    puts pokemon_data["name"]

    giphy_response = HTTParty.get("http://api.giphy.com/v1/gifs/search?api_key=#{ ENV["GIPHY_KEY"] }&q=#{ pokemon_data["name"] }&rating=g&limit=1")
    giphy_data = JSON.parse(giphy_response.body)
    puts giphy_data["data"][0]["images"]["fixed_height"]["url"]

    render json: {
      id: pokemon_data["id"],
      name: pokemon_data["name"],
      types: pokemon_data["types"].map { |single_type|
          single_type["type"]["name"]
        },
      url: giphy_data["data"][0]["images"]["fixed_height"]["url"]
    }
  end
end
