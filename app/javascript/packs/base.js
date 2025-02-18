import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "owl.carousel/dist/assets/owl.carousel.css"
import "owl.carousel"
import "spree/navbar_v2"
import "spree/home_page"
import "spree/home_page_v2"
import "spree/flash"
import "spree/user"
import "spree/help_scout"
import "spree/gtm_event"
import "cleave.js"
import moment from 'moment'
window.moment = moment
import 'moment-timezone'
import "spree/ffa_chapter"
import "spree/ffa_home"
import "spree/algolia_search"
import "spree/ag_modal"
import "spree/tooltip"
import "spree/chuckwagon_dvd"
import "spree/chuckwagon_dvd_product"
import "spree/cart_v2"
import "spree/deals"
import "spree/cards_slider"
import "spree/mobile_footer"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

# touched on 2025-05-22T23:39:48.978531Z

# touched on 2025-06-13T21:21:59.882352Z