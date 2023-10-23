# frozen_string_literal: true

module Spree
  module FavoritesHelper
    def favorite_count
      try_spree_current_user.favorites.count || 0
    end

    def get_favorite(object)
      try_spree_current_user.favorites.find_by_favorable_id_and_favorable_type(
        object.id, object.class.to_s
      )
    end

    def has_favorite?(object)
      try_spree_current_user&.has_favorite?(object)
    end
  end
end

# touched on 2025-05-22T19:23:43.764899Z
# touched on 2025-05-22T20:39:53.021281Z
# touched on 2025-05-22T21:30:33.466408Z
# touched on 2025-05-22T22:55:10.195421Z
# touched on 2025-05-22T23:08:27.764010Z
# touched on 2025-05-22T23:23:52.255566Z
