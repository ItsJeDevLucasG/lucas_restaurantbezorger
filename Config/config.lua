Config = {}

Config.Autos = {
    {
        minLevel = 0,
        autoNaam = "pizzaboy"
    },
    {
        minLevel = 1,
        autoNaam = "burrito3"
    },
    {
        minLevel = 2,
        autoNaam = "minivan2"
    }
}

Config.Payouts = {
    bonusPerLevel = 5, -- In procenten
    prijsPerKilometer = {min = 100, max = 150},
    prijsPerItem = 5 -- In procenten je kan dit veranderen met false als je dit systeem wilt uitzetten
}

Config.Restaurants = {
    ["Hornys"] = {
        items = {
            "Chicken Hornstars",
            "Junk",
            "Dubbele Hornburger",
            "Cherry Poppers",
            "Burrito"
        },
        afhaalLocatie = vector3(1263.0483, -364.1436, 69.0614),
        bezorgLocaties = {
            vector3(-732.9186, 593.9563, 142.2260), 
            vector3(-505.6529, 395.5154, 97.4061),
            vector3(-756.6992, 240.4478, 75.6650),
            vector3(-1118.0874, -1487.7366, 4.7179),
            vector3(281.6373, -1694.5696, 29.6479),
            vector3(279.7096, -2043.4003, 19.7676),
            vector3(773.6231, -150.2776, 75.6219),
            vector3(1354.9659, -1690.5834, 60.4912),
            vector3(-975.1565, -1580.8474, 5.1775),
            vector3(-1097.8647, -1673.1947, 8.3940)
        }
    },
    ["Bean Machine"] = {
        items = {
            "Warme Chocolademelk",
            "Cappuccino",
            "Donut",
            "Chai Latte",
            "Limburgse Vlaai",
            "Koffie Zwart"
        },
        afhaalLocatie = vector3(-620.7166, 251.6106, 81.7224),
        bezorgLocaties = {
            vector3(-1960.7932, 212.0920, 86.8041),
            vector3(-1629.5540, 37.1489, 62.9356),
            vector3(-98.4930, 367.0983, 113.2747),
            vector3(311.3461, -203.5689, 54.2218),
            vector3(-291.2542, -430.1815, 30.2375),
            vector3(-271.4940, -693.3950, 34.2771),
            vector3(-166.2984, -662.0157, 40.4785),
            vector3(-83.5091, -835.6987, 40.5574),
            vector3(243.3573, -1073.3716, 29.2854),
            vector3(240.6849, -1379.3643, 33.7417)
        }
    },
    ["Pizzeria"] = {
        items = {
            "Milkshake Aardbei",
            "Nachos",
            "Cappuccino",
            "Pizza Quattro Formaggio",
            "Pizza Pepperoni",
            "Pizza Kip"
        },
        afhaalLocatie = vector3(784.4443, -723.7347, 27.9862),
        bezorgLocaties = {
            vector3(467.1714, -1590.1631, 32.7922),
            vector3(194.8948, -3167.3179, 5.7903),
            vector3(-328.3254, -2700.4580, 7.5495),
            vector3(-19.3868, -2546.1321, 7.3820),
            vector3(368.1088, -2077.8516, 21.7546),
            vector3(360.8264, -2042.3856, 22.3543),
            vector3(208.1409, 74.4826, 96.0959),
            vector3(393.1003, -2015.4630, 23.4031),
            vector3(1203.6049, -598.4739, 68.0636),
            vector3(993.6637, -620.6426, 59.0431),
        }
    },
    ["Koi"] = {
        items = {
            "Koi's Dumpling",
            "Koi's Loempia",
            "Koi's Sushi",
            "Koi's Bubbletea",
            "Koi's Calamares"
        },
        afhaalLocatie = vector3(-1029.0369, -1459.7836, 5.0578),
        bezorgLocaties = {
            vector3(-998.1607, -722.5136, 21.5292),
            vector3(-817.1606, -621.5532, 29.2216),
            vector3(-655.5197, -931.7787, 22.7062),
            vector3(-667.4263, -1106.0939, 14.6343),
            vector3(386.9188, -993.4701, 29.4179),
            vector3(416.8640, -1108.9468, 30.0496),
            vector3(803.7936, -988.6257, 26.1258),
            vector3(340.9104, -214.9713, 54.2218),
            vector3(-458.8281, -401.7866, 34.4475),
            vector3(-825.5430, -262.8558, 38.0022),
        }
    },
    ["Uwu Cafe"] = {
        items = {
            "Matcha Coffee",
            "Aardbei Shortcake",
            "Omurice",
            "Bubble Tea: Jasmine Milk tea",
            "Curry"
        },
        afhaalLocatie = vector3(-569.2513, -1087.1068, 22.3297),
        bezorgLocaties = {
            vector3(-1205.9337, -531.1749, 29.3602),
            vector3(-903.1644, -1005.9150, 2.1491),
            vector3(-740.7635, -1127.1964, 10.8063),
            vector3(-699.0726, -1032.3413, 16.4251),
            vector3(332.4903, -2070.5566, 20.9356),
            vector3(304.5257, -1775.3929, 29.1013),
            vector3(438.8814, -1465.9552, 29.2920),
            vector3(1297.2214, -1618.0017, 54.5802),
            vector3(20.4494, -1505.4348, 31.8501),
            vector3(-342.5193, -1475.1360, 30.7488),
        }
    },
    ["Pearls"] = {
        items = {
            "Haring met Uitjes",
            "Pasta Zalm",
            "Krab Gerecht",
            "eCola Deluxe",
            "Orange Deluxe"
        },
        afhaalLocatie = vector3(-1801.1832, -1177.8925, 13.0175),
        bezorgLocaties = {
            vector3(-25.0757, -988.9194, 29.2618),
            vector3(68.8964, -958.8143, 29.8032),
            vector3(311.2219, -203.3993, 54.2217),
            vector3(65.5164, -137.5052, 55.1124),
            vector3(-23.3996, -106.2019, 57.0583),
            vector3(-60.5700, 25.0366, 72.2277),
            vector3(-333.2865, 101.2442, 71.2179),
            vector3(-569.8787, 169.6804, 66.5655),
            vector3(-723.7996, 73.1434, 55.8554),
            vector3(-674.2667, -123.8437, 37.8678),
        }
    },
    ["Burgershot"] = {
        items = {
            "Sundae Caramel",
            "Spring Burger",
            "Spring Deluxe Burger",
            "Sundae Chocolade",
            "Friet",
            "Loaded Fries"
        },
        afhaalLocatie = vector3(-1174.7443, -873.2407, 14.1245),
        bezorgLocaties = {
            vector3(-480.1165, -692.9053, 33.2119),
            vector3(-156.4428, -602.0773, 48.2432),
            vector3(55.9378, -913.6079, 30.0015),
            vector3(76.9039, -871.9666, 31.5093),
            vector3(508.0660, -1458.2886, 29.5506),
            vector3(253.0462, -1670.9513, 29.6631),
            vector3(10.0431, -1668.4513, 29.2530),
            vector3(-1273.8185, 316.1030, 65.5099),
            vector3(-1662.6617, 236.9170, 62.3909),
            vector3(-1931.9049, 162.4723, 84.6534),
        }
    },
    ["Boat House"] = {
        items = {
            "Pannekoek Kaas",
            "Slushy Aardbei",
            "Churros",
            "Pannekoek Chocopasta",
            "Dame Blance",
            "Slushy Blauwebes"
        },
        afhaalLocatie = vector3(1502.6221, 3763.3284, 33.9923),
        bezorgLocaties = {
            vector3(1968.2986, 4623.4404, 41.0791),
            vector3(1416.9236, 6339.1670, 24.3984),
            vector3(416.3997, 6520.8096, 27.7117),
            vector3(-15.0900, 6557.5542, 33.2405),
            vector3(-359.2179, 6334.1094, 29.8427),
            vector3(-379.7230, 6062.2485, 31.5001),
            vector3(-753.8452, 5578.8447, 36.7096),
            vector3(-2195.4280, 4276.6870, 49.1762),
            vector3(-2544.1296, 2316.0286, 33.2161),
            vector3(180.2502, 2793.3564, 45.6551),
        }
    }
}

Config.Level = {
    {minXp = 0, maxXp = 1000, skillpoint = 1, level = 0},
    {minXp = 1000, maxXp = 2000, skillpoint = 1, level = 1},
    {minXp = 2000, maxXp = 3000, skillpoint = 1, level = 2},
}

Config.Locaties = {
    ['Bezorger'] = {
        naam = "Bezorger",
        pos = vector3(244.7691, 374.9078, 106.1590),
        sprite = 616,
    },
}

Config.Namen = {
    "Alwin Wit",
    "Ross Jansen",
    "Milan de Boer",
    "Lars Hendriks",
    "Jesse van Dijk",
    "Noah Smit",
    "Daan Vos",
    "Finn Meijer",
    "Luuk de Vries",
    "Sem de Jong",
    "Timo Willems",
    "Julian Kramer",
    "Bram Blom",
    "Tom Kuiper",
    "Siem van Dam",
    "Niels Vermeulen",
    "Koen Dekker",
    "Max de Graaf",
    "Levi Post",
    "Ruben Peeters",
    "Ties Mulder",
    "Gijs Driessen",
    "Vince Bakker",
    "Sven Hoekstra",
    "Sam Willemsen",
    "Nick van Leeuwen",
    "Thijs Evers",
    "Jurre Schouten",
    "Boaz Maas",
    "Kai Jacobs",
    "Stijn van Vliet",
    "Jens van den Berg",
    "Tygo van der Linden",
    "Mats Brouwer",
    "Jorn Martens",
    "Dex van der Meer",
    "Job van Beek",
    "Dean van Loon",
    "Mauro van Wijk",
    "Jayden van der Heijden",
    "Rayan Timmer",
    "Tijn Koning",
    "Benjamin de Wit",
    "Xavi Hermans",
    "Damian Bos",
    "Nino van Rossum",
    "Ravi Hensen",
    "Floris de Lange",
    "Thijn Jonker",
    "Cas de Groot",
    "Ilias van Ginkel",
    "Yassin Willems",
    "Luca de Koning",
    "Elian Hagedoorn",
    "Rowan Bovenkamp",
    "Nathan de Haas",
    "Sami van Rijn",
    "Olivier van der Ven",
    "Jace Verbeek",
    "Kenji van den Brink",
    "Jace van Dongen",
    "Amir de Klerk",
    "Dylan van der Pol",
    "Jayce van de Water",
    "Noël van der Wal",
    "Jaylen Smits",
    "Senn Beukers",
    "Ischa van Driel",
    "Leon Reinders",
    "Dean van Gorp",
    "Alec Rutgers",
    "Timo Bekkering",
    "Nout Vissers",
    "Matthijs de Ruiter",
    "Zion van Veen",
    "Jayden Geerts",
    "Mees van de Ven",
    "Youri Scholten",
    "Delano van der Zee",
    "Tygo Stappers",
    "Jay Smeets",
    "Dani van Wassenaar",
    "Tijl Eijkelkamp",
    "Kyan Mulders",
    "Ravi Coenen",
    "Brent van der Voort",
    "Giovanni Koster",
    "Lennart Wouters",
    "Noël Steenbergen",
    "Xem de Jong",
    "Jurre Veldman",
    "Dylan van Es",
    "Luca Roos",
    "Rowin Gerritsen",
    "Milan Oosterbaan",
    "Timo Molenaar",
    "Noah Reijnders",
    "Kay Zwart",
    "Damian van Egmond",
    "Jayden Roelofs",
    "Daniël van Schaik"
}