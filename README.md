bus brain
=========
iOS application for bus schedule data in the Twin Cities 




Request nearby stops with a last viewed stop ID in response from a lat/lon near MOA
===================================================================================
curl -H "X-Transit-API-Key: 94adbe66804dbf92e7290de08334d5d0" "http://api.beetlefight.com/bus/v1/stops/nearby.json?lat=44.8447873206953&lon=-93.2392055050438&last_viewed_stop_id=1000"

Request nearby stops with a last viewed stop ID in response
===========================================================
curl -H "X-Transit-API-Key: 94adbe66804dbf92e7290de08334d5d0" "http://api.beetlefight.com/bus/v1/stops/nearby.json?lat=44.8447873206953&lon=-93.2392055050438&last_viewed_stop_id=1000"


Request nearby stops with a last viewed stop ID in response from a lat/lon near MOA, from a time of day
========================================================================================================
curl -H "X-Transit-API-Key: 94adbe66804dbf92e7290de08334d5d0" "http://api.beetlefight.com/bus/v1/stops/nearby.json?lat=44.8447873206953&lon=-93.2392055050438&last_viewed_stop_id=1000&hour=08&minute=10"

Search
------

Request all stops presented with minimal field data for presenting in search UI (warning: 10k+ results)
===============================================================================================
(no data yet AA 9/5)
curl -H "X-Transit-API-Key: 94adbe66804dbf92e7290de08334d5d0" "http://api.beetlefight.com/bus/v1/stops/search.json"