class RestaurantsController < ApplicationController

    def search

    end

    def index
        # restaurant.rbでリクエストの処理
        request = Restaurant.search(params[:lat], params[:lng], params[:radius], params[:freeword], params[:no_smoking],
                                    params[:card], params[:bottomless_cup], params[:buffet], params[:parking], params[:wifi])

        if request.is_a?(String)
            @error = request
            render :search
        else
            @shops = Kaminari.paginate_array(request).page(params[:page]).per(10)
        end


    end
    
    def show
        request = Restaurant.show_search(params[:id])

        if request.is_a?(String)
            @error = request
        else
            @shop = request
        end
        gon.address = @shop.first[:address]

    end
    
end
