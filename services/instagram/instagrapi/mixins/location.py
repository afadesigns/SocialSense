import base64
import json
from typing import List, Tuple, Union

from instagrapi.exceptions import ClientNotFoundError, LocationNotFound, WrongCursorError
from instagrapi.extractors import extract_guide_v1, extract_location, extract_media_v1
from instagrapi.types import Guide, Location, LocationInfoParams, Media

tab_keys_a1 = ("edge_location_to_top_posts", "edge_location_to_media")
tab_keys_v1 = ("ranked", "recent")

class LocationMixin:
    """
    Helper class to get location
    """

    def location_search(self, lat: float, lng: float) -> List[Location]:
        """
        Get locations using lat and long

        Parameters
        ----------
        lat: float
            Latitude you want to search for
        lng: float
            Longitude you want to search for

        Returns
        -------
        List[Location]
            List of objects of Location
        """
        params = {
            "latitude": lat,
            "longitude": lng,
        }
        result = self.private_request("location_search/", params=params)
        locations = []
        for venue in result["venues"]:
            if "lat" not in venue:
                venue["lat"] = lat
                venue["lng"] = lng
            locations.append(extract_location(venue))
        return locations

    def location_complete(self, location: Union[Location, LocationInfoParams]) -> Location:
        """
        Smart complete of location

        Parameters
        ----------
        location: Union[Location, LocationInfoParams]
            An object of location or LocationInfoParams

        Returns
        -------
        Location
            An object of Location
        """
        if not location or not isinstance(location, (Location, LocationInfoParams)):
            raise ValueError("Invalid location object")

        if isinstance(location, LocationInfoParams):
            location = self.location_info(location.pk)

        if location.pk and not location.lat:
            # search lat and lng
            info = self.location_info(location.pk)
            location.lat = info.lat
            location.lng = info.lng
        if not location.external_id and location.lat:
            # search extrernal_id and external_id_source
            try:
                venue = self.location_search(location.lat, location.lng)[0]
                location.external_id = venue.external_id
                location.external_id_source = venue.external_id_source
            except IndexError:
                pass
        if not location.pk and location.external_id:
            info = self.location_info(location.external_id)
            if info.name == location.name or (
                info.lat == location.lat and info.lng == location.lng
            ):
                location.pk = location.external_id
        return location

    def location_build(self, location: Location) -> str:
        """
        Build correct location data

        Parameters
        ----------
        location: Location
            An object of location

        Returns
        -------
        str
        """
        if not location:
            return "{}"
        if not location.external_id and location.lat:
            try:
                location = self.location_search(location.lat, location.lng)[0]
            except IndexError:
                pass
        data = {
            "name": location.name,
            "address": location.address,
            "lat": location.lat,
            "lng": location.lng,
            "external_source": location.external_id_source,
            "facebook_places_id": location.external_id,
        }
        return json.dumps(data, separators=(",", ":"
