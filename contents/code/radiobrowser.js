// Radio Browser API integration
.pragma library

const API_BASE = "https://de1.api.radio-browser.info/json";

// Fetch random stations with filters
function fetchRandomStations(minBitrate, excludedLanguages, count, callback) {
    const xhr = new XMLHttpRequest();
    
    // Build query parameters
    let params = [];
    if (minBitrate > 0) {
        params.push("bitrateMin=" + minBitrate);
    }
    params.push("limit=" + (count || 100));
    params.push("hidebroken=true");
    params.push("order=random");
    
    const url = API_BASE + "/stations/search?" + params.join("&");
    
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                try {
                    const stations = JSON.parse(xhr.responseText);
                    
                    // Filter out excluded languages
                    let filtered = stations;
                    if (excludedLanguages && excludedLanguages.length > 0) {
                        filtered = stations.filter(function(station) {
                            const lang = (station.language || "").toLowerCase();
                            return !excludedLanguages.some(function(excluded) {
                                return lang.includes(excluded.toLowerCase());
                            });
                        });
                    }
                    
                    // Filter out stations without valid URLs
                    filtered = filtered.filter(function(station) {
                        return station.url_resolved && station.url_resolved.length > 0;
                    });
                    
                    callback(filtered, null);
                } catch (e) {
                    callback(null, "Failed to parse response: " + e.message);
                }
            } else {
                callback(null, "HTTP error: " + xhr.status);
            }
        }
    };
    
    xhr.open("GET", url);
    xhr.setRequestHeader("User-Agent", "RoamRadio/1.0");
    xhr.send();
}

// Get a random station from the list
function getRandomStation(stations) {
    if (!stations || stations.length === 0) {
        return null;
    }
    const index = Math.floor(Math.random() * stations.length);
    return stations[index];
}

// Click station (increment click count on radio-browser)
function clickStation(stationUuid) {
    if (!stationUuid) return;
    
    const xhr = new XMLHttpRequest();
    const url = API_BASE + "/url/" + stationUuid;
    
    xhr.open("GET", url);
    xhr.setRequestHeader("User-Agent", "RoamRadio/1.0");
    xhr.send();
}

// Parse station info for display
function getStationInfo(station) {
    if (!station) {
        return {
            name: "No Station",
            country: "",
            bitrate: "",
            codec: "",
            url: ""
        };
    }
    
    return {
        name: station.name || "Unknown Station",
        country: station.country || "",
        bitrate: station.bitrate ? station.bitrate + " kbps" : "",
        codec: station.codec || "",
        url: station.url_resolved || station.url || "",
        uuid: station.stationuuid || "",
        language: station.language || "",
        tags: station.tags || "",
        favicon: station.favicon || ""
    };
}

// Search stations by name
function searchStations(query, callback) {
    const xhr = new XMLHttpRequest();
    const url = API_BASE + "/stations/byname/" + encodeURIComponent(query);
    
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                try {
                    const stations = JSON.parse(xhr.responseText);
                    callback(stations, null);
                } catch (e) {
                    callback(null, "Failed to parse response: " + e.message);
                }
            } else {
                callback(null, "HTTP error: " + xhr.status);
            }
        }
    };
    
    xhr.open("GET", url);
    xhr.setRequestHeader("User-Agent", "RoamRadio/1.0");
    xhr.send();
}
