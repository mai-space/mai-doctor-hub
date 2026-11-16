from arztsuche.text import norm_key, parse_address


def test_norm_key_vereinheitlicht_strasse():
    assert norm_key("Hauptstr.") == norm_key("Haupt-Straße") == "hauptstrasse"
    assert norm_key("Müllerweg") == "muellerweg"


def test_parse_address_varianten():
    a = parse_address("Musterstr. 5, 10115 Berlin")
    assert (a.street, a.postcode, a.city) == ("Musterstr.", "10115", "Berlin")
    assert parse_address("10115").postcode == "10115"
    assert parse_address("Köln").city == "Köln"
    b = parse_address("Musterstraße 5 Berlin")
    assert (b.street, b.city) == ("Musterstraße", "Berlin")
    assert parse_address("Domgasse 2a").street == "Domgasse"
