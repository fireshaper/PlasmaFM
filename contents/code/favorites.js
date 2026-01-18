// Favorites management
.pragma library

// Load favorites from config string
function loadFavorites(configString) {
    try {
        if (!configString || configString === "[]") {
            return [];
        }
        return JSON.parse(configString);
    } catch (e) {
        console.error("Failed to load favorites:", e);
        return [];
    }
}

// Save favorites to config string
function saveFavorites(favorites) {
    try {
        return JSON.stringify(favorites);
    } catch (e) {
        console.error("Failed to save favorites:", e);
        return "[]";
    }
}

// Add station to favorites
function addFavorite(favorites, station) {
    // Check if already in favorites
    const exists = favorites.some(function (fav) {
        return fav.uuid === station.uuid;
    });

    if (exists) {
        return favorites;
    }

    // Create favorite object
    const favorite = {
        uuid: station.uuid,
        name: station.name,
        country: station.country,
        url: station.url,
        bitrate: station.bitrate,
        codec: station.codec,
        favicon: station.favicon || "",
        language: station.language || "",
        tags: station.tags || ""
    };

    // Add to beginning of array
    const newFavorites = [favorite].concat(favorites);
    return newFavorites;
}

// Remove station from favorites
function removeFavorite(favorites, stationUuid) {
    return favorites.filter(function (fav) {
        return fav.uuid !== stationUuid;
    });
}

// Check if station is in favorites
function isFavorite(favorites, stationUuid) {
    return favorites.some(function (fav) {
        return fav.uuid === stationUuid;
    });
}

// Get favorite by UUID
function getFavorite(favorites, stationUuid) {
    for (let i = 0; i < favorites.length; i++) {
        if (favorites[i].uuid === stationUuid) {
            return favorites[i];
        }
    }
    return null;
}
