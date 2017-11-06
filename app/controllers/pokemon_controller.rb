require 'json'

class PokemonController < ApplicationController
  def show
    pokemon_response = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{ params[:id] }")

    if pokemon_response.code == 200
      pokemon_data = JSON.parse(pokemon_response.body)
      puts pokemon_data["name"]

      giphy_response = HTTParty.get("http://api.giphy.com/v1/gifs/random?api_key=#{ ENV["GIPHY_KEY"] }&tag=#{ pokemon_data["name"] }&rating=g")

      if giphy_response.code == 200
        giphy_data = JSON.parse(giphy_response.body)
        puts giphy_data["data"]["image_url"]

        render json: {
          id: pokemon_data["id"],
          name: pokemon_data["name"],
          types: pokemon_data["types"].map { |single_type|
              single_type["type"]["name"]
            },
          gif: giphy_data["data"]["image_url"]
        }
      elsif giphy_response.code == 403
        render :plain => 'Forbidden', :status => '403'
      end

    else
      render :plain => 'Not Found', :status => '404'
    end
  end

  def team
    # define empty team array {}
    pokemon_team = []
    # 6 times, generate random number (within range) and make request to pokemon api, add pokemon into team as hash
    # within times loop, make giphy request and add gif to each pokemon
    6.times do
      random_id = rand(1..120)
      pokemon_response = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{ random_id }")
      pokemon_data = JSON.parse(pokemon_response.body)

      giphy_response = HTTParty.get("http://api.giphy.com/v1/gifs/random?api_key=#{ ENV["GIPHY_KEY"] }&tag=#{ pokemon_data["name"] }&rating=g")
      giphy_data = JSON.parse(giphy_response.body)

      pokemon_team << {
        id: pokemon_data["id"],
        name: pokemon_data["name"],
        types: pokemon_data["types"].map { |single_type|
            single_type["type"]["name"]
          },
        gif: giphy_data["data"]["image_url"]
        }
    end
    puts pokemon_team
    # render team hash as json
    render json: { team: pokemon_team }
  end
end
