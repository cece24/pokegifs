require 'json'

class PokemonController < ApplicationController
  def show
    render json: { "message": "ok" }
  end
end
