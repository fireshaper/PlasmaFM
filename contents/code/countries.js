// Country coordinates lookup
// Returns approximate coordinates (usually capital city) for each country
.pragma library

const COUNTRY_COORDS = {
    "Afghanistan": [34.5553, 69.2075],
    "Albania": [41.3275, 19.8187],
    "Algeria": [36.7538, 3.0588],
    "Argentina": [-34.6037, -58.3816],
    "Armenia": [40.1792, 44.4991],
    "Australia": [-35.2809, 149.1300],
    "Austria": [48.2082, 16.3738],
    "Azerbaijan": [40.4093, 49.8671],
    "Bahrain": [26.0667, 50.5577],
    "Bangladesh": [23.8103, 90.4125],
    "Belarus": [53.9045, 27.5615],
    "Belgium": [50.8503, 4.3517],
    "Bolivia": [-16.5000, -68.1500],
    "Bosnia and Herzegovina": [43.8564, 18.4131],
    "Brazil": [-15.8267, -47.9218],
    "Bulgaria": [42.6977, 23.3219],
    "Cambodia": [11.5564, 104.9282],
    "Canada": [45.4215, -75.6972],
    "Chile": [-33.4489, -70.6693],
    "China": [39.9042, 116.4074],
    "Colombia": [4.7110, -74.0721],
    "Costa Rica": [9.9281, -84.0907],
    "Croatia": [45.8150, 15.9819],
    "Cuba": [23.1136, -82.3666],
    "Cyprus": [35.1264, 33.4299],
    "Czech Republic": [50.0755, 14.4378],
    "Czechia": [50.0755, 14.4378],
    "Denmark": [55.6761, 12.5683],
    "Dominican Republic": [18.4861, -69.9312],
    "Ecuador": [-0.1807, -78.4678],
    "Egypt": [30.0444, 31.2357],
    "Estonia": [59.4370, 24.7536],
    "Ethiopia": [9.0320, 38.7469],
    "Finland": [60.1699, 24.9384],
    "France": [48.8566, 2.3522],
    "Georgia": [41.7151, 44.8271],
    "Germany": [52.5200, 13.4050],
    "Ghana": [5.6037, -0.1870],
    "Greece": [37.9838, 23.7275],
    "Guatemala": [14.6349, -90.5069],
    "Honduras": [14.0723, -87.1921],
    "Hong Kong": [22.3193, 114.1694],
    "Hungary": [47.4979, 19.0402],
    "Iceland": [64.1466, -21.9426],
    "India": [28.6139, 77.2090],
    "Indonesia": [-6.2088, 106.8456],
    "Iran": [35.6892, 51.3890],
    "Iraq": [33.3152, 44.3661],
    "Ireland": [53.3498, -6.2603],
    "Israel": [31.7683, 35.2137],
    "Italy": [41.9028, 12.4964],
    "Jamaica": [18.0179, -76.8099],
    "Japan": [35.6762, 139.6503],
    "Jordan": [31.9454, 35.9284],
    "Kazakhstan": [51.1694, 71.4491],
    "Kenya": [-1.2921, 36.8219],
    "Kosovo": [42.6629, 21.1655],
    "Kuwait": [29.3759, 47.9774],
    "Kyrgyzstan": [42.8746, 74.5698],
    "Latvia": [56.9496, 24.1052],
    "Lebanon": [33.8886, 35.4955],
    "Libya": [32.8872, 13.1913],
    "Lithuania": [54.6872, 25.2797],
    "Luxembourg": [49.6116, 6.1319],
    "Macedonia": [41.9973, 21.4280],
    "North Macedonia": [41.9973, 21.4280],
    "Malaysia": [3.1390, 101.6869],
    "Malta": [35.8989, 14.5146],
    "Mexico": [19.4326, -99.1332],
    "Moldova": [47.0105, 28.8638],
    "Monaco": [43.7384, 7.4246],
    "Mongolia": [47.8864, 106.9057],
    "Montenegro": [42.4304, 19.2594],
    "Morocco": [33.9716, -6.8498],
    "Nepal": [27.7172, 85.3240],
    "Netherlands": [52.3676, 4.9041],
    "New Zealand": [-41.2865, 174.7762],
    "Nigeria": [9.0765, 7.3986],
    "Norway": [59.9139, 10.7522],
    "Oman": [23.5880, 58.3829],
    "Pakistan": [33.6844, 73.0479],
    "Palestine": [31.9522, 35.2332],
    "Panama": [8.9824, -79.5199],
    "Paraguay": [-25.2637, -57.5759],
    "Peru": [-12.0464, -77.0428],
    "Philippines": [14.5995, 120.9842],
    "Poland": [52.2297, 21.0122],
    "Portugal": [38.7223, -9.1393],
    "Qatar": [25.2854, 51.5310],
    "Romania": [44.4268, 26.1025],
    "Russia": [55.7558, 37.6173],
    "Saudi Arabia": [24.7136, 46.6753],
    "Serbia": [44.7866, 20.4489],
    "Singapore": [1.3521, 103.8198],
    "Slovakia": [48.1486, 17.1077],
    "Slovenia": [46.0569, 14.5058],
    "South Africa": [-25.7479, 28.2293],
    "South Korea": [37.5665, 126.9780],
    "Spain": [40.4168, -3.7038],
    "Sri Lanka": [6.9271, 79.8612],
    "Sweden": [59.3293, 18.0686],
    "Switzerland": [46.9480, 7.4474],
    "Syria": [33.5138, 36.2765],
    "Taiwan": [25.0330, 121.5654],
    "Thailand": [13.7563, 100.5018],
    "Tunisia": [36.8065, 10.1815],
    "Turkey": [39.9334, 32.8597],
    "UAE": [24.4539, 54.3773],
    "Ukraine": [50.4501, 30.5234],
    "United Arab Emirates": [24.4539, 54.3773],
    "United Kingdom": [51.5074, -0.1278],
    "UK": [51.5074, -0.1278],
    "USA": [38.9072, -77.0369],
    "United States": [38.9072, -77.0369],
    "Uruguay": [-34.9011, -56.1645],
    "Uzbekistan": [41.2995, 69.2401],
    "Venezuela": [10.4806, -66.9036],
    "Vietnam": [21.0285, 105.8542],
    "Yemen": [15.5527, 48.5164]
};

function getCountryCoordinates(countryName) {
    if (!countryName) {
        return null;
    }

    // Try exact match first
    if (COUNTRY_COORDS[countryName]) {
        return {
            lat: COUNTRY_COORDS[countryName][0],
            lon: COUNTRY_COORDS[countryName][1]
        };
    }

    // Try case-insensitive match
    const lowerCountry = countryName.toLowerCase();
    for (const key in COUNTRY_COORDS) {
        if (key.toLowerCase() === lowerCountry) {
            return {
                lat: COUNTRY_COORDS[key][0],
                lon: COUNTRY_COORDS[key][1]
            };
        }
    }

    // Try partial match (e.g., "United States of America" matches "United States")
    for (const key in COUNTRY_COORDS) {
        if (lowerCountry.includes(key.toLowerCase()) || key.toLowerCase().includes(lowerCountry)) {
            return {
                lat: COUNTRY_COORDS[key][0],
                lon: COUNTRY_COORDS[key][1]
            };
        }
    }

    return null;
}
